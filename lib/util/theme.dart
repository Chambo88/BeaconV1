import 'dart:ui';

import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData get theme {
    return ThemeData(
      // basic colors

      backgroundColor: Colors.black,
      primaryColorLight: Color(0xFF2A2929),
      primaryColor: Color(0xFF111111),
      primaryColorDark: Color(0xFF000000),
      accentColor: Color(0xFFAD00FF),

      //More basic colours from FIGMA


      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.black,
      ),

      switchTheme: SwitchThemeData(
          trackColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return Color(0xFFAD00FF);
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
              ? Color(0xFF868A8C)
              : Color(0xFFAD00FF);
        }),
        textStyle: MaterialStateProperty.resolveWith((states) {
          return (states.contains(MaterialState.disabled))
              ? TextStyle(
                  color: Color(0xFF868A8C),
                  fontSize: 16,
                )
              : TextStyle(
                  color: Color(0xFF868A8C),
                  fontSize: 16,
                );
        }),
      )),

      inputDecorationTheme: InputDecorationTheme(

        counterStyle: TextStyle(color: Colors.white),
        labelStyle: TextStyle(
          color: Color(0xFF868A8C),
        ),
          fillColor: Color(0xFF111111),
          filled: true,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding:
          EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 0),
          hintStyle: TextStyle(color: Color(0xFF868A8C))
      ),
      iconTheme: IconThemeData(
        color: Color(0xFF868A8C),
      ),

      // text
      textTheme: TextTheme(
        //used in AppBar
        headline1: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.bold
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
          color: Color(0xFF868A8C),
          fontSize: 14.0,
        ),
        caption: TextStyle(
          color: Color(0xFFAD00FF),
          fontSize: 14.0,
        ),
        //THIS ONES THE LITTLE TEXt ABOVE OPTIONS IN MENUS ETC
        subtitle1: TextStyle(
            color: Color(0xFF868A8C),
          fontSize: 16.0,
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(fontSize: 22, color: Colors.black),
        contentTextStyle: TextStyle(color: Colors.black),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Color(0xFFAD00FF),
        contentTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      appBarTheme: AppBarTheme(
          color: Colors.black,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Color(0xFFAD00FF)
        ),
        textTheme: TextTheme(
          headline6: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          )
        ),
        // titleTextStyle: TextStyle(
        //   fontWeight: FontWeight.bold,
        // )
      ),
      textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white),
      scaffoldBackgroundColor: Colors.black,
    );
  }
}

class FigmaColours {

  FigmaColours();

  int greyLight = 0xFF868A8C;
  int greyMedium = 0xFF242424;
  int greyDark = 0xFF111111;
  int highlight = 0xFFAD00FF;


}
