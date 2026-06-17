import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

import 'package:mateya_app/shared/media/image_picker_lost_data.dart';

void main() {
  group('recoverLostImagePickerData', () {
    test('returns empty result when response is empty', () async {
      final result = await recoverLostImagePickerData(
        () async => LostDataResponse.empty(),
        fallbackErrorMessage: 'fallback',
      );

      expect(result.isEmpty, isTrue);
      expect(result.files, isEmpty);
      expect(result.errorMessage, isNull);
    });

    test('returns multiple recovered files when files are present', () async {
      final files = <XFile>[
        XFile('/tmp/one.jpg', name: 'one.jpg'),
        XFile('/tmp/two.jpg', name: 'two.jpg'),
      ];

      final result = await recoverLostImagePickerData(
        () async => LostDataResponse(files: files),
        fallbackErrorMessage: 'fallback',
      );

      expect(result.files.map((file) => file.name), <String>[
        'one.jpg',
        'two.jpg',
      ]);
      expect(result.errorMessage, isNull);
    });

    test('falls back to single file when file is present', () async {
      final result = await recoverLostImagePickerData(
        () async => LostDataResponse(
          file: XFile('/tmp/camera.jpg', name: 'camera.jpg'),
        ),
        fallbackErrorMessage: 'fallback',
      );

      expect(result.files.map((file) => file.name), <String>['camera.jpg']);
      expect(result.errorMessage, isNull);
    });

    test('returns exception message when response contains an error', () async {
      final result = await recoverLostImagePickerData(
        () async => LostDataResponse(
          exception: PlatformException(
            code: 'picker',
            message: 'picker failed',
          ),
        ),
        fallbackErrorMessage: 'fallback',
      );

      expect(result.files, isEmpty);
      expect(result.errorMessage, 'picker failed');
    });

    test('returns fallback message when reader throws', () async {
      final result = await recoverLostImagePickerData(
        () async => throw PlatformException(code: 'oops'),
        fallbackErrorMessage: 'fallback',
      );

      expect(result.files, isEmpty);
      expect(result.errorMessage, 'fallback');
    });
  });
}
