import 'package:flutter/material.dart';

import 'models/recipe_step.dart';
import 'routes.dart';
import 'screens/add_recipe_screen.dart';
import 'screens/edit_recipe_screen.dart';
import 'screens/login_screen.dart';
import 'screens/recipe_detail_screen/recipe_detail_screen.dart';
import 'screens/recipe_step_screen/recipe_step_screen.dart';
import 'screens/recipes_screen.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments as Map<String, dynamic>;
    switch (settings.name) {
      case Routes.recipes:
        return MaterialPageRoute<dynamic>(
          builder: (context) => const RecipesScreen(),
        );
      case Routes.login:
        return MaterialPageRoute<dynamic>(
          builder: (context) => const LoginScreen(),
        );
      case Routes.addRecipe:
        return MaterialPageRoute<dynamic>(
          builder: (context) => const AddRecipeScreen(),
        );
      case Routes.editRecipe:
        final recipeId = arguments['recipeId'] as String;
        return MaterialPageRoute<dynamic>(
          builder: (context) => EditRecipeScreen(recipeId: recipeId),
        );
      case Routes.recipe:
        final recipeId = arguments['recipeId'] as String;
        return MaterialPageRoute<dynamic>(
          builder: (context) => RecipeDetailScreen(recipeId: recipeId),
        );
      case Routes.stepForm:
        final title = arguments['title'] as String;
        final step = arguments['step'] as RecipeStep;
        return MaterialPageRoute<RecipeStep>(
          builder: (context) => RecipeStepScreen(
            title: title,
            step: step,
          ),
        );
      default:
        return MaterialPageRoute<dynamic>(
          builder: (context) => const LoginScreen(),
        );
    }
  }
}
