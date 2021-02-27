import 'package:rxdart/rxdart.dart';

import '../models/meal_plan.dart';
import '../models/meal_plan_view_model.dart';
import '../models/recipe.dart';
import 'meal_plan_repository.dart';
import 'recipe_repository.dart';

class MealPlanService {
  MealPlanService(
      {this.crewId, this.mealPlanRepository, this.recipeRepository});

  final String crewId;
  final MealPlanRepository mealPlanRepository;
  final RecipeRepository recipeRepository;

  Stream<MealPlanViewModel> get mealPlanViewModel$ =>
      Rx.combineLatest2<MealPlan, List<Recipe>, MealPlanViewModel>(
        mealPlanRepository.getMealPlan(crewId),
        recipeRepository.recipes(crewId),
        (mealPlan, recipes) {
          final recipeMap =
              Map.fromEntries(recipes.map((r) => MapEntry(r.id, r)));

          final unplannedMeals =
              mealPlan.unplannedMeals.map((id) => recipeMap[id]).toList();

          return MealPlanViewModel(
            unplannedMeals: unplannedMeals,
            days: <DateTime, List<Recipe>>{},
          );
        },
      );
}
