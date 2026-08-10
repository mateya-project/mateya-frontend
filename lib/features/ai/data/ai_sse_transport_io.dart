import 'dart:convert';
import 'dart:io';

import 'ai_sse_transport.dart';

class _IoAiSseTransport implements AiSseTransport {
  @override
  Stream<AiSseEvent> post({
    required Uri uri,
    required Map<String, String> headers,
    required String body,
  }) async* {
    final client = HttpClient();
    try {
      final request = await client.postUrl(uri);
      headers.forEach(request.headers.set);
      request.add(utf8.encode(body));
      final response = await request.close();
      if (response.statusCode < 200 || response.statusCode >= 300) {
        final errorBody = await utf8.decoder.bind(response).join();
        throw HttpException(
          'AI stream failed (${response.statusCode}): $errorBody',
          uri: uri,
        );
      }

      var eventName = 'message';
      final dataLines = <String>[];
      await for (final line
          in response.transform(utf8.decoder).transform(const LineSplitter())) {
        if (line.isEmpty) {
          if (dataLines.isNotEmpty) {
            yield AiSseEvent(event: eventName, data: dataLines.join('\n'));
            eventName = 'message';
            dataLines.clear();
          }
        } else if (line.startsWith('event:')) {
          eventName = line.substring(6).trim();
        } else if (line.startsWith('data:')) {
          dataLines.add(line.substring(5).trimLeft());
        }
      }
      if (dataLines.isNotEmpty) {
        yield AiSseEvent(event: eventName, data: dataLines.join('\n'));
      }
    } finally {
      client.close(force: true);
    }
  }
}

AiSseTransport createPlatformAiSseTransport() => _IoAiSseTransport();
