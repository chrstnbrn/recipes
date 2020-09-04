import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

import '../models/db_user.dart';

class UserRepository {
  const UserRepository(this.database);
  final DatabaseReference database;

  DatabaseReference get _userDatabase => database.child('users');

  Stream<DbUser> getUser(String userId) {
    return _userDatabase.child(userId).onValue.map((event) {
      final json = jsonEncode(event.snapshot.value);
      return DbUser.fromJson(json);
    });
  }
}
