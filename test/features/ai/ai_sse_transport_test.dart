import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/ai/data/ai_sse_transport.dart';

void main() {
  test('AI SSE parser preserves event order and JSON payloads', () {
    final events = parseAiSseText('''
event: accepted
data: {"clientMessageId":"client-1"}

event: completed
data: {"conversation":{"id":"conversation-1"}}

''');

    expect(events.map((event) => event.event), <String>[
      'accepted',
      'completed',
    ]);
    expect(events.last.data, contains('conversation-1'));
  });
}
