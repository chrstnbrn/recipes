import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recipes/models/recipe.dart';
import 'package:recipes/recipe_form/step_form.dart';

import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';

class StepList extends StatefulWidget {
  final List<RecipeStep> steps;

  StepList(this.steps);

  @override
  State<StatefulWidget> createState() => StepListState(steps);
}

class StepItem {
  StepItem(this.key, this.step);

  final Key key;
  final RecipeStep step;
}

enum DraggingMode {
  iOS,
  Android,
}

class StepListState extends State<StepList> {
  List<StepItem> _items;

  StepListState(List<RecipeStep> steps) {
    _items =
        steps.map((step) => StepItem(Key(step.description), step)).toList();
  }

  @override
  Widget build(BuildContext context) {
    //return _buildSteps();
    return Padding(
        padding: EdgeInsets.only(top: 32, bottom: 32),
        child: Container(
            //height: 1000,
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildStepsHeader(),
            _buildSteps(),
            _buildAddStepButton()
          ],
        )));
  }

  Widget _buildStepsHeader() {
    return Text('Steps', style: Theme.of(context).textTheme.headline5);
  }

  int _indexOfKey(Key key) {
    return this._items.indexWhere((d) => d.key == key);
  }

  bool _reorderCallback(Key item, Key newPosition) {
    int draggingIndex = _indexOfKey(item);
    int newPositionIndex = _indexOfKey(newPosition);

    final draggedItem = _items[draggingIndex];
    setState(() {
      debugPrint("Reordering $item -> $newPosition");
      _removeAt(draggingIndex);
      _insertAt(newPositionIndex, draggedItem);
    });
    return true;
  }

  void _reorderDone(Key item) {
    final draggedItem = _items[_indexOfKey(item)];
    debugPrint("Reordering finished for ${draggedItem.step.description}}");
  }

  DraggingMode _draggingMode = DraggingMode.Android;

  Widget _buildSteps() {
    return ReorderableList(
      onReorder: this._reorderCallback,
      onReorderDone: this._reorderDone,
      child: CustomScrollView(
        shrinkWrap: true,
        // cacheExtent: 3000,
        slivers: <Widget>[
          SliverPadding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Item(
                      data: _items[index],
                      // first and last attributes affect border drawn during dragging
                      isFirst: index == 0,
                      isLast: index == _items.length - 1,
                      draggingMode: _draggingMode,
                      onEdit: (step) => showDialog(
                          context: context,
                          builder: (context) => _buildEditStepDialog(step)),
                      onDelete: (step) => showDialog(
                          context: context,
                          builder: (context) => _buildDeleteStepDialog(step)),
                    );
                  },
                  childCount: _items.length,
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildAddStepButton() {
    return OutlineButton.icon(
        icon: Icon(Icons.add),
        label: Text('Add Step'),
        onPressed: () => showDialog(
            context: context, builder: (context) => _buildAddStepDialog()));
  }

  Widget _buildAddStepDialog() {
    return AlertDialog(
      title: Text('Add step'),
      content: StepForm(
          step: new RecipeStep(),
          onSubmit: (step) {
            setState(() {
              _addStep(step);
            });
          }),
    );
  }

  void _addStep(RecipeStep step) {
    this.widget.steps.add(step);
    this._items.add(new StepItem(Key(step.description), step));
  }

  void _insertAt(int newPositionIndex, StepItem item) {
    this.widget.steps.insert(newPositionIndex, item.step);
    _items.insert(newPositionIndex, item);
  }

  void _removeAt(int index) {
    this.widget.steps.removeAt(index);
    _items.removeAt(index);
  }

  void _deleteStep(RecipeStep step) {
    this.widget.steps.remove(step);
    this._items.removeWhere((element) => element.step == step);
  }

  Widget _buildEditStepDialog(RecipeStep step) {
    return AlertDialog(
      title: Text('Edit step'),
      content: StepForm(
          step: step,
          onSubmit: (_) {
            setState(() => {});
          }),
    );
  }

  Widget _buildDeleteStepDialog(RecipeStep step) {
    return AlertDialog(
      title: Text("Delete ${step.description}?"),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancel'),
          textColor: Theme.of(context).hintColor,
          onPressed: () => Navigator.of(context).pop(),
        ),
        RaisedButton(
          child: Text('Delete'),
          color: Theme.of(context).errorColor,
          onPressed: () {
            setState(() {
              this._deleteStep(step);
            });
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}

class Item extends StatelessWidget {
  Item({
    this.data,
    this.isFirst,
    this.isLast,
    this.draggingMode,
    this.onEdit,
    this.onDelete,
  });

  final StepItem data;
  final bool isFirst;
  final bool isLast;
  final DraggingMode draggingMode;
  final Function(RecipeStep step) onEdit;
  final Function(RecipeStep step) onDelete;

  Widget _buildChild(BuildContext context, ReorderableItemState state) {
    BoxDecoration decoration;

    if (state == ReorderableItemState.dragProxy ||
        state == ReorderableItemState.dragProxyFinished) {
      // slightly transparent background white dragging (just like on iOS)
      decoration = BoxDecoration(color: Color(0xD0FFFFFF));
    } else {
      bool placeholder = state == ReorderableItemState.placeholder;
      decoration = BoxDecoration(
          border: Border(
              top: isFirst && !placeholder
                  ? Divider.createBorderSide(context) //
                  : BorderSide.none,
              bottom: isLast && placeholder
                  ? BorderSide.none //
                  : Divider.createBorderSide(context)),
          color: placeholder ? null : Colors.white);
    }

    // For iOS dragging mode, there will be drag handle on the right that triggers
    // reordering; For android mode it will be just an empty container
    Widget dragHandle = draggingMode == DraggingMode.iOS
        ? ReorderableListener(
            child: Container(
              padding: EdgeInsets.only(right: 18.0, left: 18.0),
              color: Color(0x08000000),
              child: Center(
                child: Icon(Icons.reorder, color: Color(0xFF888888)),
              ),
            ),
          )
        : Container();

    Widget content = Container(
      decoration: decoration,
      child: SafeArea(
          top: false,
          bottom: false,
          child: Opacity(
            // hide content for placeholder
            opacity: state == ReorderableItemState.placeholder ? 0.0 : 1.0,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                      child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
                    child: _buildStep(data.step, context),
                  )),
                  // Triggers the reordering
                  dragHandle,
                ],
              ),
            ),
          )),
    );

    // For android dragging mode, wrap the entire content in DelayedReorderableListener
    if (draggingMode == DraggingMode.Android) {
      content = DelayedReorderableListener(
        child: content,
      );
    }

    return content;
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableItem(
        key: data.key, //
        childBuilder: _buildChild);
  }

  Widget _buildStep(RecipeStep step, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            data.step.description,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          flex: 1,
        ),
        Row(mainAxisSize: MainAxisSize.min, children: [
          new IconButton(
              icon: new Icon(Icons.edit), onPressed: () => this.onEdit(step)),
          new IconButton(
              icon: new Icon(Icons.delete),
              onPressed: () => this.onDelete(step))
        ]),
      ],
    );
  }
}
