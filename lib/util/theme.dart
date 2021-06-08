import 'dart:ui';

import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData get theme {
    return ThemeData(
      dialogBackgroundColor: Colors.black,
      iconTheme: IconThemeData(color: Colors.white),
      primaryIconTheme: IconThemeData(color: Colors.white),
      accentIconTheme: IconThemeData(color: Colors.white),
      appBarTheme: AppBarTheme(color: Colors.black),
      textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white),
      primaryColor: Colors.purple,
      textTheme: TextTheme(
        bodyText1: TextStyle(),
        bodyText2: TextStyle(),
        subtitle1: TextStyle(), // input fields
      ).apply(
        bodyColor: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        alignLabelWithHint: false,
        labelStyle: TextStyle(color: Colors.white),
        fillColor: Colors.grey,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
            width: 1.0,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
            width: 1.0,
          ),
        ),
      ),
      scaffoldBackgroundColor: Colors.black,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: Colors.purpleAccent[400],
        ),
      ),
    );
  }
}
