// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;
import 'dart:typed_data';

import 'http_transport.dart';

class _WebHttpTransport implements HttpTransport {
  @override
  Future<HttpTransportResponse> send({
    required String method,
    required Uri uri,
    Map<String, String> headers = const <String, String>{},
    String? body,
    List<int>? bodyBytes,
  }) async {
    final response = await html.HttpRequest.request(
      uri.toString(),
      method: method,
      requestHeaders: headers,
      sendData:
          body ?? (bodyBytes == null ? null : Uint8List.fromList(bodyBytes)),
    );

    return HttpTransportResponse(
      statusCode: response.status ?? 0,
      body: response.responseText ?? '',
      headers: response.responseHeaders,
    );
  }
}

HttpTransport createPlatformHttpTransport() => _WebHttpTransport();
