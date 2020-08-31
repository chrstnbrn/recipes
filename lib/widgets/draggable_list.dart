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
  final bool swipeToDelete;
  final void Function(T, int) onDelete;

  const DraggableList({
    Key key,
    @required this.items,
    @required this.itemBuilder,
    this.swipeToDelete = false,
    this.onDelete,
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
              padding: EdgeInsets.symmetric(vertical: 16),
              shrinkWrap: true,
              primary: false,
              itemBuilder: (context, index) {
                var item = widget.items[index];
                return DraggableListItem(
                    key: ObjectKey(item),
                    itemBuilder: (c) => widget.itemBuilder(c, item),
                    isFirst: index == 0,
                    isLast: index == widget.items.length - 1,
                    draggingMode: DraggingMode.iOS,
                    swipeToDelete: widget.swipeToDelete,
                    onDelete: () {
                      setState(() => widget.items.removeAt(index));

                      if (widget.onDelete != null) {
                        widget.onDelete(item, index);
                      }
                    });
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
    var draggingIndex = _indexOfKey(item);
    var newPositionIndex = _indexOfKey(newPosition);

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
    @required this.swipeToDelete,
    @required this.onDelete,
  });

  @override
  final Key key;
  final Widget Function(BuildContext) itemBuilder;
  final bool isFirst;
  final bool isLast;
  final DraggingMode draggingMode;
  final bool swipeToDelete;
  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return ReorderableItem(
      key: key,
      childBuilder: _buildChild,
    );
  }

  Widget _buildChild(BuildContext context, ReorderableItemState state) {
    Widget content = Container(
      decoration: _buildDecoration(state, context),
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
                // For iOS dragging mode, there will be drag handle on the right that triggers
                // reordering; For android mode it will be just an empty container
                draggingMode == DraggingMode.iOS
                    ? _buildDragHandle()
                    : Container(),
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
        ),
      ),
    );

    // For android dragging mode, wrap the entire content in DelayedReorderableListener
    if (draggingMode == DraggingMode.Android) {
      content = DelayedReorderableListener(
        child: content,
      );
    }

    if (swipeToDelete) {
      return Dismissible(
        key: key,
        child: content,
        direction: DismissDirection.endToStart,
        background: Container(
          decoration: BoxDecoration(
            border: _buildBorder(context: context),
            color: Theme.of(context).selectedRowColor,
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 16),
          child: Icon(Icons.delete),
        ),
        onDismissed: (direction) => onDelete(),
      );
    }

    return content;
  }

  ReorderableListener _buildDragHandle() {
    return ReorderableListener(
      child: Container(
        padding: EdgeInsets.only(left: 4),
        child: Center(
          child: Icon(
            Icons.drag_handle,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration(
    ReorderableItemState state,
    BuildContext context,
  ) {
    switch (state) {
      case ReorderableItemState.dragProxy:
      case ReorderableItemState.dragProxyFinished:
        return BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          border: _buildBorder(context: context, color: Colors.transparent),
        );

      case ReorderableItemState.placeholder:
      case ReorderableItemState.normal:
        return BoxDecoration(
          color: Colors.white,
          border: _buildBorder(context: context),
        );

      default:
        throw ArgumentError('Invalid ReorderableItemState $state');
    }
  }

  Border _buildBorder({@required BuildContext context, Color color}) {
    final border = Divider.createBorderSide(context, width: 1).copyWith(
      color: color,
    );

    return Border(
      top: isFirst ? border : BorderSide.none,
      bottom: border,
    );
  }
}
