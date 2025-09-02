import 'package:hive/hive.dart';
import 'package:weather_app/core/error/exceptions.dart';
import 'package:weather_app/data/models/weather_model.dart';

abstract class WeatherLocalDataSource {
  Future<WeatherModel> getLastWeather();
  Future<void> cacheWeather(WeatherModel weatherToCache);
  void setFromCache(bool fromCache);
}

class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  final Box box;
  final Box cacheBox;

  WeatherLocalDataSourceImpl({required this.box, required this.cacheBox});

  @override
  Future<WeatherModel> getLastWeather() async {
    final data = box.get('cached_weather');
    if (data != null) {
      return data;
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheWeather(WeatherModel weatherToCache) async {
    await box.put('cached_weather', weatherToCache);
  }

  @override
  void setFromCache(bool fromCache) {
    cacheBox.put('from_cache', fromCache);
  }
}
