import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

typedef LostImagePickerDataReader = Future<LostDataResponse> Function();

class RecoveredImagePickerData {
  const RecoveredImagePickerData({
    this.files = const <XFile>[],
    this.errorMessage,
  });

  final List<XFile> files;
  final String? errorMessage;

  bool get isEmpty => files.isEmpty && errorMessage == null;
}

Future<RecoveredImagePickerData> recoverLostImagePickerData(
  LostImagePickerDataReader readLostData, {
  required String fallbackErrorMessage,
}) async {
  try {
    final response = await readLostData();
    if (response.isEmpty) {
      return const RecoveredImagePickerData();
    }

    final files = response.files;
    if (files != null && files.isNotEmpty) {
      return RecoveredImagePickerData(files: files);
    }
    if (response.file != null) {
      return RecoveredImagePickerData(files: <XFile>[response.file!]);
    }

    return RecoveredImagePickerData(
      errorMessage: _resolveErrorMessage(
        response.exception?.message,
        fallbackErrorMessage,
      ),
    );
  } on PlatformException catch (error) {
    return RecoveredImagePickerData(
      errorMessage: _resolveErrorMessage(error.message, fallbackErrorMessage),
    );
  } catch (_) {
    return RecoveredImagePickerData(errorMessage: fallbackErrorMessage);
  }
}

String _resolveErrorMessage(String? message, String fallbackErrorMessage) {
  if (message == null || message.trim().isEmpty) {
    return fallbackErrorMessage;
  }
  return message;
}
