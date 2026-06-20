import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../localization/mateya_localizations.dart';

enum MateyaPermissionRecoveryAction { retry, openSettings, cancel }

Future<bool> showMateyaPermissionNoticeDialog(
  BuildContext context, {
  required String title,
  required String message,
  String? confirmLabel,
  String? cancelLabel,
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
      final l10n = context.l10n;
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelLabel ?? l10n.commonLater),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmLabel ?? l10n.commonContinue),
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
  String? confirmLabel,
  String? cancelLabel,
}) async {
  final shouldOpenSettings = await showDialog<bool>(
    context: context,
    builder: (context) {
      final l10n = context.l10n;
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelLabel ?? l10n.commonLater),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmLabel ?? l10n.permissionOpenAppSettings),
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
  String? confirmLabel,
  String? cancelLabel,
}) async {
  final shouldOpenSettings = await showDialog<bool>(
    context: context,
    builder: (context) {
      final l10n = context.l10n;
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelLabel ?? l10n.commonLater),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmLabel ?? l10n.permissionOpenLocationSettings),
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
  String? retryLabel,
  String? settingsLabel,
  String? cancelLabel,
}) async {
  final action = await showDialog<MateyaPermissionRecoveryAction>(
    context: context,
    builder: (context) {
      final l10n = context.l10n;
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(
              context,
            ).pop(MateyaPermissionRecoveryAction.cancel),
            child: Text(cancelLabel ?? l10n.commonCancel),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(MateyaPermissionRecoveryAction.retry),
            child: Text(retryLabel ?? l10n.commonRetry),
          ),
          TextButton(
            onPressed: () => Navigator.of(
              context,
            ).pop(MateyaPermissionRecoveryAction.openSettings),
            child: Text(settingsLabel ?? l10n.permissionOpenAppSettings),
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
