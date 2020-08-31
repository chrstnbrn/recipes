import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/recipe.dart';
import '../widgets/touch_spin_form_field.dart';
import 'ingredient_list.dart';
import 'step_list.dart';

class RecipeForm extends StatefulWidget {
  const RecipeForm({Key key, @required this.recipe}) : super(key: key);

  final Recipe recipe;

  @override
  RecipeFormState createState() => RecipeFormState();
}

class RecipeFormState extends State<RecipeForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        onWillPop: () => _showConfirmDiscardDialog(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildRecipeNameField(),
            _buildServingsField(),
            IngredientList(ingredients: widget.recipe.ingredients),
            StepList(steps: widget.recipe.steps),
          ],
        ));
  }

  Future<bool> _showConfirmDiscardDialog(BuildContext context) {
    return showDialog(
      context: context,
      child: AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text('Unsaved data will be lost.'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeNameField() {
    return TextFormField(
      initialValue: widget.recipe.name,
      decoration: const InputDecoration(labelText: 'Recipe name'),
      validator: (value) => value.isEmpty ? 'Please enter a recipe name' : null,
      onSaved: (value) => widget.recipe.name = value,
    );
  }

  Widget _buildServingsField() {
    return TouchSpinFormField(
      initialValue: widget.recipe.servings,
      decoration: const InputDecoration(labelText: 'Servings'),
      onSaved: (value) => widget.recipe.servings = value,
    );
  }

  Recipe submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      return widget.recipe;
    }
    return null;
  }
}
