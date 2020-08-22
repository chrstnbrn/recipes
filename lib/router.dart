import 'package:flutter/material.dart';
import 'package:recipes/routes.dart';
import 'package:recipes/screens/add_recipe_screen.dart';
import 'package:recipes/screens/edit_recipe_screen.dart';
import 'package:recipes/screens/login_screen.dart';
import 'package:recipes/screens/recipe_detail_screen.dart';
import 'package:recipes/screens/recipes_screen.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var screen = _getScreen(settings);
    return MaterialPageRoute(builder: (BuildContext context) => screen);
  }

  static _getScreen(RouteSettings settings) {
    final Map<String, dynamic> arguments = settings.arguments;
    switch (settings.name) {
      case Routes.recipes:
        return RecipesScreen();
      case Routes.login:
        return LoginScreen();
      case Routes.addRecipe:
        return AddRecipeScreen();
      case Routes.editRecipe:
        return EditRecipeScreen(recipe: arguments["recipe"]);
      case Routes.recipe:
        return RecipeDetailScreen(recipe: arguments["recipe"]);
      default:
        return Routes.login;
    }
  }
}
