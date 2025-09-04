import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:weather_app/presentation/providers/settings_provider.dart';
import 'package:weather_app/presentation/providers/theme_provider.dart';
import 'package:weather_app/presentation/providers/weather_provider.dart';

import 'core/constants.dart';
import 'core/network/api_client.dart';
import 'core/network/network_info.dart';

import 'data/models/weather_model.dart';
import 'data/datasources/weather_remote_data_source.dart';
import 'data/datasources/weather_local_data_source.dart';
import 'data/repositories/weather_repository_impl.dart';

import 'domain/usecases/get_weather.dart';

import 'presentation/screens/weather_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // init Hive
  await Hive.initFlutter();
  Hive.registerAdapter(WeatherModelAdapter());
  final weatherBox = await Hive.openBox<WeatherModel>(AppConstants.weatherBox);

  // settings box for theme & units
  final settingsBox = await Hive.openBox(AppConstants.settingBox);
  //Cache check box
  final cacheBox = await Hive.openBox(AppConstants.cacheBox);

  // dependencies
  final connectivity = Connectivity();
  final networkInfo = NetworkInfoImpl(connectivity);
  final client = ApiClient(client: http.Client(), networkInfo: networkInfo);

  final remoteDataSource = WeatherRemoteDataSourceImpl(
    apiClient: client,
  );

  final localDataSource = WeatherLocalDataSourceImpl(box: weatherBox, cacheBox: cacheBox);

  final repository = WeatherRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
    networkInfo: networkInfo,
  );

  final getWeather = GetWeather(repository);

  runApp(
    ProviderScope(
      overrides: [
        weatherBoxProvider.overrideWithValue(cacheBox),
        themeBoxProvider.overrideWithValue(settingsBox),
        settingsBoxProvider.overrideWithValue(settingsBox),
        getWeatherProvider.overrideWithValue(getWeather),
      ],
      child: const AppRoot(),
    ),
  );
}

class AppRoot extends ConsumerWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Weather Pro',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const WeatherScreen(),
    );
  }
}
