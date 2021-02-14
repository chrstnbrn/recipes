import 'package:flutter/material.dart';

import '../../widgets/screen_body.dart';

class MealPlanScreen extends StatelessWidget {
  const MealPlanScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Plan'),
      ),
      body: const ScreenBody(),
    );
  }
}
