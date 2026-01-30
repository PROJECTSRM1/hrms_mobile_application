import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF0AA6B7);

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF6F8FB),
    primaryColor: primary,
    appBarTheme: const AppBarTheme(
      backgroundColor: primary,
      foregroundColor: Colors.white,
    ),
    cardColor: Colors.white,
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(primary),
      // ignore: deprecated_member_use
      trackColor: WidgetStateProperty.all(primary.withOpacity(0.4)),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    primaryColor: primary,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1F1F1F),
      foregroundColor: Colors.white,
    ),
    cardColor: const Color(0xFF1E1E1E),
    dividerColor: Colors.grey.shade800,
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(primary),
      // ignore: deprecated_member_use
      trackColor: WidgetStateProperty.all(primary.withOpacity(0.4)),
    ),
  );
}
