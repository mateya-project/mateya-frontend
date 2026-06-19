import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum MateyaPermissionRecoveryAction { retry, openSettings, cancel }

Future<bool> showMateyaPermissionNoticeDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = '계속',
  String cancelLabel = '나중에',
  String? rememberKey,
}) async {
  if (rememberKey != null) {
    final preferences = await SharedPreferences.getInstance();
    final alreadyAccepted = preferences.getBool(rememberKey) ?? false;
    if (alreadyAccepted) {
      return true;
    }
  }
  if (!context.mounted) {
    return false;
  }

  final shouldContinue = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelLabel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      );
    },
  );

  final accepted = shouldContinue ?? false;
  if (accepted && rememberKey != null) {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(rememberKey, true);
  }

  return accepted;
}

Future<void> showMateyaAppSettingsDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = '앱 설정 열기',
  String cancelLabel = '나중에',
}) async {
  final shouldOpenSettings = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelLabel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      );
    },
  );

  if (shouldOpenSettings == true) {
    await Geolocator.openAppSettings();
  }
}

Future<void> showMateyaLocationSettingsDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = '위치 설정 열기',
  String cancelLabel = '나중에',
}) async {
  final shouldOpenSettings = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelLabel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      );
    },
  );

  if (shouldOpenSettings == true) {
    await Geolocator.openLocationSettings();
  }
}

Future<MateyaPermissionRecoveryAction> showMateyaPermissionRecoveryDialog(
  BuildContext context, {
  required String title,
  required String message,
  String retryLabel = '다시 시도',
  String settingsLabel = '앱 설정 열기',
  String cancelLabel = '취소',
}) async {
  final action = await showDialog<MateyaPermissionRecoveryAction>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(
              context,
            ).pop(MateyaPermissionRecoveryAction.cancel),
            child: Text(cancelLabel),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(MateyaPermissionRecoveryAction.retry),
            child: Text(retryLabel),
          ),
          TextButton(
            onPressed: () => Navigator.of(
              context,
            ).pop(MateyaPermissionRecoveryAction.openSettings),
            child: Text(settingsLabel),
          ),
        ],
      );
    },
  );

  if (action == MateyaPermissionRecoveryAction.openSettings) {
    await Geolocator.openAppSettings();
  }

  return action ?? MateyaPermissionRecoveryAction.cancel;
}
