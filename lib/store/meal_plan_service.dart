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
          final mealPlanUnplanned = MealPlanDayViewModel(null, unplannedMeals);

          final days = _getNextDays(7)
              .map((day) => MealPlanDayViewModel(
                  day, _getRecipesForDay(day, mealPlan, recipeMap)))
              .toList();

          return MealPlanViewModel(
            unplannedMeals: mealPlanUnplanned,
            plannedMeals: days,
          );
        },
      );

  List<DateTime> _getNextDays(int count) {
    var now = DateTime.now();
    var today = DateTime.utc(now.year, now.month, now.day);
    return List<DateTime>.generate(
      count,
      (index) => today.add(Duration(days: index)),
    );
  }

  List<Recipe> _getRecipesForDay(
    DateTime day,
    MealPlan mealPlan,
    Map<String, Recipe> recipeMap,
  ) {
    if (!mealPlan.plannedMeals.containsKey(day)) {
      return <Recipe>[];
    }

    return mealPlan.plannedMeals[day].map((id) => recipeMap[id]).toList();
  }

  void moveMeal(
    MealPlanDayViewModel source,
    int sourceIndex,
    MealPlanDayViewModel target,
    int targetIndex,
  ) {
    if (source == target) {
      var recipeIds = _getRecipeIds(source);
      _moveElement(recipeIds, sourceIndex, targetIndex);
      mealPlanRepository.updatePlannedMealsForDay(
        crewId,
        source.day,
        recipeIds,
      );
    } else {
      var sourceRecipeIds = _getRecipeIds(source);
      var recipeId = sourceRecipeIds[sourceIndex];
      sourceRecipeIds.removeAt(sourceIndex);

      var targetRecipeIds = _getRecipeIds(target)
        ..insert(targetIndex, recipeId);

      mealPlanRepository
        ..updatePlannedMealsForDay(crewId, source.day, sourceRecipeIds)
        ..updatePlannedMealsForDay(crewId, target.day, targetRecipeIds);
    }
  }

  List<String> _getRecipeIds(MealPlanDayViewModel mealPlan) {
    return mealPlan.recipes.map((r) => r.id).toList();
  }

  void _moveElement(List<String> values, int sourceIndex, int targetIndex) {
    var value = values[sourceIndex];
    if (sourceIndex > targetIndex) {
      values
        ..removeAt(sourceIndex)
        ..insert(targetIndex, value);
    } else {
      values
        ..insert(targetIndex, value)
        ..removeAt(sourceIndex);
    }
  }
}
