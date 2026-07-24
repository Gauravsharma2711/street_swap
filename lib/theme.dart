import 'package:flutter/material.dart';

const mongoDarkGreen = Color(0xFF00684A);
const mongoNeonGreen = Color(0xFF00ED64);
const mongoDarkSlate = Color(0xFF001E2B);
const mongoMutedSlate = Color(0xFF5C6E76);
const mongoBg = Color(0xFFFAFAFA);
const mongoBorder = Color(0xFFE1E7E8);

final appTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primaryColor: mongoDarkGreen,
  scaffoldBackgroundColor: mongoBg,
  colorScheme: ColorScheme.fromSeed(
    seedColor: mongoDarkGreen,
    brightness: Brightness.light,
    primary: mongoDarkGreen,
    secondary: mongoNeonGreen,
    surface: Colors.white,
    onPrimary: Colors.white,
    onSurface: mongoDarkSlate,
  ),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.white,
    centerTitle: false,
    iconTheme: IconThemeData(color: mongoDarkSlate),
    titleTextStyle: TextStyle(
      color: mongoDarkSlate,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
  ),
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 2,
    shadowColor: Colors.black12,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: mongoBorder, width: 1),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    labelStyle: const TextStyle(color: mongoMutedSlate),
    hintStyle: const TextStyle(color: mongoMutedSlate),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: mongoBorder),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: mongoBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: mongoDarkGreen, width: 2),
    ),
  ),
  textTheme: const TextTheme(
    headlineSmall:
        TextStyle(color: mongoDarkSlate, fontWeight: FontWeight.bold),
    titleLarge: TextStyle(color: mongoDarkSlate, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(color: mongoDarkSlate),
    bodyMedium: TextStyle(color: mongoMutedSlate),
  ),
);
