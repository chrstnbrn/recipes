import 'package:meta/meta.dart';

import 'recipe.dart';

class MealPlanViewModel {
  MealPlanViewModel({
    @required this.unplannedMeals,
    @required this.days,
  });

  List<Recipe> unplannedMeals;
  Map<DateTime, List<Recipe>> days;
}
