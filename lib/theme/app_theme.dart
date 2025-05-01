import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData themeData = ThemeData(
    primaryColor: const Color(0xFF9C174E), // اللون العنابي
    scaffoldBackgroundColor: const Color(0xFFF8F1E9), // الخلفية البيج
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF9C174E),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black), // نص أسود
      bodyMedium: TextStyle(color: Colors.black),
      headlineSmall: TextStyle(color: Color(0xFF9C174E)), // عناوين عنابية
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFF9C174E),
      textTheme: ButtonTextTheme.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF9C174E), // لون الأزرار
        foregroundColor: Colors.white, // لون النص
      ),
    ),
  );
}
