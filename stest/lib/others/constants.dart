import 'package:flutter/material.dart';

import '../data/models/usermodels/user.dart';

class Constants {
  static User? user;
  static List<User> users = [];
  static User? getUserById(String id) {
    for (int i = 0; i < users.length; i++) {
      if (users[i].id.toUpperCase() == id.toUpperCase()) {
        return users[i];
      }
    }
    return null;
  }

  static const enabledBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromARGB(255, 88, 13, 92), width: 1.0),
  );
  static const focusBorder = OutlineInputBorder(
    borderSide:
        BorderSide(color: Color.fromARGB(255, 126, 157, 204), width: 1.0),
  );
  static const errorBorder = OutlineInputBorder(
    borderSide:
        BorderSide(color: Color.fromARGB(255, 219, 101, 101), width: 1.0),
  );
  static const card = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    gradient: LinearGradient(colors: [
      Color.fromARGB(255, 55, 56, 59),
      Color.fromARGB(255, 16, 14, 37)
    ]),
  );
  static const String profileRoute = '/profileScreen';
  static const String homepage = '/homepage';
  static const String requestLedger = '/requestLedger';
  static const String ledgerLog = '/ledgerLog';
  static const String pendingLedgers = '/pendingLedgers';
}
