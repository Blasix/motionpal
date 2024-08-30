import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsLogic {
  // static bool isKMPH = false;
  static bool isChart = false;
}

// class ThemeModeNotifier extends StateNotifier<ThemeMode> {
//   ThemeModeNotifier() : super(ThemeMode.values[0]) {
//     _loadThemeMode();
//   }

//   Future<void> _loadThemeMode() async {
//     final prefs = await SharedPreferences.getInstance();
//     final themeModeIndex = prefs.getInt('themeMode') ?? 0;
//     state = ThemeMode.values[themeModeIndex];
//   }

//   Future<void> updateThemeMode(ThemeMode newThemeMode) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setInt('themeMode', newThemeMode.index);
//     state = newThemeMode;
//   }
// }

// final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
//     (ref) => ThemeModeNotifier());

class IsKMPHNotifier extends StateNotifier<bool> {
  IsKMPHNotifier() : super(true) {
    _loadIsKMPH();
  }

  Future<void> _loadIsKMPH() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('isKMPH') ?? true;
  }

  Future<void> updateIsKMPH(bool newIsKMPH) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isKMPH', newIsKMPH);
    state = newIsKMPH;
  }
}

final isKMPHProvider =
    StateNotifierProvider<IsKMPHNotifier, bool>((ref) => IsKMPHNotifier());
