import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketChannelService {
  // >>> AJOUT POUR LES TESTS -------------------------------
  static WebSocketChannelService Function()? testingFactory;

  factory WebSocketChannelService() {
    if (testingFactory != null) return testingFactory!(); // injecté en test
    return WebSocketChannelService._internal();
  }
  // <<< FIN AJOUT ------------------------------------------

  late final WebSocketChannel _channel;
  final List<void Function(dynamic message)> _messageHandlers = [];
  final StreamController<bool> _connectionStatusController =
      StreamController<bool>();

  // Constructeur interne principal
  WebSocketChannelService._internal() {
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://api-pub.bitfinex.com/ws/2'),
    );

    _subscribeToTickers([
      'tBTCUSD', // Bitcoin
      'tETHUSD', // Ethereum
      'tXRPUSD', // Ripple
      'tXTZUSD', // Tezos
      'tDOTUSD', // Polkadot
      'tLTCUSD', // Litecoin
      'tADAUSD', // Cardano
      'tXLMUSD', // Stellar
      'tNEOUSD', // NEO
      'tEOSUSD', // EOS
    ]);
  }

  // Constructeur nommé vide pour tests/fakes
   WebSocketChannelService.fakeConstructor();

  Stream<bool> get connectionStatusStream => _connectionStatusController.stream;

  void _subscribeToTickers(List<String> symbols) {
    for (var symbol in symbols) {
      final subscribeMessage = {
        "event": "subscribe",
        "channel": "ticker",
        "symbol": symbol,
      };
      _channel.sink.add(jsonEncode(subscribeMessage));
    }
  }

  void addMessageHandler(void Function(dynamic message) handler) {
    _messageHandlers.add(handler);
  }

  void _notifyHandlers(dynamic message) {
    for (var handler in _messageHandlers) {
      handler(message);
    }
  }

  void listenToMessages() {
    _channel.stream.listen(
      (message) {
        _connectionStatusController.add(true);
        _notifyHandlers(message);
      },
      onError: (error) {
        _connectionStatusController.add(false);
        // print('Erreur : $error'); // warning lint possible, mais OK en dev
      },
      onDone: () {
        _connectionStatusController.add(false);
        // print('Connexion terminée'); // idem
      },
    );
  }

  void close() {
    _channel.sink.close();
  }
}
