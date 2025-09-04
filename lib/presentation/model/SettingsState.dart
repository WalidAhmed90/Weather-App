
// Settings state class
class SettingsState {
  final bool isCelsius;

  const SettingsState({required this.isCelsius});

  SettingsState copyWith({bool? isCelsius}) {
    return SettingsState(isCelsius: isCelsius ?? this.isCelsius);
  }
}
