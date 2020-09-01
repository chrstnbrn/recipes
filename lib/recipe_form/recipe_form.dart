import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/recipe.dart';
import '../models/recipe_step.dart';
import '../widgets/touch_spin_form_field.dart';
import 'ingredients.dart';
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
            Ingredients(ingredients: widget.recipe.ingredients),
            StepList(
              steps: widget.recipe.steps,
              onAddStep: onAddStep,
              onUpdateStep: onUpdateStep,
              onUndoDelete: onUndoDelete,
            ),
          ],
        ));
  }

  void onAddStep(RecipeStep step) {
    setState(() => widget.recipe.steps.add(step));
  }

  void onUpdateStep(RecipeStep step, int index) {
    setState(() => widget.recipe.steps[index] = step);
  }

  void onUndoDelete(RecipeStep step, int index) {
    setState(() => widget.recipe.steps.insert(index, step));
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
