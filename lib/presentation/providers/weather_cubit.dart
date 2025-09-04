import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:weather_app/core/error/failures.dart';
import 'package:weather_app/domain/entities/weather.dart';
import 'package:weather_app/domain/usecases/get_weather.dart';

import '../model/WeatherState.dart';



class WeatherCubit extends Cubit<WeatherState> {
  final GetWeather getWeather;
  final Box box;

  WeatherCubit({required this.getWeather, required this.box})
      : super(const WeatherState());

  Future<void> fetchWeather(String city) async {
  final newState = state.copyWith(isLoading: true);
  emit(newState);
    
    final Either<Failure, Weather> result = await getWeather(Params(city));

    result.fold((failure) {
      final newState = state.copyWith(
        errorMessage: failure.message,
        weather: null,
        isLoading: false,
      );
      emit(newState);

    }, (data) {
      final fromCache = box.get('from_cache', defaultValue: false);
      final newState = state.copyWith(
        weather: data,
        errorMessage: '',
        isLoading: false,
        fromCache: fromCache,
      );
      emit(newState);

    });
  }
}
