import 'package:hive/hive.dart';
import '../../domain/entities/weather.dart';

part 'weather_model.g.dart';

@HiveType(typeId: 0)
class WeatherModel extends HiveObject {
  @HiveField(0)
  String cityName;

  @HiveField(1)
  double temperature;

  @HiveField(2)
  int humidity;

  @HiveField(3)
  String description;

  @HiveField(4)
  DateTime lastUpdated;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.humidity,
    required this.description,
    required this.lastUpdated,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: (json['name'] ?? '') as String,
      temperature: ((json['main']?['temp'] ?? 0) as num).toDouble(),
      humidity: ((json['main']?['humidity'] ?? 0) as num).toInt(),
      description: ((json['weather'] as List).isNotEmpty
          ? json['weather'][0]['description']
          : '') as String,
      lastUpdated: DateTime.now(),
    );
  }

  Weather toEntity() {
    return Weather(
      cityName: cityName,
      temperature: temperature,
      humidity: humidity,
      description: description,
    );
  }

  factory WeatherModel.fromEntity(Weather entity) {
    return WeatherModel(
      cityName: entity.cityName,
      temperature: entity.temperature,
      humidity: entity.humidity,
      description: entity.description,
      lastUpdated: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': cityName,
      'main': {
        'temp': temperature,
        'humidity': humidity,
      },
      'weather': [
        {'description': description}
      ],
    };
  }
}
