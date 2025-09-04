import '../../domain/entities/weather.dart';

class WeatherState {
  final Weather? weather;
  final String? errorMessage;
  final bool isLoading;
  final bool fromCache;

  const WeatherState({
    this.weather,
    this.errorMessage,
    this.isLoading = false,
    this.fromCache = false,
  });

  WeatherState copyWith({
    Weather? weather,
    String? errorMessage,
    bool? isLoading,
    bool? fromCache,
  }) {
    return WeatherState(
      weather: weather ?? this.weather,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
      fromCache: fromCache ?? this.fromCache,
    );
  }
}