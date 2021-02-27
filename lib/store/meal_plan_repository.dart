import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
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
          .where((element) => DateTime.tryParse(element.key) == null)
          .expand((e) => _getRecipeIds(e.value))
          .toList();

      final plannedMeals = Map.fromEntries(mapValue.entries
          .map((e) => MapEntry(
                DateTime.tryParse(e.key),
                _getRecipeIds(e.value),
              ))
          .where((e) => e.key != null));

      return MealPlan(
        unplannedMeals: unplannedMeals,
        plannedMeals: plannedMeals,
      );
    });
  }

  Future<void> addUnplannedMeal(String recipeId, String crewId) {
    return _getMealPlanDatabase(crewId).child('unplanned').push().set(recipeId);
  }

  Future<void> addMealForDate(DateTime date, String recipeId, String crewId) {
    return _getMealPlanDatabase(crewId)
        .child(date.toIso8601String())
        .push()
        .set(recipeId);
  }

  Future<void> removeMeal(DateTime date, String recipeId, String crewId) {
    return _getMealPlanDatabase(crewId)
        .child(date.toIso8601String())
        .child(recipeId)
        .remove();
  }

  List<String> _getRecipeIds(dynamic recipeIdsMap) {
    return Map<String, String>.from(recipeIdsMap as Map<dynamic, dynamic>)
        .values
        .toList();
  }
}
