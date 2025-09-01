import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:weather_app/core/error/failures.dart';
import 'package:weather_app/domain/entities/weather.dart';
import 'package:weather_app/domain/usecases/get_weather.dart';

class WeatherProvider with ChangeNotifier {
  final GetWeather getWeather;
  final Box box;

  WeatherProvider({required this.getWeather, required this.box});

  Weather? weather;
  String? errorMessage;
  bool isLoading = false;
  bool fromCache = false;

  Future<void> fetchWeather(String city) async {
    isLoading = true;
    notifyListeners();
    fromCache = box.get('from_cache', defaultValue: false);

    final Either<Failure, Weather> result = await getWeather(Params(city));

    result.fold((failure) {
      errorMessage = failure.message;
      weather = null;
    }, (data) {
      weather = data;
      errorMessage = null;
    });

    isLoading = false;
    notifyListeners();
  }
}
