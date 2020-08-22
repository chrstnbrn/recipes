import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:recipes/store/recipe_repository.dart';
import 'package:recipes/theme/style.dart';

import 'screens/recipes.dart';

void main() => runApp(RecipesApp());

class RecipesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return CircularProgressIndicator(
              backgroundColor: Theme.of(context).errorColor,
            );
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
                title: 'Recipes',
                theme: appTheme(),
                home: Recipes(
                    title: 'Recipes',
                    repository: new RecipeRepository(
                        FirebaseDatabase.instance.reference())));
          }

          return CircularProgressIndicator();
        });
  }
}
