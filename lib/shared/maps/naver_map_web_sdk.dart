// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:async';
import 'dart:html' as html;
import 'dart:js' as js;

import '../../app/app_config.dart';

class NaverMapWebSdk {
  static const String _scriptId = 'mateya-naver-map-sdk';
  static const List<String> _submodules = <String>['geocoder'];

  static Future<void>? _loadFuture;

  static Future<void> load() {
    final existingFuture = _loadFuture;
    if (existingFuture != null) {
      return existingFuture;
    }

    final completer = Completer<void>();
    _loadFuture = completer.future;

    if (_hasRequiredNamespaces()) {
      completer.complete();
      return completer.future;
    }

    final head = html.document.head;
    if (head == null) {
      completer.completeError(StateError('Document head is unavailable'));
      return completer.future;
    }

    final existingScript = html.document.getElementById(_scriptId);
    if (existingScript is html.ScriptElement) {
      if (_scriptHasRequiredSubmodules(existingScript.src)) {
        _waitForNamespace(completer);
        return completer.future;
      }
      existingScript.remove();
    }

    final script = html.ScriptElement()
      ..id = _scriptId
      ..async = true
      ..defer = true
      ..src = _sdkUrl();

    script.onLoad.first.then((_) => _waitForNamespace(completer));
    script.onError.first.then((_) {
      if (!completer.isCompleted) {
        completer.completeError(
          StateError('Failed to load Naver Maps JavaScript SDK'),
        );
      }
    });

    head.append(script);
    return completer.future;
  }

  static String _sdkUrl() {
    final parameters = <String, String>{
      'ncpKeyId': AppConfig.naverMapClientId,
      'submodules': _submodules.join(','),
    };
    return Uri.https(
      'oapi.map.naver.com',
      '/openapi/v3/maps.js',
      parameters,
    ).toString();
  }

  static bool _scriptHasRequiredSubmodules(String source) {
    final uri = Uri.tryParse(source);
    if (uri == null) {
      return false;
    }
    final loadedSubmodules = (uri.queryParameters['submodules'] ?? '')
        .split(',')
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toSet();
    return _submodules.every(loadedSubmodules.contains);
  }

  static void _waitForNamespace(Completer<void> completer) {
    if (_hasRequiredNamespaces()) {
      if (!completer.isCompleted) {
        completer.complete();
      }
      return;
    }

    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_hasRequiredNamespaces()) {
        timer.cancel();
        if (!completer.isCompleted) {
          completer.complete();
        }
        return;
      }
      if (timer.tick >= 100) {
        timer.cancel();
        if (!completer.isCompleted) {
          completer.completeError(
            StateError('Timed out waiting for Naver Maps JavaScript SDK'),
          );
        }
      }
    });
  }

  static bool _hasRequiredNamespaces() {
    if (!js.context.hasProperty('naver')) {
      return false;
    }
    final naver = js.context['naver'];
    if (naver is! js.JsObject || !naver.hasProperty('maps')) {
      return false;
    }
    final maps = naver['maps'];
    return maps is js.JsObject && maps.hasProperty('Service');
  }
}
