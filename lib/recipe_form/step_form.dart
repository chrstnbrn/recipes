import 'package:flutter/material.dart';

import '../models/recipe.dart';

class StepForm extends StatefulWidget {
  const StepForm({
    Key key,
    this.step,
    this.onSubmit,
  }) : super(key: key);

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
      decoration: const InputDecoration(labelText: 'Description'),
      initialValue: widget.step.description,
      autofocus: true,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      validator: (value) => value.isEmpty ? 'Please enter a description' : null,
      onSaved: (value) => widget.step.description = value,
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          RaisedButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                widget.onSubmit(widget.step);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          )
        ]));
  }
}
