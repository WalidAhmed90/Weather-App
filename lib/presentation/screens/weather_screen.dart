import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/weather_provider.dart';


class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final weatherVM = context.watch<WeatherProvider>();
    final themeVM = context.read<ThemeProvider>();
    final settingsVM = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Pro'),
        actions: [
          IconButton(
            tooltip: 'Toggle theme',
            icon: Icon(themeVM.isDark ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => themeVM.toggleTheme(),
          ),
          IconButton(
            tooltip: 'Toggle unit',
            icon: Icon(
                settingsVM.isCelsius ? Icons.thermostat : Icons.device_thermostat),
            onPressed: () => settingsVM.toggleUnit(),
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
                  onPressed: () => _onSearch(context),
                ),
              ),
              onSubmitted: (_) => _onSearch(context),
            ),
            const SizedBox(height: 20),
            if (weatherVM.isLoading) const CircularProgressIndicator(),
            if (weatherVM.errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(weatherVM.errorMessage!, style: const TextStyle(color: Colors.red)),
              ),
            if (weatherVM.weather != null)
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (weatherVM.fromCache)
                          const Text(
                            'Showing cached data (offline)',
                            style: TextStyle(color: Colors.orange),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(weatherVM.weather!.cityName,
                                style: Theme.of(context).textTheme.headlineLarge),
                            const SizedBox(height: 8),
                            Text(
                              settingsVM.formatTemperature(weatherVM.weather!.temperature),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Humidity: ${weatherVM.weather!.humidity}%'),
                            Text(weatherVM.weather!.description),
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

  void _onSearch(BuildContext context) {
    final city = _controller.text.trim();
    if (city.isEmpty) return;
    context.read<WeatherProvider>().fetchWeather(city);
  }
}
