import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';

enum DraggingMode {
  iOS,
  Android,
}

class DraggableList<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(BuildContext, T) itemBuilder;

  const DraggableList({
    Key key,
    @required this.items,
    @required this.itemBuilder,
  }) : super(key: key);

  @override
  _DraggableListState<T> createState() => _DraggableListState<T>();
}

class _DraggableListState<T> extends State<DraggableList<T>> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ReorderableList(
            onReorder: _reorderCallback,
            child: ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemBuilder: (context, index) {
                var item = widget.items[index];
                return DraggableListItem(
                  key: ObjectKey(widget.items[index]),
                  itemBuilder: (c) => widget.itemBuilder(c, item),
                  isFirst: index == 0,
                  isLast: index == widget.items.length - 1,
                  draggingMode: DraggingMode.iOS,
                );
              },
              itemCount: widget.items.length,
            ),
          ),
        ),
      ],
    );
  }

  int _indexOfKey(Key key) {
    return widget.items.indexWhere((element) => ObjectKey(element) == key);
  }

  bool _reorderCallback(Key item, Key newPosition) {
    int draggingIndex = _indexOfKey(item);
    int newPositionIndex = _indexOfKey(newPosition);

    final draggedItem = widget.items[draggingIndex];

    setState(() {
      widget.items.removeAt(draggingIndex);
      widget.items.insert(newPositionIndex, draggedItem);
    });

    return true;
  }
}

class DraggableListItem extends StatelessWidget {
  DraggableListItem({
    @required this.key,
    @required this.itemBuilder,
    @required this.isFirst,
    @required this.isLast,
    @required this.draggingMode,
  });

  final Key key;
  final Widget Function(BuildContext) itemBuilder;
  final bool isFirst;
  final bool isLast;
  final DraggingMode draggingMode;

  @override
  Widget build(BuildContext context) {
    return ReorderableItem(
      key: key,
      childBuilder: _buildChild,
    );
  }

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
              padding: EdgeInsets.only(left: 4),
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
                children: [
                  dragHandle,
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 14.0,
                        horizontal: 14.0,
                      ),
                      child: itemBuilder(context),
                    ),
                  ),
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
}
