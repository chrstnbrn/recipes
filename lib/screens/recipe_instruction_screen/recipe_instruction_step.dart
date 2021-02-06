import 'package:flutter/material.dart';

import '../../models/recipe_ingredient.dart';
import 'recipe_instruction_screen.dart';

class RecipeInstructionStep extends StatelessWidget {
  const RecipeInstructionStep({
    Key key,
    @required this.context,
    @required this.step,
    @required this.onTap,
  }) : super(key: key);

  final BuildContext context;
  final RecipeStepViewModel step;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedOpacity(
        opacity: step.isChecked ? 0.5 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
