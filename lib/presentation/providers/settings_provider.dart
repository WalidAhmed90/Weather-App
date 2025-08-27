import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SettingsProvider with ChangeNotifier {
  final Box _box;
  static const String _key = 'isCelsius';

  SettingsProvider(this._box) {
    _isCelsius = _box.get(_key, defaultValue: true) as bool;
  }

  bool _isCelsius = true;
  bool get isCelsius => _isCelsius;

  void toggleUnit() {
    _isCelsius = !_isCelsius;
    _box.put(_key, _isCelsius);
    notifyListeners();
  }

  /// input: temperature in Celsius (API units=metric)
  String formatTemperature(double tempCelsius) {
    if (_isCelsius) {
      return "${tempCelsius.toStringAsFixed(1)} °C";
    } else {
      final f = tempCelsius * 9 / 5 + 32;
      return "${f.toStringAsFixed(1)} °F";
    }
  }
}
