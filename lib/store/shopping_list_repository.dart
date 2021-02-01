import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

import '../models/shopping_list.dart';
import '../models/shopping_list_item.dart';

class ShoppingListRepository {
  const ShoppingListRepository(this.database);

  final DatabaseReference database;

  DatabaseReference _getShoppingListDatabase(String crewId) {
    return database.child('crews/$crewId/shoppingList');
  }

  Stream<ShoppingList> shoppingList(String crewId) {
    return _getShoppingListDatabase(crewId).onValue.map((event) {
      if (event.snapshot.value == null) {
        return ShoppingList(items: []);
      }

      final shoppingListJson = jsonEncode(event.snapshot.value);
      return ShoppingList.fromJson(shoppingListJson);
    });
  }

  Future<void> addItem(ShoppingListItem item, String crewId) {
    return _getShoppingListDatabase(crewId).push().set(item.toMap());
  }

  Future<void> updateItem(ShoppingListItem item, String crewId) {
    return _getShoppingListDatabase(crewId).child(item.id).update(item.toMap());
  }

  Future<void> deleteItem(String id, String crewId) {
    return _getShoppingListDatabase(crewId).child(id).remove();
  }
}
