import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// What mode to use for theme
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.values[0]) {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeIndex = prefs.getInt('themeMode') ?? 0;
    state = ThemeMode.values[themeModeIndex];
  }

  Future<void> updateThemeMode(ThemeMode newThemeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', newThemeMode.index);
    state = newThemeMode;
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
    (ref) => ThemeModeNotifier());

ThemeData darkTheme = ThemeData(
  primaryColor: Colors.teal,
  useMaterial3: true,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor:
          WidgetStateProperty.all(const Color.fromARGB(255, 47, 47, 47)),
    ),
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 27, 27, 27),
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: Colors.grey[50]!,
    onPrimary: Colors.black,
    secondary: Colors.black,
    onSecondary: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    // background: const Color.fromARGB(255, 27, 27, 27),
    // onBackground: Colors.white,
    surface: const Color.fromARGB(255, 38, 38, 38),
    surfaceContainerHighest: const Color.fromARGB(255, 47, 47, 47),
    onSurface: Colors.white,
    onInverseSurface: const Color.fromARGB(255, 38, 38, 38),
  ),
);

ThemeData lightTheme = ThemeData(
  primaryColor: Colors.teal,
  useMaterial3: true,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor:
          WidgetStateProperty.all(const Color.fromARGB(255, 230, 230, 230)),
    ),
  ),
  scaffoldBackgroundColor: Colors.grey[50]!,
  cardColor: Colors.grey[200]!,
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: const Color.fromARGB(255, 27, 27, 27),
    onPrimary: Colors.white,
    secondary: Colors.white,
    onSecondary: Colors.black,
    error: Colors.red,
    onError: Colors.white,
    // background: Colors.grey[50]!,
    // onBackground: Colors.black,
    surface: Colors.grey[50]!,
    surfaceContainerHighest: Colors.grey[300]!,
    onSurface: Colors.black,
    onInverseSurface: Colors.grey[200]!,
  ),
);
