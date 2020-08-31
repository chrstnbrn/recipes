import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData.from(
    colorScheme: ColorScheme.light(
      primary: Colors.green,
      secondary: Colors.lightGreen.shade500,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyText1: TextStyle(fontSize: 18.0),
      bodyText2: TextStyle(fontSize: 16.0),
    ),
  ).copyWith(
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.green,
      textTheme: ButtonTextTheme.primary,
    ),
  );
}
