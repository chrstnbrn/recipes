import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/recipe_ingredient.dart';
import '../models/recipe_step.dart';
import '../routes.dart';
import '../widgets/draggable_list.dart';

class StepList extends StatelessWidget {
  const StepList({
    Key key,
    @required this.steps,
    @required this.onAddStep,
    @required this.onUpdateStep,
    @required this.onUndoDelete,
  }) : super(key: key);

  final List<RecipeStep> steps;
  final void Function(RecipeStep) onAddStep;
  final void Function(RecipeStep, int) onUpdateStep;
  final void Function(RecipeStep, int) onUndoDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Steps', style: Theme.of(context).textTheme.headline5),
          DraggableList<RecipeStep>(
            items: steps,
            itemBuilder: _buildStep,
            swipeToDelete: true,
            onDelete: (step, i) =>
                _showUndoDeleteStepSnackBar(context, step, i),
          ),
          _buildAddStepButton(context),
        ],
      ),
    );
  }

  void _showUndoDeleteStepSnackBar(
      BuildContext context, RecipeStep step, int index) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted step "${step.description}"'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () => onUndoDelete(step, index),
        ),
      ),
    );
  }

  InkWell _buildStep(BuildContext context, RecipeStep step, int index) {
    return InkWell(
      onTap: () async {
        var updatedStep = await Navigator.of(context).pushNamed<RecipeStep>(
          Routes.stepForm,
          arguments: {'title': 'Edit Step', 'step': step},
        );

        if (updatedStep != null) {
          onUpdateStep(updatedStep, index);
        }
      },
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

  Widget _buildAddStepButton(BuildContext context) {
    return OutlineButton.icon(
        icon: const Icon(Icons.add),
        label: const Text('Add Step'),
        onPressed: () async {
          var step = RecipeStep(description: '', ingredients: []);
          var newStep = await Navigator.of(context).pushNamed<RecipeStep>(
            Routes.stepForm,
            arguments: {'title': 'Add Step', 'step': step},
          );

          if (newStep != null) {
            onAddStep(newStep);
          }
        });
  }
}
