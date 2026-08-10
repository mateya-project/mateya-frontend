// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;

import 'ai_sse_transport.dart';

class _WebAiSseTransport implements AiSseTransport {
  @override
  Stream<AiSseEvent> post({
    required Uri uri,
    required Map<String, String> headers,
    required String body,
  }) async* {
    final response = await html.HttpRequest.request(
      uri.toString(),
      method: 'POST',
      requestHeaders: headers,
      sendData: body,
    );
    for (final event in parseAiSseText(response.responseText ?? '')) {
      yield event;
    }
  }
}

AiSseTransport createPlatformAiSseTransport() => _WebAiSseTransport();
