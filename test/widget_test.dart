import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trading/main.dart';

void main() {
  group('App Navigation Tests', () {
    testWidgets(
        'Displays home page and navigates to DashboardPage when button is tapped',
        (WidgetTester tester) async {
      // Arrange: build the app
      await tester.pumpWidget(const MyApp());

      // Act & Assert: check if the initial button exists
      final seeDashboardButton = find.text('See Dashboard');
      expect(seeDashboardButton, findsOneWidget);

      // Act: tap the button
      await tester.tap(seeDashboardButton);
      await tester.pumpAndSettle(); // Wait for any navigation animations

      // Assert: check if the DashboardPage is displayed
      final dashboardTitle = find.text('Dashboard');
      expect(dashboardTitle, findsOneWidget);

      // Optionally: check if the loading state or connection error is handled
      final errorIcon = find.byIcon(Icons.error);
      final tryAgainButton = find.text('Try again');
      final listView = find.byType(ListView);

      // Assert one of the UI states: either an error, or a list
      expect(
        errorIcon.evaluate().isNotEmpty || listView.evaluate().isNotEmpty,
        true,
        reason: 'Should display either data or an error connection state',
      );

      // Optional: verify if WebSocket reconnect button is tappable
      if (tryAgainButton.evaluate().isNotEmpty) {
        await tester.tap(tryAgainButton);
        await tester.pump();
      }
    });
  });
}
