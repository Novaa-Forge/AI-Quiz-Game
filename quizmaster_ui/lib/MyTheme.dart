import 'package:flutter/material.dart';

/// Holds theme data for the app (color schemes, text style etc.)
class MyTheme {
  static Color primaryColor = Colors.deepPurple;
  static Color secondaryColor = Colors.deepPurpleAccent;
  static Color tertiaryColor = Colors.purpleAccent;

  static LinearGradient backgroundGradient = LinearGradient(
      colors: [primaryColor.withOpacity(0.2), secondaryColor.withOpacity(0.2)]);

  static TextStyle normalTextStyle =
      TextStyle(color: primaryColor, fontFamily: "Saira", shadows: [
    Shadow(
      offset: const Offset(2, 2),
      color: primaryColor.withOpacity(0.3),
      blurRadius: 2,
    )
  ]);
}
