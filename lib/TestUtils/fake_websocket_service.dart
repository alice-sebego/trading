import 'dart:async';
import 'package:trading/Services/websocketchannel_service.dart';

class FakeWebSocketService extends WebSocketChannelService {
  final StreamController<String> _messageStreamController =
      StreamController<String>();
  final StreamController<bool> _connectionStatusController =
      StreamController<bool>();

  final List<void Function(dynamic message)> _handlers = [];

  FakeWebSocketService() : super.fakeConstructor() {
    _init();
  }

  void _init() {
    _messageStreamController.stream.listen((message) {
      for (var handler in _handlers) {
        handler(message);
      }
    });
    _connectionStatusController.add(true);
  }

  @override
  void addMessageHandler(void Function(dynamic message) handler) {
    _handlers.add(handler);
  }

  @override
  void listenToMessages() {
    // Pas besoin d'écouter ici, _init() s'en charge déjà
  }

  void emitMessage(String message) {
    _messageStreamController.add(message);
  }

  @override
  Stream<bool> get connectionStatusStream => _connectionStatusController.stream;

  @override
  void close() {
    _messageStreamController.close();
    _connectionStatusController.close();
  }
}
