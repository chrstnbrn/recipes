import 'package:meta/meta.dart';

import 'recipe.dart';

class MealPlanViewModel {
  MealPlanViewModel({
    @required this.unplannedMeals,
    @required this.plannedMeals,
  });

  MealPlanDayViewModel unplannedMeals;
  List<MealPlanDayViewModel> plannedMeals;
}

class MealPlanDayViewModel {
  MealPlanDayViewModel(this.day, this.recipes);

  final DateTime day;
  final List<Recipe> recipes;
}
