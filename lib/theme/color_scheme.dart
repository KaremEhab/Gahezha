// core/theme/color_scheme.dart
import 'package:flutter/material.dart';
import 'package:gahezha/constants/vars.dart';

ColorScheme gahezhaColorScheme(Brightness b) {
  final isDark = b == Brightness.dark;
  return ColorScheme(
    brightness: b,
    primary: primaryBlue,
    onPrimary: onPrimary,
    primaryContainer: primaryBlue.withOpacity(.15),
    onPrimaryContainer: secondaryBlue,
    secondary: accentCyan,
    onSecondary: Colors.black,
    secondaryContainer: accentCyan.withOpacity(.2),
    onSecondaryContainer: Colors.black,
    surface: isDark ? const Color(0xFF0E1220) : surface,
    onSurface: isDark ? Colors.white : const Color(0xFF0E1220),
    background: isDark ? const Color(0xFF0B0F1A) : bg,
    onBackground: isDark ? Colors.white : const Color(0xFF111827),
    error: const Color(0xFFEF4444),
    onError: Colors.white,
    outline: isDark ? Colors.white24 : Colors.grey[300],
    surfaceTint: primaryBlue,
    scrim: Colors.black54,
  );
}
