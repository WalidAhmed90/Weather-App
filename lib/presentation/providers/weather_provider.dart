import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:weather_app/core/error/failures.dart';
import 'package:weather_app/domain/entities/weather.dart';
import 'package:weather_app/domain/usecases/get_weather.dart';

import '../model/WeatherState.dart';



class WeatherProvider extends StateNotifier<WeatherState> {
  final GetWeather getWeather;
  final Box box;

  WeatherProvider({required this.getWeather, required this.box})
      : super(const WeatherState());

  Future<void> fetchWeather(String city) async {
    state = state.copyWith(isLoading: true);
    
    final Either<Failure, Weather> result = await getWeather(Params(city));

    result.fold((failure) {
      state = state.copyWith(
        errorMessage: failure.message,
        weather: null,
        isLoading: false,
      );
    }, (data) {
      final fromCache = box.get('from_cache', defaultValue: false);
      state = state.copyWith(
        weather: data,
        errorMessage: null,
        isLoading: false,
        fromCache: fromCache,
      );
    });
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}


final weatherBoxProvider = Provider<Box>((ref) {
  throw UnimplementedError('This provider should be overridden');
});

final getWeatherProvider = Provider<GetWeather>((ref) {
  throw UnimplementedError('This provider should be overridden');
});

final weatherNotifierProvider = StateNotifierProvider<WeatherProvider, WeatherState>((ref) {
  final getWeather = ref.watch(getWeatherProvider);
  final box = ref.watch(weatherBoxProvider);
  return WeatherProvider(getWeather: getWeather, box: box);
});

final currentWeatherProvider = Provider<Weather?>((ref) {
  return ref.watch(weatherNotifierProvider).weather;
});

final weatherErrorProvider = Provider<String?>((ref) {
  return ref.watch(weatherNotifierProvider).errorMessage;
});

final weatherLoadingProvider = Provider<bool>((ref) {
  return ref.watch(weatherNotifierProvider).isLoading;
});

final weatherFromCacheProvider = Provider<bool>((ref) {
  return ref.watch(weatherNotifierProvider).fromCache;
});
