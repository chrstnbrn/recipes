import 'package:flutter/material.dart';

import 'models/recipe.dart';
import 'models/recipe_step.dart';
import 'routes.dart';
import 'screens/add_recipe_screen.dart';
import 'screens/edit_recipe_screen.dart';
import 'screens/meal_plan_screen/meal_plan_screen.dart';
import 'screens/recipe_detail_screen/recipe_detail_screen.dart';
import 'screens/recipe_instruction_screen/recipe_instruction_screen.dart';
import 'screens/recipe_step_screen/recipe_step_screen.dart';
import 'screens/recipes_screen.dart';
import 'screens/settings_screen.dart/settings_screen.dart';
import 'screens/shopping_list_screen/shopping_list_screen.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments as Map<String, dynamic>;
    switch (settings.name) {
      case Routes.recipes:
        return MaterialPageRoute<dynamic>(
          builder: (context) => const RecipesScreen(),
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
          builder: (context) => RecipeStepScreen(title: title, step: step),
        );
      case Routes.recipeInstruction:
        final recipe = arguments['recipe'] as Recipe;
        return MaterialPageRoute<dynamic>(
          builder: (context) => RecipeInstructionScreen(recipe: recipe),
        );
      case Routes.mealPlan:
        return MaterialPageRoute<dynamic>(
          builder: (context) => const MealPlanScreen(),
        );
      case Routes.shoppingList:
        return MaterialPageRoute<dynamic>(
          builder: (context) => const ShoppingListScreen(),
        );
      case Routes.settings:
        return MaterialPageRoute<dynamic>(
          builder: (context) => const SettingsScreen(),
        );
      default:
        return MaterialPageRoute<dynamic>(
          builder: (context) => const RecipesScreen(),
        );
    }
  }
}
