import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../localization/mateya_localizations.dart';
import '../permissions/mateya_permission_dialogs.dart';
import 'image_picker_lost_data.dart';

class MateyaGalleryPickerMessages {
  const MateyaGalleryPickerMessages({
    required this.noticeMessage,
    required this.recoveryMessage,
    required this.failureMessage,
    required this.restoreFallbackErrorMessage,
    required this.restoredCountMessage,
  });

  final String noticeMessage;
  final String recoveryMessage;
  final String failureMessage;
  final String restoreFallbackErrorMessage;
  final String Function(int restoredCount) restoredCountMessage;
}

Future<void> restoreLostMateyaGalleryImages({
  required BuildContext context,
  required LostImagePickerDataReader readLostData,
  required int availableSlots,
  required MateyaGalleryPickerMessages messages,
  required Future<void> Function(List<XFile> files) onRestored,
  bool suppressErrorMessage = false,
}) async {
  if (availableSlots <= 0) {
    return;
  }

  final recovery = await recoverLostImagePickerData(
    readLostData,
    fallbackErrorMessage: messages.restoreFallbackErrorMessage,
  );
  if (!context.mounted || recovery.isEmpty) {
    return;
  }

  final messenger = ScaffoldMessenger.maybeOf(context);
  if (recovery.errorMessage != null) {
    if (!suppressErrorMessage && messenger != null) {
      messenger.showSnackBar(SnackBar(content: Text(recovery.errorMessage!)));
    }
    return;
  }

  final restored = recovery.files.take(availableSlots).toList(growable: false);
  if (restored.isEmpty) {
    return;
  }

  await onRestored(restored);
  if (!context.mounted || messenger == null) {
    return;
  }

  messenger.showSnackBar(
    SnackBar(content: Text(messages.restoredCountMessage(restored.length))),
  );
}

Future<List<XFile>> pickMateyaGalleryImages(
  BuildContext context, {
  required ImagePicker imagePicker,
  required int availableSlots,
  required MateyaGalleryPickerMessages messages,
  Future<bool> Function()? confirmPermissionRequest,
  int imageQuality = 88,
  double? maxWidth,
}) async {
  if (availableSlots <= 0) {
    return const <XFile>[];
  }

  if (confirmPermissionRequest != null) {
    final shouldProceed = await confirmPermissionRequest();
    if (!shouldProceed || !context.mounted) {
      return const <XFile>[];
    }
  }

  final l10n = context.l10n;
  try {
    final picked = await imagePicker.pickMultiImage(
      imageQuality: imageQuality,
      maxWidth: maxWidth,
    );
    if (!context.mounted || picked.isEmpty) {
      return const <XFile>[];
    }
    return picked.take(availableSlots).toList(growable: false);
  } on PlatformException catch (error) {
    if (!context.mounted) {
      return const <XFile>[];
    }
    if (error.code == 'photo_access_denied') {
      final action = await showMateyaPermissionRecoveryDialog(
        context,
        title: l10n.galleryPermissionRecoveryTitle,
        message: messages.recoveryMessage,
        retryLabel: l10n.commonRetry,
      );
      if (!context.mounted) {
        return const <XFile>[];
      }
      if (action == MateyaPermissionRecoveryAction.retry) {
        return pickMateyaGalleryImages(
          context,
          imagePicker: imagePicker,
          availableSlots: availableSlots,
          messages: messages,
          imageQuality: imageQuality,
          maxWidth: maxWidth,
        );
      }
    }
  } catch (_) {
    if (!context.mounted) {
      return const <XFile>[];
    }
  }

  final messenger = ScaffoldMessenger.maybeOf(context);
  messenger?.showSnackBar(SnackBar(content: Text(messages.failureMessage)));
  return const <XFile>[];
}

Future<XFile?> pickMateyaGalleryImage(
  BuildContext context, {
  required ImagePicker imagePicker,
  required MateyaGalleryPickerMessages messages,
  Future<bool> Function()? confirmPermissionRequest,
  int imageQuality = 88,
  double? maxWidth,
}) async {
  final picked = await pickMateyaGalleryImages(
    context,
    imagePicker: imagePicker,
    availableSlots: 1,
    messages: messages,
    confirmPermissionRequest: confirmPermissionRequest,
    imageQuality: imageQuality,
    maxWidth: maxWidth,
  );
  if (picked.isEmpty) {
    return null;
  }
  return picked.first;
}
