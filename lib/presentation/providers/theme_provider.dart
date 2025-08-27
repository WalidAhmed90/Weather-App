import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider with ChangeNotifier {
  final Box _box;
  static const String _key = 'isDark';

  ThemeProvider(this._box) {
    _isDark = _box.get(_key, defaultValue: false) as bool;
  }

  bool _isDark = false;

  bool get isDark => _isDark;
  ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDark = !_isDark;
    _box.put(_key, _isDark);
    notifyListeners();
  }
}
