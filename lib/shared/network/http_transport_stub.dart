import 'http_transport.dart';

class _UnsupportedHttpTransport implements HttpTransport {
  @override
  Future<HttpTransportResponse> send({
    required String method,
    required Uri uri,
    Map<String, String> headers = const <String, String>{},
    String? body,
    List<int>? bodyBytes,
  }) {
    throw UnsupportedError('HTTP transport is not supported on this platform.');
  }
}

HttpTransport createPlatformHttpTransport() => _UnsupportedHttpTransport();
