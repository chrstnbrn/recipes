import 'package:flutter/material.dart';
import 'package:recipes/models/recipe.dart';

class StepForm extends StatefulWidget {
  StepForm({
    this.step,
    this.onSubmit,
  });

  final RecipeStep step;
  final ValueChanged<RecipeStep> onSubmit;

  @override
  StepFormState createState() => StepFormState();
}

class StepFormState extends State<StepForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[_buildIngredientNameField(), _buildSubmitButton()],
        ));
  }

  Widget _buildIngredientNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Description"),
      initialValue: widget.step.description,
      autofocus: true,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      validator: (value) => value.isEmpty ? "Please enter a description" : null,
      onSaved: (value) => widget.step.description = value,
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
        padding: EdgeInsets.only(top: 16),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          RaisedButton(
            child: Text('Add'),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                widget.onSubmit(widget.step);
                Navigator.of(context).pop();
              }
            },
          )
        ]));
  }
}
