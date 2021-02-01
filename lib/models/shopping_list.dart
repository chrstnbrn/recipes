import 'dart:convert';

import 'package:meta/meta.dart';

import 'shopping_list_item.dart';

class ShoppingList {
  ShoppingList({
    @required this.items,
  });

  factory ShoppingList.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ShoppingList(
      items: map.entries
          .map(
            (entry) => ShoppingListItem.fromMap(
              entry.key,
              entry.value as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  factory ShoppingList.fromJson(String source) =>
      ShoppingList.fromMap(json.decode(source) as Map<String, dynamic>);

  List<ShoppingListItem> items;

  ShoppingList copyWith({
    List<ShoppingListItem> items,
  }) {
    return ShoppingList(
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'items': items?.map((x) => x?.toMap())?.toList(),
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'ShoppingList(items: $items)';
}
