import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LifetimeNotifier extends StateNotifier<double> {
  final String key;

  LifetimeNotifier(this.key) : super(0) {
    _loadValue();
  }

  Future<void> _loadValue() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getDouble(key) ?? 0;
    state = value;
  }

  Future<void> updateValue(double newValue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, newValue);
    state = newValue;
  }

  Future<void> resetValue() async {
    await updateValue(0);
  }
}

final lifetimeDistanceProvider =
    StateNotifierProvider<LifetimeNotifier, double>(
        (ref) => LifetimeNotifier('lifetimeDistance'));

final lifetimeTopSpeedProvider =
    StateNotifierProvider<LifetimeNotifier, double>(
        (ref) => LifetimeNotifier('lifetimeTopSpeed'));
