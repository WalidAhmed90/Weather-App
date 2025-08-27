import 'package:dartz/dartz.dart';
import 'package:weather_app/core/error/failures.dart';
import 'package:weather_app/core/usecase/usecase.dart';
import 'package:weather_app/domain/entities/weather.dart';
import 'package:weather_app/domain/repositories/weather_repository.dart';

class GetWeather extends UseCase<Weather, Params> {
  final WeatherRepository repository;

  GetWeather(this.repository);

  @override
  Future<Either<Failure, Weather>> call(Params params) async {
    return await repository.getWeather(params.city);
  }
}

class Params {
  final String city;
  Params(this.city);
}
