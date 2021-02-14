import 'dart:convert';

import 'package:meta/meta.dart';
import 'recipe_ingredient.dart';

class ShoppingListItem {
  ShoppingListItem({
    this.id,
    this.amount,
    this.unit,
    @required this.name,
    this.checked,
  });

  factory ShoppingListItem.fromMap(String id, Map<String, dynamic> map) {
    if (map == null) return null;

    return ShoppingListItem(
      id: id,
      amount: (map['amount'] as num)?.toDouble(),
      unit: map['unit'] as String,
      name: map['name'] as String,
      checked: map['checked'] as bool,
    );
  }

  factory ShoppingListItem.fromJson(String id, String source) =>
      ShoppingListItem.fromMap(id, json.decode(source) as Map<String, dynamic>);

  factory ShoppingListItem.fromIngredient(RecipeIngredient ingredient) =>
      ShoppingListItem(
        id: null,
        amount: ingredient.amount,
        unit: ingredient.unit,
        name: ingredient.ingredientName,
        checked: false,
      );

  String id;
  double amount;
  String unit;
  String name;
  bool checked;

  ShoppingListItem copyWith({
    double amount,
    String unit,
    String name,
    bool checked,
  }) {
    return ShoppingListItem(
      id: id,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      name: name ?? this.name,
      checked: checked ?? this.checked,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'amount': amount,
      'unit': unit,
      'name': name,
      'checked': checked,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    var result = '';
    if (amount != null) result += '$amount ';
    if (unit != null) result += '$unit ';
    return result + name;
  }
}
