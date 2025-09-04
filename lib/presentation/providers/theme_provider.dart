import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

// Theme state class
class ThemeState {
  final bool isDark;

  const ThemeState({required this.isDark});

  ThemeState copyWith({bool? isDark}) {
    return ThemeState(isDark: isDark ?? this.isDark);
  }
}

// Theme notifier
class ThemeNotifier extends StateNotifier<ThemeState> {
  final Box _box;
  static const String _key = 'isDark';

  ThemeNotifier(this._box) : super(ThemeState(isDark: _box.get(_key, defaultValue: false) as bool));

  bool get isDark => state.isDark;
  ThemeMode get themeMode => state.isDark ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    final newIsDark = !state.isDark;
    _box.put(_key, newIsDark);
    state = state.copyWith(isDark: newIsDark);
  }
}

// Providers
final themeBoxProvider = Provider<Box>((ref) {
  throw UnimplementedError('This provider should be overridden');
});

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  final box = ref.watch(themeBoxProvider);
  return ThemeNotifier(box);
});

final isDarkProvider = Provider<bool>((ref) {
  return ref.watch(themeNotifierProvider).isDark;
});

final themeModeProvider = Provider<ThemeMode>((ref) {
  return ref.read(themeNotifierProvider.notifier).themeMode;
});
