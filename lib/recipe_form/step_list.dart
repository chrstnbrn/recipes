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
      itemBuilder: (context, step) {
        return Row(
          children: [
            Expanded(
              child: Text(
                step.description,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              flex: 1,
            ),
            Row(mainAxisSize: MainAxisSize.min, children: [
              new IconButton(
                icon: new Icon(Icons.edit),
                onPressed: () => showDialog(
                    context: context,
                    builder: (context) => _buildEditStepDialog(step)),
              ),
              new IconButton(
                icon: new Icon(Icons.delete),
                onPressed: () => showDialog(
                    context: context,
                    builder: (context) => _buildDeleteStepDialog(step)),
              ),
            ]),
          ],
        );
      },
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

  Widget _buildDeleteStepDialog(RecipeStep step) {
    return AlertDialog(
      title: Text("Delete ${step.description}?"),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancel'),
          textColor: Theme.of(context).hintColor,
          onPressed: () => Navigator.of(context).pop(),
        ),
        RaisedButton(
          child: Text('Delete'),
          color: Theme.of(context).errorColor,
          onPressed: () {
            setState(() {
              this.widget.steps.remove(step);
            });
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
