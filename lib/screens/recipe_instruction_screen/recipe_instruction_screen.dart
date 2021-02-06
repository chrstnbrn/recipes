import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:wakelock/wakelock.dart';

import '../../models/recipe.dart';
import '../../models/recipe_ingredient.dart';
import 'recipe_instruction_step.dart';

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
  final _itemScrollController = ItemScrollController();
  final _itemPositionsListener = ItemPositionsListener.create();

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
            itemScrollController: _itemScrollController,
            itemPositionsListener: _itemPositionsListener,
            itemCount: _stepViewModels.length + 1,
            itemBuilder: (context, index) => index == _stepViewModels.length
                ? _buildDoneButton(context)
                : RecipeInstructionStep(
                    context: context,
                    step: _stepViewModels[index],
                    onTap: () => _onTapStep(index),
                  ),
          ),
        ),
      ),
    );
  }

  void _onTapStep(int index) {
    setState(() =>
        _stepViewModels[index].isChecked = !_stepViewModels[index].isChecked);

    var firstUncheckedStepIndex = _getFirstUncheckedStepIndex();
    if (firstUncheckedStepIndex > index) {
      Future.delayed(
        const Duration(milliseconds: 300),
        () {
          if (_itemScrollController.isAttached) {
            _itemScrollController.scrollTo(
              index: firstUncheckedStepIndex,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          }
        },
      );
    }
  }

  int _getFirstUncheckedStepIndex() {
    return _stepViewModels.indexWhere((step) => !step.isChecked);
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
