import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes/models/meal_plan_view_model.dart';
import 'package:recipes/store/meal_plan_service.dart';
import 'package:recipes/store/recipe_repository.dart';

import '../../models/meal_plan.dart';
import '../../models/user.dart';
import '../../store/meal_plan_repository.dart';
import '../../widgets/screen_body.dart';

class MealPlanScreen extends StatelessWidget {
  const MealPlanScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Plan'),
      ),
      body: ScreenBody(
        child: _buildMealPlan(context),
      ),
    );
  }

  Widget _buildMealPlan(
    BuildContext context,
  ) {
    var mealPlanRepository = Provider.of<MealPlanRepository>(context);
    var recipeRepository = Provider.of<RecipeRepository>(context);
    var user = Provider.of<User>(context);
    var service = MealPlanService(
      crewId: user?.crewId,
      mealPlanRepository: mealPlanRepository,
      recipeRepository: recipeRepository,
    );

    return StreamBuilder<MealPlanViewModel>(
      stream: service.mealPlanViewModel$,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        return Column(
          children:
              snapshot.data.unplannedMeals.map((e) => Text(e.name)).toList(),
        );
      },
    );
  }
}
