import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/presentation/model/WeatherState.dart';

import '../providers/settings_cubit.dart';
import '../providers/theme_cubit.dart';
import '../providers/weather_cubit.dart';

class WeatherScreen extends StatelessWidget {
  WeatherScreen({super.key});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    final settingsState = context.watch<SettingsCubit>().state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Pro'),
        actions: [
          IconButton(
            tooltip: 'Toggle theme',
            icon: Icon(themeState.isDark ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
          ),
          IconButton(
            tooltip: 'Toggle unit',
            icon: Icon(settingsState.isCelsius ? Icons.thermostat : Icons.device_thermostat),
            onPressed: () => context.read<SettingsCubit>().toggleUnit(),
          ),
        ],
      ),
      body: BlocBuilder<WeatherCubit, WeatherState>(
        builder:(context, state) {
          return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Enter city name',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => _onSearch(context),
                  ),
                ),
                onSubmitted: (_) => _onSearch(context),
              ),
              const SizedBox(height: 20),
              if (state.isLoading) const CircularProgressIndicator(),
              if (state.errorMessage != null && state.errorMessage!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(state.errorMessage!,
                      style: const TextStyle(color: Colors.red)),
                ),
              if (state.weather != null)
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (state.fromCache)
                            const Text(
                              'Showing cached data (offline)',
                              style: TextStyle(color: Colors.orange),
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(state.weather!.cityName,
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .headlineLarge),
                              const SizedBox(height: 8),
                              Text(
                                context.read<SettingsCubit>().formatTemperature(
                                    state.weather!.temperature),
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyLarge,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Humidity: ${state.weather!
                                  .humidity}%'),
                              Text(state.weather!.description),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );},
      ),
    );
  }

  void _onSearch(BuildContext context) {
    final city = _controller.text.trim();
    if (city.isEmpty) return;
   context.read<WeatherCubit>().fetchWeather(city);
  }
}
