import 'package:flutter/material.dart';

import 'routes.dart';
import 'screens/add_recipe_screen.dart';
import 'screens/edit_recipe_screen.dart';
import 'screens/login_screen.dart';
import 'screens/recipe_detail_screen/recipe_detail_screen.dart';
import 'screens/recipes_screen.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var screen = _getScreen(settings);
    return MaterialPageRoute<dynamic>(builder: (context) => screen);
  }

  static Widget _getScreen(RouteSettings settings) {
    final arguments = settings.arguments as Map<String, dynamic>;
    switch (settings.name) {
      case Routes.recipes:
        return const RecipesScreen();
      case Routes.login:
        return const LoginScreen();
      case Routes.addRecipe:
        return const AddRecipeScreen();
      case Routes.editRecipe:
        final recipeId = arguments['recipeId'] as String;
        return EditRecipeScreen(recipeId: recipeId);
      case Routes.recipe:
        final recipeId = arguments['recipeId'] as String;
        return RecipeDetailScreen(recipeId: recipeId);
      default:
        return const LoginScreen();
    }
  }
}
