import 'package:weather_app/core/constants.dart';
import 'package:weather_app/core/error/exceptions.dart';
import 'package:weather_app/data/models/weather_model.dart';

import '../../core/network/api_client.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getWeather(String city);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final ApiClient apiClient;

  WeatherRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<WeatherModel> getWeather(String city) async {
    final url =
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=${AppConstants.apiKey}&units=metric";

    final jsonResponse = await apiClient.get(url);

    try {
      return WeatherModel.fromJson(jsonResponse);
    } catch (e) {
      throw ServerException(message: "Failed to parse WeatherModel: $e");
    }
  }
}
