import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../model/SettingsState.dart';


// Settings notifier
class SettingsCubit extends Cubit<SettingsState> {
  final Box _box;
  static const String _key = 'isCelsius';

  SettingsCubit(this._box) : super(SettingsState(isCelsius: _box.get(_key, defaultValue: true) as bool));

  bool get isCelsius => state.isCelsius;

  void toggleUnit() {
    final newIsCelsius = !state.isCelsius;
    _box.put(_key, newIsCelsius);
    final newState = state.copyWith(isCelsius: newIsCelsius);
    emit(newState);
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
