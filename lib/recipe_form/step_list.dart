import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/recipe_form/step_form.dart';
import 'package:recipes/widgets/draggable_list.dart';

class StepList extends StatefulWidget {
  final List<RecipeStep> steps;

  StepList(this.steps);

  @override
  State<StatefulWidget> createState() => StepListState();
}

class StepListState extends State<StepList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 32, bottom: 32),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildStepsHeader(),
            _buildSteps(),
            _buildAddStepButton(),
          ],
        ),
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
        content: Text("Deleted step \"${step.description}\""),
        action: SnackBarAction(
          label: "UNDO",
          onPressed: () {
            setState(() => widget.steps.insert(index, step));
          },
        ),
      ),
    );
  }

  InkWell _buildStep(BuildContext context, RecipeStep step) {
    return InkWell(
      child: Text(
        step.description,
        style: Theme.of(context).textTheme.subtitle1,
      ),
      onTap: () => showDialog(
        context: context,
        builder: (context) => _buildEditStepDialog(step),
      ),
    );
  }

  Widget _buildAddStepButton() {
    return OutlineButton.icon(
      icon: Icon(Icons.add),
      label: Text('Add Step'),
      onPressed: () => showDialog(
        context: context,
        builder: (context) => _buildAddStepDialog(),
      ),
    );
  }

  Widget _buildAddStepDialog() {
    return AlertDialog(
      title: Text('Add step'),
      content: StepForm(
        step: new RecipeStep(),
        onSubmit: (step) {
          setState(() {
            this.widget.steps.add(step);
          });
        },
      ),
    );
  }

  Widget _buildEditStepDialog(RecipeStep step) {
    return AlertDialog(
      title: Text('Edit step'),
      content: StepForm(
          step: step,
          onSubmit: (_) {
            setState(() => {});
          }),
    );
  }
}
