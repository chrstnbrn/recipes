import 'package:meta/meta.dart';

class MealPlan {
  MealPlan({
    @required this.unplannedMeals,
    @required this.plannedMeals,
  });

  List<String> unplannedMeals;
  Map<DateTime, List<String>> plannedMeals;
}
