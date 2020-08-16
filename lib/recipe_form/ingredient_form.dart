import 'package:flutter/material.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:recipes/models/recipe.dart';

class IngredientForm extends StatefulWidget {
  IngredientForm({
    this.ingredient,
    this.onSubmit,
  });

  final RecipeIngredient ingredient;
  final ValueChanged<RecipeIngredient> onSubmit;

  @override
  IngredientFormState createState() => IngredientFormState();
}

class IngredientFormState extends State<IngredientForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildIngredientNameField(),
            _buildIngredientAmountField(),
            _buildIngredientUnitField(),
            _buildSubmitButton()
          ],
        ));
  }

  Widget _buildIngredientNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Name"),
      initialValue: widget.ingredient.ingredientName,
      autofocus: true,
      validator: (value) => value.isEmpty ? "Please enter a name" : null,
      onSaved: (value) => widget.ingredient.ingredientName = value,
    );
  }

  Widget _buildIngredientAmountField() {
    return TextFormField(
        decoration: InputDecoration(labelText: "Amount"),
        initialValue: widget.ingredient.amount?.toString(),
        keyboardType: TextInputType.number,
        inputFormatters: [ThousandsFormatter(allowFraction: true)],
        onSaved: (value) => widget.ingredient.amount = double.tryParse(value));
  }

  _buildIngredientUnitField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Unit"),
      initialValue: widget.ingredient.unit,
      onSaved: (value) => widget.ingredient.unit = value,
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
                widget.onSubmit(widget.ingredient);
                Navigator.of(context).pop();
              }
            },
          )
        ]));
  }
}
