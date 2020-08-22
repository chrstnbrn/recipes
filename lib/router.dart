import 'package:flutter/material.dart';
import 'package:recipes/routes.dart';
import 'package:recipes/screens/add_recipe.dart';
import 'package:recipes/screens/login.dart';
import 'package:recipes/screens/recipe_detail.dart';
import 'package:recipes/screens/recipes.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var screen = _getScreen(settings);
    return MaterialPageRoute(builder: (BuildContext context) => screen);
  }

  static _getScreen(RouteSettings settings) {
    final Map<String, dynamic> arguments = settings.arguments;
    switch (settings.name) {
      case Routes.recipes:
        return Recipes();
      case Routes.login:
        return Login();
      case Routes.addRecipe:
        return AddRecipeScreen();
      case Routes.recipe:
        return RecipeDetailScreen(recipe: arguments["recipe"]);
      default:
        return Routes.login;
    }
  }
}
