import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

import '../models/recipe.dart';

class RecipeRepository {
  const RecipeRepository(this.database);

  final DatabaseReference database;

  DatabaseReference _getRecipeDatabase(String crewId) {
    return database.child('crews/$crewId/recipes');
  }

  Stream<List<Recipe>> recipes(String crewId) {
    return _getRecipeDatabase(crewId).onValue.map((event) {
      final recipeMap =
          jsonDecode(jsonEncode(event.snapshot.value)) as Map<String, dynamic>;

      return List<Recipe>.from(recipeMap.entries.map<Recipe>((entry) =>
          Recipe.fromJson(entry.key, entry.value as Map<String, dynamic>)));
    });
  }

  Stream<Recipe> recipe(String id, String crewId) {
    return _getRecipeDatabase(crewId).child(id).onValue.map((event) {
      final recipe =
          jsonDecode(jsonEncode(event.snapshot.value)) as Map<String, dynamic>;
      return Recipe.fromJson(id, recipe);
    });
  }

  Future<void> addRecipe(Recipe recipe, String crewId) {
    return _getRecipeDatabase(crewId).push().set(recipe.toJson());
  }

  Future<void> updateRecipe(Recipe recipe, String crewId) {
    return _getRecipeDatabase(crewId).child(recipe.id).update(recipe.toJson());
  }

  Future<void> deleteRecipe(String id, String crewId) {
    return _getRecipeDatabase(crewId).child(id).remove();
  }
}
