import 'dart:ui';

import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData get theme {
    return ThemeData(
      // basic colors

      backgroundColor: Colors.black,
      primaryColorLight: Color(0xFF2A2929),
      primaryColor: Color(0xFF181818),
      primaryColorDark: Color(0xFF000000),
      accentColor: Color(0xFFFF00CC),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.black,
      ),

      switchTheme: SwitchThemeData(
          trackColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return Color(0xFFB500E2);
            }
            return Color(0xFF323232);
          }),
          thumbColor: MaterialStateProperty.all(Colors.white)),

      // buttons
      buttonTheme: ButtonThemeData(
        disabledColor: Color(0xFF2A2929),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          primary: Colors.purple,
          backgroundColor: Colors.red,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          return (states.contains(MaterialState.disabled))
              ? Color(0xFF716F6F)
              : Color(0xFFB500E2);
        }),
        textStyle: MaterialStateProperty.resolveWith((states) {
          return (states.contains(MaterialState.disabled))
              ? TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                )
              : TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                );
        }),
      )),

      inputDecorationTheme: InputDecorationTheme(
        counterStyle: TextStyle(color: Colors.white),
        labelStyle: TextStyle(
          color: Color(0xFFC7C1C1),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF6200EE)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF6200EE)),
        ),
      ),
      iconTheme: IconThemeData(
        color: Colors.grey,
      ),

      // text
      textTheme: TextTheme(
        headline1: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
        ),
        headline2: TextStyle(
          color: Colors.white,
          fontSize: 22.0,
        ),
        headline3: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
        headline4: TextStyle(
          color: Colors.white,
          fontSize: 18.0,
        ),
        headline5: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
        headline6: TextStyle(
          color: Colors.white,
          fontSize: 14.0,
        ),
        bodyText1: TextStyle(
          color: Colors.white,
          fontSize: 14.0,
        ),
        bodyText2: TextStyle(
          color: Color(0xFF7E7E90),
          fontSize: 14.0,
        ),
        caption: TextStyle(
          color: Color(0xFFFF00CC),
          fontSize: 14.0,
        ),
        subtitle1: TextStyle(color: Colors.white),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(fontSize: 22, color: Colors.black),
        contentTextStyle: TextStyle(color: Colors.black),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Color(0xFFB500E2),
        contentTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      appBarTheme: AppBarTheme(color: Colors.black),
      textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white),
      scaffoldBackgroundColor: Colors.black,
    );
  }
}
