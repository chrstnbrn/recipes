import 'package:flutter/material.dart';

import '../../models/recipe.dart';
import '../../models/recipe_ingredient.dart';
import '../../models/recipe_step.dart';

class RecipeInstructionScreen extends StatelessWidget {
  const RecipeInstructionScreen({Key key, @required this.recipe})
      : super(key: key);

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
      ),
      body: SizedBox.expand(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: _buildSteps(context),
        ),
      ),
    );
  }

  Widget _buildSteps(BuildContext context) {
    return Column(children: [
      ...recipe.steps.map(
        (step) => _buildStep(context, step),
      ),
    ]);
  }

  Widget _buildStep(BuildContext context, RecipeStep step) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              step.description,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Container(
              margin: const EdgeInsets.only(top: 16),
              child: _buildIngredients(context, step.ingredients),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildIngredients(
    BuildContext context,
    List<RecipeIngredient> ingredients,
  ) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        ...ingredients.map(
          (i) =>
              Text(i.toString(), style: Theme.of(context).textTheme.subtitle2),
        ),
      ],
    );
  }
}
