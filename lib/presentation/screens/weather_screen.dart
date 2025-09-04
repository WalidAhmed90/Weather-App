import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/settings_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/weather_provider.dart';

class WeatherScreen extends ConsumerStatefulWidget {
  const WeatherScreen({super.key});

  @override
  ConsumerState<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends ConsumerState<WeatherScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final weatherState = ref.watch(weatherNotifierProvider);
    final isDark = ref.watch(isDarkProvider);
    final isCelsius = ref.watch(isCelsiusProvider);
    final formatTemperature = ref.watch(formatTemperatureProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Pro'),
        actions: [
          IconButton(
            tooltip: 'Toggle theme',
            icon: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => ref.read(themeNotifierProvider.notifier).toggleTheme(),
          ),
          IconButton(
            tooltip: 'Toggle unit',
            icon: Icon(isCelsius ? Icons.thermostat : Icons.device_thermostat),
            onPressed: () => ref.read(settingsNotifierProvider.notifier).toggleUnit(),
          ),
        ],
      ),
      body: Padding(
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
                  onPressed: () => _onSearch(),
                ),
              ),
              onSubmitted: (_) => _onSearch(),
            ),
            const SizedBox(height: 20),
            if (weatherState.isLoading) const CircularProgressIndicator(),
            if (weatherState.errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(weatherState.errorMessage!, style: const TextStyle(color: Colors.red)),
              ),
            if (weatherState.weather != null)
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (weatherState.fromCache)
                          const Text(
                            'Showing cached data (offline)',
                            style: TextStyle(color: Colors.orange),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(weatherState.weather!.cityName,
                                style: Theme.of(context).textTheme.headlineLarge),
                            const SizedBox(height: 8),
                            Text(
                              formatTemperature(weatherState.weather!.temperature),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Humidity: ${weatherState.weather!.humidity}%'),
                            Text(weatherState.weather!.description),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _onSearch() {
    final city = _controller.text.trim();
    if (city.isEmpty) return;
    ref.read(weatherNotifierProvider.notifier).fetchWeather(city);
  }
}
