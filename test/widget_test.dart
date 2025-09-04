// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in this test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:weather_app/domain/usecases/get_weather.dart';
import 'package:weather_app/presentation/providers/weather_cubit.dart';
import 'package:weather_app/presentation/providers/theme_cubit.dart';
import 'package:weather_app/presentation/providers/settings_cubit.dart';

import 'package:weather_app/main.dart';

void main() {
  testWidgets('Weather app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
    MultiBlocProvider(providers: [
      BlocProvider(create: (context) => ThemeCubit(Hive.box('test_setting'))),
      BlocProvider(create: (context) => SettingsCubit(Hive.box('test_setting'))),
    ], child: AppRoot())
    );

    // Verify that the app title is displayed
    expect(find.text('Weather Pro'), findsOneWidget);
    
    // Verify that the search field is present
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Enter city name'), findsOneWidget);
  });
}
