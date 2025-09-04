import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../model/ThemeState.dart';



// Theme notifier
class ThemeCubit extends Cubit<ThemeState> {
  final Box _box;
  static const String _key = 'isDark';

  ThemeCubit(this._box) : super(ThemeState(isDark: _box.get(_key, defaultValue: false) as bool));

  bool get isDark => state.isDark;
  ThemeMode get themeMode => state.isDark ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    final newIsDark = !state.isDark;
    _box.put(_key, newIsDark);
    final newState = state.copyWith(isDark: newIsDark);
    emit(newState);
  }
}
