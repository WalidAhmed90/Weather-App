import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

// Settings state class
class SettingsState {
  final bool isCelsius;

  const SettingsState({required this.isCelsius});

  SettingsState copyWith({bool? isCelsius}) {
    return SettingsState(isCelsius: isCelsius ?? this.isCelsius);
  }
}

// Settings notifier
class SettingsNotifier extends StateNotifier<SettingsState> {
  final Box _box;
  static const String _key = 'isCelsius';

  SettingsNotifier(this._box) : super(SettingsState(isCelsius: _box.get(_key, defaultValue: true) as bool));

  bool get isCelsius => state.isCelsius;

  void toggleUnit() {
    final newIsCelsius = !state.isCelsius;
    _box.put(_key, newIsCelsius);
    state = state.copyWith(isCelsius: newIsCelsius);
  }

  /// input: temperature in Celsius (API units=metric)
  String formatTemperature(double tempCelsius) {
    if (state.isCelsius) {
      return "${tempCelsius.toStringAsFixed(1)} °C";
    } else {
      final f = tempCelsius * 9 / 5 + 32;
      return "${f.toStringAsFixed(1)} °F";
    }
  }
}

// Providers
final settingsBoxProvider = Provider<Box>((ref) {
  throw UnimplementedError('This provider should be overridden');
});

final settingsNotifierProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  final box = ref.watch(settingsBoxProvider);
  return SettingsNotifier(box);
});

final isCelsiusProvider = Provider<bool>((ref) {
  return ref.watch(settingsNotifierProvider).isCelsius;
});

final formatTemperatureProvider = Provider<String Function(double)>((ref) {
  return ref.read(settingsNotifierProvider.notifier).formatTemperature;
});
