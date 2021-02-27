import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  Widget _buildMealPlan(BuildContext context) {
    var repository = Provider.of<MealPlanRepository>(context);
    var user = Provider.of<User>(context);

    return StreamBuilder<MealPlan>(
      stream: repository.getMealPlan(user.crewId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        return Column(
          children: snapshot.data.unplannedMeals.map((e) => Text(e)).toList(),
        );
      },
    );
  }
}
