// This is a basic Flutter widget test for the currency converter app.

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:currency_converter/core/di/injection.dart';
import 'package:currency_converter/main.dart';

void main() {
  setUpAll(() async {
    // Reset GetIt before each test
    if (GetIt.instance.isRegistered<Dio>()) {
      await GetIt.instance.reset();
    }
    // Setup dependency injection for testing
    await configureDependencies(testPath: './test/hive_test');
  });

  tearDownAll(() async {
    // Clean up after tests
    await GetIt.instance.reset();
  });

  testWidgets('App should load and show currency converter', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Verify that the app loads with the converter page
    expect(find.text('Currency Converter'), findsWidgets);
    expect(find.text('Supported Currencies'), findsNothing); // Not on initial page
    expect(find.text('Historical Rates'), findsNothing); // Not on initial page
  });
}
