import 'http_transport_stub.dart'
    if (dart.library.io) 'http_transport_io.dart'
    if (dart.library.html) 'http_transport_web.dart';

class HttpTransportResponse {
  const HttpTransportResponse({
    required this.statusCode,
    required this.body,
    this.headers = const <String, String>{},
  });

  final int statusCode;
  final String body;
  final Map<String, String> headers;
}

abstract interface class HttpTransport {
  Future<HttpTransportResponse> send({
    required String method,
    required Uri uri,
    Map<String, String> headers,
    String? body,
    List<int>? bodyBytes,
  });
}

HttpTransport createHttpTransport() => createPlatformHttpTransport();
