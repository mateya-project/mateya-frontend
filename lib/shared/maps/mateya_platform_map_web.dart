// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:async';
import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

import '../../app/app_config.dart';
import '../theme/app_tokens.dart';
import 'mateya_platform_map_models.dart';

class MateyaPlatformMap extends StatefulWidget {
  const MateyaPlatformMap({
    super.key,
    required this.centerLatitude,
    required this.centerLongitude,
    required this.zoom,
    required this.markers,
    this.showScaleControl = true,
    this.bottomPadding = 0,
    this.onMapReady,
    this.onMapLoaded,
  });

  final double centerLatitude;
  final double centerLongitude;
  final double zoom;
  final List<MateyaPlatformMapMarker> markers;
  final bool showScaleControl;
  final double bottomPadding;
  final VoidCallback? onMapReady;
  final VoidCallback? onMapLoaded;

  @override
  State<MateyaPlatformMap> createState() => _MateyaPlatformMapState();
}

class _MateyaPlatformMapState extends State<MateyaPlatformMap> {
  static int _nextViewId = 0;

  late final String _viewType;
  late final html.DivElement _container;

  Object? _map;
  Object? _infoWindow;
  final Map<String, Object> _markersById = <String, Object>{};

  bool _isDisposed = false;
  bool _reportedLoaded = false;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _viewType = 'mateya-platform-map-${_nextViewId++}';
    _container = html.DivElement()
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.border = '0'
      ..style.margin = '0'
      ..style.padding = '0'
      ..style.backgroundColor = '#FFFFFF';
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (viewId) {
      return _container;
    });
    unawaited(_initializeMap());
  }

  @override
  void didUpdateWidget(covariant MateyaPlatformMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_map == null) {
      return;
    }
    _syncMapState();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _clearMarkers();
    _closeInfoWindow();
    _map = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loadError != null) {
      return ColoredBox(
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              _loadError!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
    return HtmlElementView(viewType: _viewType);
  }

  Future<void> _initializeMap() async {
    try {
      await _NaverMapWebSdkLoader.load();
      await _waitUntilAttached();
      if (!mounted || _isDisposed) {
        return;
      }
      _createMap();
      widget.onMapReady?.call();
      _syncMapState();
    } catch (error) {
      if (!mounted || _isDisposed) {
        return;
      }
      setState(() {
        _loadError = '네이버 지도를 불러오지 못했어요.';
      });
    }
  }

  Future<void> _waitUntilAttached() async {
    for (var attempt = 0; attempt < 40; attempt++) {
      if (_container.isConnected == true) {
        return;
      }
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
  }

  void _createMap() {
    final maps = _mapsNamespace();
    final mapClass = maps['Map'] as Object;
    final mapOptions = js.JsObject.jsify(<String, Object?>{
      'center': _latLng(widget.centerLatitude, widget.centerLongitude),
      'zoom': widget.zoom,
      'scaleControl': widget.showScaleControl,
    });
    _map = js.JsObject(mapClass as dynamic, <Object?>[_container, mapOptions]);

    final eventNamespace = maps['Event'] as js.JsObject;
    eventNamespace.callMethod('addListener', <Object?>[
      _map,
      'idle',
      () {
        if (_reportedLoaded || _isDisposed) {
          return;
        }
        _reportedLoaded = true;
        widget.onMapLoaded?.call();
      },
    ]);
  }

  void _syncMapState() {
    final map = _map;
    if (map == null) {
      return;
    }

    final center = _latLng(widget.centerLatitude, widget.centerLongitude);
    (map as js.JsObject).callMethod('setCenter', <Object?>[center]);
    map.callMethod('setZoom', <Object?>[widget.zoom]);

    _clearMarkers();

    MateyaPlatformMapMarker? selectedMarkerData;
    Object? selectedMarkerObject;

    for (final markerData in widget.markers) {
      final marker = _createMarker(markerData);
      _markersById[markerData.id] = marker;
      if (markerData.isSelected) {
        selectedMarkerData = markerData;
        selectedMarkerObject = marker;
      }
    }

    _syncInfoWindow(
      selectedMarker: selectedMarkerObject,
      selectedMarkerData: selectedMarkerData,
    );
  }

  Object _createMarker(MateyaPlatformMapMarker markerData) {
    final maps = _mapsNamespace();
    final markerClass = maps['Marker'] as Object;
    final markerOptions = js.JsObject.jsify(<String, Object?>{
      'map': _map,
      'position': _latLng(markerData.latitude, markerData.longitude),
      'icon': _buildHtmlIcon(markerData.isSelected),
      'zIndex': markerData.isSelected ? 100 : 10,
      'clickable': true,
    });
    final marker = js.JsObject(markerClass as dynamic, <Object?>[
      markerOptions,
    ]);

    if (markerData.onTap != null) {
      final eventNamespace = maps['Event'] as js.JsObject;
      eventNamespace.callMethod('addListener', <Object?>[
        marker,
        'click',
        (_) {
          markerData.onTap?.call();
        },
      ]);
    }

    return marker;
  }

  Object _buildHtmlIcon(bool isSelected) {
    final maps = _mapsNamespace();
    final pointClass = maps['Point'] as Object;
    final diameter = isSelected ? 22 : 18;
    final iconHtml =
        '<div style="width:${diameter}px;height:${diameter}px;'
        'border-radius:999px;background:${_colorToCss(isSelected ? AppColors.brandGreen : AppColors.brandGreenLight)};'
        'border:3px solid #FFFFFF;box-shadow:0 4px 12px rgba(0,0,0,0.18);"></div>';
    return js.JsObject.jsify(<String, Object?>{
      'content': iconHtml,
      'anchor': js.JsObject(pointClass as dynamic, <Object?>[
        diameter / 2,
        diameter / 2,
      ]),
    });
  }

  void _syncInfoWindow({
    required Object? selectedMarker,
    required MateyaPlatformMapMarker? selectedMarkerData,
  }) {
    _closeInfoWindow();
    if (selectedMarker == null || selectedMarkerData?.label == null) {
      return;
    }
    final maps = _mapsNamespace();
    final infoWindowClass = maps['InfoWindow'] as Object;
    _infoWindow = js.JsObject(infoWindowClass as dynamic, <Object?>[
      js.JsObject.jsify(<String, Object?>{
        'content': _infoWindowHtml(selectedMarkerData!.label!),
        'borderWidth': 0,
        'disableAnchor': true,
        'backgroundColor': 'transparent',
      }),
    ]);
    (_infoWindow as js.JsObject).callMethod('open', <Object?>[
      _map,
      selectedMarker,
    ]);
  }

  String _infoWindowHtml(String label) {
    final container = html.DivElement()..text = label;
    container.style
      ..padding = '6px 10px'
      ..borderRadius = '999px'
      ..backgroundColor = '#FFFFFF'
      ..color = '#111111'
      ..fontSize = '12px'
      ..fontWeight = '700'
      ..boxShadow = '0 6px 18px rgba(0,0,0,0.14)'
      ..border = '1px solid rgba(17,17,17,0.06)'
      ..whiteSpace = 'nowrap'
      ..transform = 'translateY(-8px)';
    return container.outerHtml ?? '';
  }

  void _clearMarkers() {
    for (final marker in _markersById.values) {
      (marker as js.JsObject).callMethod('setMap', <Object?>[null]);
    }
    _markersById.clear();
  }

  void _closeInfoWindow() {
    final infoWindow = _infoWindow;
    if (infoWindow != null) {
      (infoWindow as js.JsObject).callMethod('close', const <Object?>[]);
    }
    _infoWindow = null;
  }

  js.JsObject _mapsNamespace() {
    final naver = js.context['naver'] as js.JsObject;
    return naver['maps'] as js.JsObject;
  }

  Object _latLng(double latitude, double longitude) {
    final maps = _mapsNamespace();
    final latLngClass = maps['LatLng'] as Object;
    return js.JsObject(latLngClass as dynamic, <Object?>[latitude, longitude]);
  }

  String _colorToCss(Color color) {
    final value = color.toARGB32();
    final rgb = value & 0x00FFFFFF;
    return '#${rgb.toRadixString(16).padLeft(6, '0')}';
  }
}

class _NaverMapWebSdkLoader {
  static const String _scriptId = 'mateya-naver-map-sdk';
  static Future<void>? _loadFuture;

  static Future<void> load() {
    final existingFuture = _loadFuture;
    if (existingFuture != null) {
      return existingFuture;
    }
    final completer = Completer<void>();
    _loadFuture = completer.future;

    if (_hasMapsNamespace()) {
      completer.complete();
      return completer.future;
    }

    final existingScript = html.document.getElementById(_scriptId);
    if (existingScript is html.ScriptElement) {
      _waitForNamespace(completer);
      return completer.future;
    }

    final script = html.ScriptElement()
      ..id = _scriptId
      ..async = true
      ..defer = true
      ..src =
          'https://oapi.map.naver.com/openapi/v3/maps.js?ncpKeyId=${Uri.encodeQueryComponent(AppConfig.naverMapClientId)}';

    script.onLoad.first.then((_) => _waitForNamespace(completer));
    script.onError.first.then((_) {
      if (!completer.isCompleted) {
        completer.completeError(
          StateError('Failed to load Naver Maps JavaScript SDK'),
        );
      }
    });

    final head = html.document.head;
    if (head == null) {
      completer.completeError(StateError('Document head is unavailable'));
      return completer.future;
    }
    head.append(script);
    return completer.future;
  }

  static void _waitForNamespace(Completer<void> completer) {
    if (_hasMapsNamespace()) {
      if (!completer.isCompleted) {
        completer.complete();
      }
      return;
    }

    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_hasMapsNamespace()) {
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

  static bool _hasMapsNamespace() {
    if (!js.context.hasProperty('naver')) {
      return false;
    }
    final naver = js.context['naver'];
    return naver is js.JsObject && naver.hasProperty('maps');
  }
}
