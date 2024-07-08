import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData.light().copyWith(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFE43E3A),
    primary: const Color(0xFFE43E3A),
  ),
  scaffoldBackgroundColor: Colors.white,
  inputDecorationTheme: const InputDecorationTheme(
    fillColor: Color(0xFFDADADA),
    filled: true,
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      side: const WidgetStatePropertyAll(
        BorderSide(
          color: Colors.black,
          width: 2,
        ),
      ),
    ),
  ),
);
