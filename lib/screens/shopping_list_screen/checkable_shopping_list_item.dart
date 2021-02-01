import 'package:flutter/widgets.dart';

import '../../models/shopping_list_item.dart';

class CheckableShoppingListItem extends StatefulWidget {
  const CheckableShoppingListItem({Key key, this.item}) : super(key: key);

  final ShoppingListItem item;

  @override
  _CheckableShoppingListItemState createState() =>
      _CheckableShoppingListItemState();
}

class _CheckableShoppingListItemState extends State<CheckableShoppingListItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => widget.item.checked = !widget.item.checked),
      child: Text(
        widget.item.toString(),
        style: TextStyle(
            decoration: widget.item.checked
                ? TextDecoration.lineThrough
                : TextDecoration.none),
      ),
    );
  }
}
