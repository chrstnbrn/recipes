import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/recipe_step.dart';
import '../routes.dart';
import '../widgets/draggable_list.dart';

class StepList extends StatefulWidget {
  const StepList({
    Key key,
    this.steps,
  }) : super(key: key);

  final List<RecipeStep> steps;

  @override
  State<StatefulWidget> createState() => StepListState();
}

class StepListState extends State<StepList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildStepsHeader(),
          _buildSteps(),
          _buildAddStepButton(),
        ],
      ),
    );
  }

  Widget _buildStepsHeader() {
    return Text(
      'Steps',
      style: Theme.of(context).textTheme.headline5,
    );
  }

  Widget _buildSteps() {
    return DraggableList(
      items: widget.steps,
      itemBuilder: _buildStep,
      swipeToDelete: true,
      onDelete: _showUndoDeleteStepSnackBar,
    );
  }

  void _showUndoDeleteStepSnackBar(RecipeStep step, int index) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted step "${step.description}"'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            setState(() => widget.steps.insert(index, step));
          },
        ),
      ),
    );
  }

  InkWell _buildStep(BuildContext context, RecipeStep step) {
    return InkWell(
      onTap: () async {
        var updatedStep = await Navigator.of(context).pushNamed<RecipeStep>(
          Routes.stepForm,
          arguments: {'title': 'Edit Step', 'step': step},
        );

        if (updatedStep != null) {
          setState(() {
            step.description = updatedStep.description;
          });
        }
      },
      child: Text(
        step.description,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }

  Widget _buildAddStepButton() {
    return OutlineButton.icon(
        icon: const Icon(Icons.add),
        label: const Text('Add Step'),
        onPressed: () async {
          var step = RecipeStep(description: '');
          var newStep = await Navigator.of(context).pushNamed<RecipeStep>(
            Routes.stepForm,
            arguments: {'title': 'Add Step', 'step': step},
          );

          if (newStep != null) {
            setState(() {
              widget.steps.add(newStep);
            });
          }
        });
  }
}
