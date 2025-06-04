import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trading/Widgets/devise_card.dart';

void main() {
  testWidgets('DeviseCard affiche le symbole, le prix et le changement',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DeviseCard(
            symbol: 'BTC/USD',
            lastPrice: 27000.55,
            dailyChange: 1.23,
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.text('BTC/USD'), findsOneWidget);
    expect(find.text('Last Price: \$27000.55'), findsOneWidget);
    expect(find.text('1.23%'), findsOneWidget);
  });

  testWidgets('DeviseCard affiche le changement négatif en rouge',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DeviseCard(
            symbol: 'ETH/USD',
            lastPrice: 1850.10,
            dailyChange: -2.50,
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.text('-2.50%'), findsOneWidget);

    final Text textWidget = tester.widget(find.text('-2.50%'));
    expect(textWidget.style?.color, equals(Colors.red));
  });

  testWidgets('DeviseCard appelle onTap lors du tap',
      (WidgetTester tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DeviseCard(
            symbol: 'XRP/USD',
            lastPrice: 0.55,
            dailyChange: 0.5,
            onTap: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byType(DeviseCard));
    expect(tapped, isTrue);
  });
}
