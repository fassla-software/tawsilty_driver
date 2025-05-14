import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  fontFamily: 'SFProText',
  primaryColor: Color(0xFF00ff7c),
  brightness: Brightness.dark,
  cardColor: const Color(0xFF242424),
  hintColor: const Color(0xFF9F9F9F),
  scaffoldBackgroundColor: const Color(0xff444444),
  primaryColorDark: const Color(0xff14b162),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF02B8A2),
    error: Color(0xFFFF6767),
    secondary: Color(0xFF008C7B),
    tertiary: Color(0xFF7CCD8B),
    tertiaryContainer: Color(0xFFC98B3E),
    secondaryContainer: Color(0xFFEE6464),
    onTertiary: Color(0xFFD9D9D9),
    onSecondary: Color(0xFF00FEE1),
    onSecondaryContainer: Color(0xFFA8C5C1),
    onTertiaryContainer: Color(0xFF425956),
    outline: Color(0xFFffffff),
    onPrimaryContainer: Color(0xFF929494),
    primaryContainer: Color(0xFFFFA800),
    onSurface: Color(0xFFFFE6AD),
    onPrimary: Color(0xFF064A42),
    surfaceContainer: Color(0xFF0094FF),
    secondaryFixedDim: Color(0xFF808080),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: const Color(0xFF00735f)),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontWeight: FontWeight.w300,
      color: Color(0xFF202020),
    ),
    displayMedium: TextStyle(
      fontWeight: FontWeight.w300,
      color: Color(0xFF393939),
    ),
    displaySmall: TextStyle(
      fontWeight: FontWeight.w300,
      color: Color(0xFF282828),
    ),
    bodyLarge: TextStyle(fontWeight: FontWeight.w300, color: Color(0xFF272727)),
    bodyMedium: TextStyle(
      fontWeight: FontWeight.w300,
      color: Color(0xffffffff),
    ),
    bodySmall: TextStyle(fontWeight: FontWeight.w300, color: Color(0xFF1D2D2B)),
  ),
);
