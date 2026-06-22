import 'package:flutter/services.dart';

const MethodChannel _externalUrlChannel = MethodChannel(
  'com.zless.mateya/external_url',
);

Future<bool> openExternalUrl(String url) async {
  try {
    final opened = await _externalUrlChannel.invokeMethod<bool>('openUrl', url);
    return opened ?? false;
  } on MissingPluginException {
    return false;
  } on PlatformException {
    return false;
  }
}
