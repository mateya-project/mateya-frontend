import 'ai_sse_transport.dart';

class _UnsupportedAiSseTransport implements AiSseTransport {
  @override
  Stream<AiSseEvent> post({
    required Uri uri,
    required Map<String, String> headers,
    required String body,
  }) => Stream<AiSseEvent>.error(
    UnsupportedError('SSE transport is not supported on this platform.'),
  );
}

AiSseTransport createPlatformAiSseTransport() => _UnsupportedAiSseTransport();
