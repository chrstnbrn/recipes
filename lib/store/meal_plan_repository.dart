import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import '../models/meal_plan.dart';

class MealPlanRepository {
  const MealPlanRepository(this.database);

  final DatabaseReference database;

  DatabaseReference _getMealPlanDatabase(String crewId) {
    return database.child('crews/$crewId/mealPlan');
  }

  Stream<MealPlan> getMealPlan(String crewId) {
    return _getMealPlanDatabase(crewId).onValue.map((event) {
      if (event.snapshot.value == null) {
        return MealPlan(
          unplannedMeals: <String>[],
          plannedMeals: <DateTime, List<String>>{},
        );
      }

      final mapValue =
          jsonDecode(jsonEncode(event.snapshot.value)) as Map<String, dynamic>;

      final unplannedMeals = mapValue.entries
          .where((element) => _tryParseUtcDate(element.key) == null)
          .expand((e) => _getRecipeIds(e.value))
          .toList();

      final plannedMeals = Map.fromEntries(mapValue.entries
          .map((e) => MapEntry(
                _tryParseUtcDate(e.key),
                _getRecipeIds(e.value),
              ))
          .where((e) => e.key != null));

      return MealPlan(
        unplannedMeals: unplannedMeals,
        plannedMeals: plannedMeals,
      );
    });
  }

  Future<void> addUnplannedMeal(String crewId, String recipeId) {
    return _getMealPlanDatabase(crewId).child('unplanned').push().set(recipeId);
  }

  Future<void> updateUnplannedMeals(String crewId, List<String> recipeIds) {
    return _getMealPlanDatabase(crewId).child('unplanned').set(recipeIds);
  }

  Future<void> updatePlannedMealsForDay(
    String crewId,
    DateTime date,
    List<String> recipeIds,
  ) {
    return _getMealPlanDatabase(crewId).child(getKey(date)).set(recipeIds);
  }

  List<String> _getRecipeIds(dynamic recipeIdsMap) {
    if (recipeIdsMap is List<dynamic>) {
      return recipeIdsMap.map((dynamic x) => x.toString()).toList();
    }
    return Map<String, String>.from(recipeIdsMap as Map<dynamic, dynamic>)
        .values
        .toList();
  }

  DateTime _tryParseUtcDate(String value) {
    if (value == 'unplanned') {
      return null;
    }

    return DateTime.tryParse('${value}T00:00:00Z');
  }

  String getKey(DateTime date) {
    if (date == null) {
      return 'unplanned';
    }

    var format = DateFormat('yyyy-MM-dd');
    return format.format(date);
  }
}
