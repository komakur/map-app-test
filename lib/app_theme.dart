import 'package:flutter/material.dart';

class AppTheme {
  final theme = ThemeData(
    scaffoldBackgroundColor: Colors.black12,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
    ),
  );
}
