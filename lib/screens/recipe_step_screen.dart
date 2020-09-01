import 'package:flutter/material.dart';

import '../models/recipe_step.dart';

class RecipeStepScreen extends StatelessWidget {
  const RecipeStepScreen({
    Key key,
    @required this.title,
    @required this.step,
  }) : super(key: key);

  final String title;
  final RecipeStep step;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.maybePop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (formKey.currentState.validate()) {
                formKey.currentState.save();
                Navigator.of(context).pop(step);
              }
            },
          ),
        ],
      ),
      body: SizedBox.expand(
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: _buildStepForm(context, formKey)),
      ),
    );
  }

  Widget _buildStepForm(BuildContext context, GlobalKey formKey) {
    return Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[_buildIngredientNameField()],
        ));
  }

  Widget _buildIngredientNameField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Description'),
      initialValue: step.description,
      autofocus: true,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      validator: (value) => value.isEmpty ? 'Please enter a description' : null,
      onSaved: (value) => step.description = value,
    );
  }
}
