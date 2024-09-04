import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData get theme {
    return ThemeData(
      // basic colors

      scaffoldBackgroundColor: Colors.black,
      primaryColorLight: Color(0xFF2A2929),
      primaryColor: Color(0xFF030303),
      primaryColorDark: Color(0xFF000000),
      secondaryHeaderColor: Color(0xFFAD00FF),

      //More basic colours from FIGMA

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.black,
      ),

      switchTheme: SwitchThemeData(
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return Color(0xFFAD00FF);
            }
            return Color(0xFF323232);
          }),
          thumbColor: WidgetStateProperty.all(Colors.white)),

      // buttons
      buttonTheme: ButtonThemeData(
        disabledColor: Color(0xFF2A2929),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Color(0xFFAD00FF),
          backgroundColor: Color(0xFFFF6648),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          return (states.contains(WidgetState.disabled))
              ? Color(0xFF868A8C)
              : Color(0xFFAD00FF);
        }),
        textStyle: WidgetStateProperty.resolveWith((states) {
          return (states.contains(WidgetState.disabled))
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
            color: Colors.white,
          ),
          fillColor: Color(0xFF030303),
          filled: true,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 0),
          hintStyle: TextStyle(color: Color(0xFF868A8C))),
      iconTheme: IconThemeData(
        color: Color(0xFF868A8C),
      ),

      // text
      textTheme: TextTheme(
        //used in AppBar
        displayLarge: TextStyle(
            color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(
            color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
        headlineMedium: TextStyle(
          color: Colors.white,
          fontSize: 18.0,
        ),
        headlineSmall: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
        titleLarge: TextStyle(
          color: Colors.white,
          fontSize: 14.0,
        ),
        bodyLarge: TextStyle(
          color: Color(0xFF868A8C),
          fontSize: 16.0,
        ),
        bodyMedium: TextStyle(
          color: Color(0xFF868A8C),
          fontSize: 14.0,
        ),
        labelLarge: TextStyle(
          color: Color(0xFFAD00FF),
          fontSize: 14.0,
        ),
        //THIS ONES THE LITTLE TEXt ABOVE OPTIONS IN MENUS ETC
        titleMedium: TextStyle(
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
      sliderTheme: SliderThemeData(
          thumbColor: Color(0xFFAD00FF),
          activeTrackColor: Color(0xFFAD00FF),
          inactiveTrackColor: Color(0xFF868A8C),
          activeTickMarkColor: Colors.transparent,
          inactiveTickMarkColor: Colors.transparent,
          overlappingShapeStrokeColor: Colors.white,
          overlayColor: Color(0x33AD00FF)),
      appBarTheme: AppBarTheme(
        color: Colors.black,
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xFFAD00FF)),
        toolbarTextStyle: TextStyle(
            color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
      ),
      textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white),
    );
  }
}

class FigmaColours {
  FigmaColours();

  int greyLight = 0xFF868A8C;
  int greyMedium = 0xFF242424;
  int greyDark = 0xFF030303;
  int highlight = 0xFFAD00FF;
}
