import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:recipes/models/recipe.dart';

class RecipeRepository {
  final DatabaseReference database;

  const RecipeRepository(this.database);

  Stream<List<Recipe>> recipes() {
    return database.onValue.map((event) {
      var result = jsonDecode(jsonEncode(event.snapshot.value));
      return List<Recipe>.from(
          result["recipes"].map((recipe) => recipeFromJson(recipe)));
    });
  }

  Future<void> addRecipe(Recipe recipe) {
    var recipeDatabase = database.child('recipes');
    return recipeDatabase.push().set(recipe.toJson());
  }

  // Future<void> deleteRecipe(List<String> idList) async {
  //   await Future.wait<void>(idList.map((id) {
  //     return firestore.collection(path).document(id).delete();
  //   }));
  // }

  // Future<void> updateRecipe(Recipe recipe) {
  //   return firestore
  //       .collection(path)
  //       .document(todo.id)
  //       .updateData(todo.toJson());
  // }
}
