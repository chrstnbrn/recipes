import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData.from(
    colorScheme: ColorScheme.light(
        primary: Colors.green,
        secondary: Colors.lightGreen.shade500,
        onPrimary: Colors.white,
        onSecondary: Colors.white),
  ).copyWith(
      buttonTheme: ButtonThemeData(
          buttonColor: Colors.green, textTheme: ButtonTextTheme.primary));
}
