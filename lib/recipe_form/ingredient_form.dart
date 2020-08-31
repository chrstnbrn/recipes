import 'package:flutter/material.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import '../models/recipe.dart';

class IngredientForm extends StatefulWidget {
  const IngredientForm({
    Key key,
    this.ingredient,
    this.onSubmit,
  }) : super(key: key);

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
      decoration: const InputDecoration(labelText: 'Name'),
      initialValue: widget.ingredient.ingredientName,
      autofocus: true,
      validator: (value) => value.isEmpty ? 'Please enter a name' : null,
      onSaved: (value) => widget.ingredient.ingredientName = value,
    );
  }

  Widget _buildIngredientAmountField() {
    return TextFormField(
        decoration: const InputDecoration(labelText: 'Amount'),
        initialValue: widget.ingredient.amount?.toString(),
        keyboardType: TextInputType.number,
        inputFormatters: [ThousandsFormatter(allowFraction: true)],
        onSaved: (value) => widget.ingredient.amount = double.tryParse(value));
  }

  TextFormField _buildIngredientUnitField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Unit'),
      initialValue: widget.ingredient.unit,
      onSaved: (value) => widget.ingredient.unit = value,
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
                widget.onSubmit(widget.ingredient);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          )
        ]));
  }
}
