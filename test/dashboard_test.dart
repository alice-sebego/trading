import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:trading/Services/websocketchannel_service.dart';
import 'package:trading/TestUtils/fake_websocket_service.dart';
import 'package:trading/Widgets/dashboard.dart';
import 'package:trading/Widgets/devise_card.dart';

void main() {
  test('convertSymbol transforme tBTCUSD en BTC/USD', () {
    expect(convertSymbol('tBTCUSD'), 'BTC/USD');
  });

  test('convertSymbol laisse intact les symboles inconnus', () {
    expect(convertSymbol('ETH/EUR'), 'ETH/EUR');
  });
  
  late FakeWebSocketService fakeService;

  setUp(() {
    fakeService = FakeWebSocketService();
    WebSocketChannelService.testingFactory = () => fakeService;
  });

  tearDown(() {
    WebSocketChannelService.testingFactory = null;
  });

  testWidgets('Affiche une DeviseCard quand un message WebSocket arrive',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: DashboardPage(),
      ),
    );

    // Simule d'abord un message "subscribed" pour associer le chanId à un symbole
    fakeService.emitMessage(
      '''{
        "event": "subscribed",
        "chanId": 1234,
        "symbol": "tBTCUSD"
      }''',
    );

    await tester.pumpAndSettle();

    // Puis simule un message de ticker avec des données valides
    fakeService.emitMessage(
      '''[
        1234,
        [123.45, 10, 123.55, 20, 123.00, 0.01, 1000, 123.10, 123.50, 1600000000000]
      ]''',
    );

    await tester.pumpAndSettle();

    // Vérifie que le texte 'BTC/USD' apparaît dans l’interface
    expect(find.text('BTC/USD'), findsOneWidget);
  });
}
