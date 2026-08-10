import 'ai_sse_transport_stub.dart'
    if (dart.library.io) 'ai_sse_transport_io.dart'
    if (dart.library.html) 'ai_sse_transport_web.dart';

class AiSseEvent {
  const AiSseEvent({required this.event, required this.data});

  final String event;
  final String data;
}

abstract interface class AiSseTransport {
  Stream<AiSseEvent> post({
    required Uri uri,
    required Map<String, String> headers,
    required String body,
  });
}

AiSseTransport createAiSseTransport() => createPlatformAiSseTransport();

List<AiSseEvent> parseAiSseText(String source) {
  final events = <AiSseEvent>[];
  var eventName = 'message';
  final dataLines = <String>[];
  void flush() {
    if (dataLines.isEmpty) {
      return;
    }
    events.add(AiSseEvent(event: eventName, data: dataLines.join('\n')));
    eventName = 'message';
    dataLines.clear();
  }

  for (final line in source.split(RegExp(r'\r?\n'))) {
    if (line.isEmpty) {
      flush();
    } else if (line.startsWith('event:')) {
      eventName = line.substring(6).trim();
    } else if (line.startsWith('data:')) {
      dataLines.add(line.substring(5).trimLeft());
    }
  }
  flush();
  return events;
}
