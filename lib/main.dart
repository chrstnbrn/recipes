import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes/providers/auth_provider.dart';
import 'package:recipes/screens/add_recipe.dart';
import 'package:recipes/screens/login.dart';
import 'package:recipes/screens/recipe_detail.dart';
import 'package:recipes/screens/recipes.dart';
import 'package:recipes/store/recipe_repository.dart';
import 'package:recipes/theme/style.dart';

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

          if (snapshot.connectionState == ConnectionState.done) {
            return MultiProvider(
                providers: [
                  ChangeNotifierProvider<AuthProvider>(
                      create: (context) => AuthProvider()),
                  Provider<RecipeRepository>(
                      create: (context) => new RecipeRepository(
                          FirebaseDatabase.instance.reference())),
                ],
                child: Builder(builder: (context) {
                  var authProvider = Provider.of<AuthProvider>(context);
                  return MaterialApp(
                      title: "Recipes",
                      theme: appTheme(),
                      initialRoute:
                          authProvider.isAuthenticated ? "/" : "/login",
                      routes: {
                        '/': (context) => Recipes(),
                        '/login': (context) => Login(),
                        '/recipe': (context) => RecipeDetailScreen(),
                        '/addRecipe': (context) => AddRecipeScreen()
                      });
                }));
          }

          return CircularProgressIndicator();
        });
  }
}
