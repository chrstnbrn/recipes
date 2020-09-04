import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';

import '../../models/recipe.dart';
import '../../models/recipe_ingredient.dart';
import '../../models/recipe_step.dart';

class RecipeInstructionScreen extends StatefulWidget {
  const RecipeInstructionScreen({Key key, @required this.recipe})
      : super(key: key);

  final Recipe recipe;

  @override
  _RecipeInstructionScreenState createState() =>
      _RecipeInstructionScreenState();
}

class _RecipeInstructionScreenState extends State<RecipeInstructionScreen> {
  @override
  void initState() {
    Wakelock.enable();
    super.initState();
  }

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.name),
      ),
      body: SizedBox.expand(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSteps(context),
              RaisedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Done!'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSteps(BuildContext context) {
    return Column(children: [
      ...widget.recipe.steps.map(
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
            ),
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
