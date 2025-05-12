import 'package:flutter/material.dart';

class AppConstants {
  // App name
  static const String appName = 'IELTS Prep';

  // Color palette based on provided colors
  static const Color primaryColor = Color(0xFF000000); // Black
  static const Color secondaryColor = Color(0xFF52057B); // Dark Purple
  static const Color accentColor = Color(0xFF892CDC); // Purple
  static const Color lightAccentColor = Color(0xFFBC6FF1); // Light Purple

  // RGB values (for reference)
  // rgb(0, 0, 0)         - Black
  // rgb(82, 5, 123)      - Dark Purple
  // rgb(137, 44, 220)    - Purple
  // rgb(188, 111, 241)   - Light Purple

  // Gradient for backgrounds
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      secondaryColor,
      accentColor,
    ],
  );

  // Text styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 16,
    color: Colors.white,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  // Padding and spacing
  static const double defaultPadding = 16.0;
  static const double defaultMargin = 16.0;
  static const double defaultRadius = 8.0;

  // Animation durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
}
