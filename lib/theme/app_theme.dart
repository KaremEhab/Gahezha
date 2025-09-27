import 'package:flutter/material.dart';
import 'package:gahezha/constants/vars.dart';
import 'color_scheme.dart';

ThemeData buildGahezhaTheme(Brightness b) {
  final scheme = gahezhaColorScheme(b);
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,

    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      surfaceTintColor: scheme.surfaceTint,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: scheme.onSurface,
        fontWeight: FontWeight.w700,
        fontSize: 20,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surface,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: scheme.outline),
        borderRadius: BorderRadius.circular(radius),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: scheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: scheme.primary, width: 1.6),
      ),
    ),

    // 🔹 ElevatedButton (primary filled)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    ),

    // 🔹 TextButton (transparent, accent color)
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: scheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      ),
    ),

    // 🔹 OutlinedButton (border + accent)
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: scheme.primary,
        side: BorderSide(color: scheme.primary, width: 1.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    ),

    cardTheme: CardThemeData(
      color: scheme.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
    ),

    chipTheme: ChipThemeData(
      showCheckmark: false,
      backgroundColor: Colors.grey.shade100,
      side: BorderSide.none,
    ),
  );
}
