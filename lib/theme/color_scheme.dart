// core/theme/color_scheme.dart
import 'package:flutter/material.dart';

const _primaryBlue = Color(0xFF1B6BFF); // main brand blue
const _onPrimary = Colors.white;
const _secondaryBlue = Color(0xFF0F3DAD);
const _accentCyan = Color(0xFF22D1EE);
const _bg = Color(0xFFF7F9FC);
const _surface = Colors.white;

ColorScheme gahezhaColorScheme(Brightness b) {
  final isDark = b == Brightness.dark;
  return ColorScheme(
    brightness: b,
    primary: _primaryBlue,
    onPrimary: _onPrimary,
    primaryContainer: _primaryBlue.withOpacity(.15),
    onPrimaryContainer: _secondaryBlue,
    secondary: _accentCyan,
    onSecondary: Colors.black,
    secondaryContainer: _accentCyan.withOpacity(.2),
    onSecondaryContainer: Colors.black,
    surface: isDark ? const Color(0xFF0E1220) : _surface,
    onSurface: isDark ? Colors.white : const Color(0xFF0E1220),
    background: isDark ? const Color(0xFF0B0F1A) : _bg,
    onBackground: isDark ? Colors.white : const Color(0xFF111827),
    error: const Color(0xFFEF4444),
    onError: Colors.white,
    outline: isDark ? Colors.white24 : Colors.grey[300],
    surfaceTint: _primaryBlue,
    scrim: Colors.black54,
  );
}
