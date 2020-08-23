import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:recipes/models/recipe.dart';

class RecipeRepository {
  final DatabaseReference database;

  const RecipeRepository(this.database);

  DatabaseReference get recipeDatabase => this.database.child("recipes");

  Stream<List<Recipe>> recipes() {
    return recipeDatabase.onValue.map((event) {
      Map<String, dynamic> recipeMap =
          jsonDecode(jsonEncode(event.snapshot.value));

      return List<Recipe>.from(recipeMap.entries
          .map((entry) => Recipe.fromJson(entry.key, entry.value)));
    });
  }

  Future<void> addRecipe(Recipe recipe) {
    return recipeDatabase.push().set(recipe.toJson());
  }

  Future<void> updateRecipe(Recipe recipe) {
    return recipeDatabase.child(recipe.id).update(recipe.toJson());
  }

  Future<void> deleteRecipe(String id) {
    return recipeDatabase.child(id).remove();
  }
}
