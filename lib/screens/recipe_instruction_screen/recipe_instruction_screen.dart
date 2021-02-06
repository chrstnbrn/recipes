import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:wakelock/wakelock.dart';

import '../../models/recipe.dart';
import '../../models/recipe_ingredient.dart';

class RecipeStepViewModel {
  RecipeStepViewModel({
    @required this.description,
    @required this.ingredients,
    this.isChecked = false,
  });

  String description;
  List<RecipeIngredient> ingredients;
  bool isChecked;
}

class RecipeInstructionScreen extends StatefulWidget {
  const RecipeInstructionScreen({Key key, @required this.recipe})
      : super(key: key);

  final Recipe recipe;

  @override
  _RecipeInstructionScreenState createState() =>
      _RecipeInstructionScreenState();
}

class _RecipeInstructionScreenState extends State<RecipeInstructionScreen> {
  List<RecipeStepViewModel> _stepViewModels;
  final itemScrollController = ItemScrollController();
  final itemPositionsListener = ItemPositionsListener.create();

  @override
  void initState() {
    Wakelock.enable();
    super.initState();

    _stepViewModels = widget.recipe.steps
        .map(
          (r) => RecipeStepViewModel(
              description: r.description, ingredients: r.ingredients),
        )
        .toList();
  }

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            itemCount: _stepViewModels.length + 1,
            itemBuilder: (context, index) {
              return index == _stepViewModels.length
                  ? _buildDoneButton(context)
                  : _buildStep(
                      context,
                      _stepViewModels[index],
                      onTap: () => onTapStep(index),
                    );
            },
          ),
        ),
      ),
    );
  }

  void onTapStep(int index) {
    setState(() =>
        _stepViewModels[index].isChecked = !_stepViewModels[index].isChecked);

    if (scrollToNextStep(index)) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (itemScrollController.isAttached) {
          itemScrollController.scrollTo(
            index: index + 1,
            duration: const Duration(milliseconds: 300),
          );
        }
      });
    }
  }

  bool scrollToNextStep(int index) {
    var previousSteps = _stepViewModels.take(index + 1);
    return previousSteps.every((step) => step.isChecked);
  }

  Widget _buildStep(
    BuildContext context,
    RecipeStepViewModel step, {
    Function() onTap,
  }) {
    return InkWell(
      onTap: () => onTap(),
      child: AnimatedOpacity(
        opacity: step.isChecked ? 0.5 : 1.0,
        duration: const Duration(milliseconds: 200),
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

  Container _buildDoneButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: RaisedButton.icon(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.check_circle_outline),
        label: const Text('Done!'),
      ),
    );
  }
}
