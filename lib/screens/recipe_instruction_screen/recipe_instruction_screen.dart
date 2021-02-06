import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:wakelock/wakelock.dart';

import '../../models/recipe.dart';
import '../../models/recipe_ingredient.dart';
import '../../models/recipe_step.dart';

class RecipeInstructionScreen extends StatefulWidget {
  const RecipeInstructionScreen({Key key, @required this.recipe})
      : super(key: key);

  final Recipe recipe;

  @override
  _RecipeInstructionScreenState createState() =>
      _RecipeInstructionScreenState();
}

class _RecipeInstructionScreenState extends State<RecipeInstructionScreen> {
  @override
  void initState() {
    Wakelock.enable();
    super.initState();
  }

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemScrollController = ItemScrollController();
    final itemPositionsListener = ItemPositionsListener.create();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.name),
      ),
      body: Scrollbar(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(color: Colors.grey.shade100),
          child: ScrollablePositionedList.builder(
            itemScrollController: itemScrollController,
            itemPositionsListener: itemPositionsListener,
            itemCount: widget.recipe.steps.length + 1,
            itemBuilder: (context, index) => index == widget.recipe.steps.length
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: RaisedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Done!'),
                    ),
                  )
                : _buildStep(
                    context,
                    widget.recipe.steps[index],
                    onTap: () => itemScrollController.scrollTo(
                      index: index + 1,
                      duration: const Duration(milliseconds: 100),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep(
    BuildContext context,
    RecipeStep step, {
    Future<void> Function() onTap,
  }) {
    return InkWell(
      onTap: () => onTap(),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                step.description,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: _buildIngredients(context, step.ingredients),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIngredients(
    BuildContext context,
    List<RecipeIngredient> ingredients,
  ) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        ...ingredients.map(
          (i) =>
              Text(i.toString(), style: Theme.of(context).textTheme.subtitle2),
        ),
      ],
    );
  }
}
