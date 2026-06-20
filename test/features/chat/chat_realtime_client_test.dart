import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/chat/data/chat_realtime_client.dart';

void main() {
  group('buildChatWebSocketUrl', () {
    test('converts https origins to wss without adding port zero', () {
      expect(
        buildChatWebSocketUrl('https://api.mateya.cloud'),
        'wss://api.mateya.cloud/ws',
      );
    });

    test('preserves explicit ports for local development', () {
      expect(
        buildChatWebSocketUrl('http://localhost:8080'),
        'ws://localhost:8080/ws',
      );
    });
  });
}
