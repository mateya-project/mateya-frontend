import 'dart:convert';
import 'dart:io';

import 'http_transport.dart';

class _IoHttpTransport implements HttpTransport {
  @override
  Future<HttpTransportResponse> send({
    required String method,
    required Uri uri,
    Map<String, String> headers = const <String, String>{},
    String? body,
  }) async {
    final client = HttpClient();
    try {
      final request = await client.openUrl(method, uri);
      headers.forEach(request.headers.set);
      if (body != null) {
        request.add(utf8.encode(body));
      }

      final response = await request.close();
      final responseBody = await utf8.decoder.bind(response).join();
      final responseHeaders = <String, String>{};
      response.headers.forEach((name, values) {
        responseHeaders[name] = values.join(', ');
      });

      return HttpTransportResponse(
        statusCode: response.statusCode,
        body: responseBody,
        headers: responseHeaders,
      );
    } finally {
      client.close(force: true);
    }
  }
}

HttpTransport createPlatformHttpTransport() => _IoHttpTransport();
