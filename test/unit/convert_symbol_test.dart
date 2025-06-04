import 'package:flutter_test/flutter_test.dart';
import 'package:trading/Widgets/devise_card.dart'; // convertSymbol est ici

void main() {
  group('convertSymbol()', () {
    test('convertit un symbole Bitfinex valide (tBTCUSD)', () {
      expect(convertSymbol('tBTCUSD'), equals('BTC/USD'));
    });

    test('laisse inchangé un symbole déjà formaté', () {
      expect(convertSymbol('BTC/USD'), equals('BTC/USD'));
    });

    test('laisse inchangé un symbole inconnu ou invalide', () {
      expect(convertSymbol('XYZ123'), equals('XYZ123'));
    });
  });
}
