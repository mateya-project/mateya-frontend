part of 'create_controller.dart';

Future<void> _addImagesFor(
  CreateController controller,
  List<XFile> files,
) async {
  if (files.isEmpty) {
    return;
  }

  final availableSlots =
      CreateController.maxImageCount - controller._images.length;
  if (availableSlots <= 0) {
    controller._emitToast(
      '이미지는 최대 ${CreateController.maxImageCount}장까지 등록할 수 있어요.',
    );
    controller._notifyChanged();
    return;
  }

  final accepted = <CreateImageAsset>[];
  for (final file in files.take(availableSlots)) {
    final extension = file.name.split('.').last.toLowerCase();
    if (!CreateController.allowedExtensions.contains(extension)) {
      controller._emitToast('JPG, PNG, WEBP, GIF 형식의 이미지만 등록할 수 있어요.');
      continue;
    }

    final sizeBytes = await File(file.path).length();
    if (sizeBytes > CreateController.maxImageBytes) {
      controller._emitToast('이미지 한 장당 최대 10MB까지 등록할 수 있어요.');
      continue;
    }

    accepted.add(
      CreateImageAsset(
        id: 'image-${DateTime.now().microsecondsSinceEpoch}-${accepted.length}',
        path: file.path,
        name: file.name,
        sizeBytes: sizeBytes,
        isPrimary: controller._images.isEmpty && accepted.isEmpty,
      ),
    );
  }

  if (accepted.isEmpty) {
    controller._notifyChanged();
    return;
  }

  controller._images = <CreateImageAsset>[...controller._images, ...accepted];
  if (!controller._images.any((image) => image.isPrimary)) {
    controller._images = controller._images.indexed
        .map((entry) => entry.$2.copyWith(isPrimary: entry.$1 == 0))
        .toList(growable: false);
  }
  controller._clearErrors(<String>{'images'});
  controller._notifyChanged();
}

void _removeImageFor(CreateController controller, String imageId) {
  final next = controller._images
      .where((image) => image.id != imageId)
      .toList();
  if (next.length == controller._images.length) {
    return;
  }
  if (next.isNotEmpty && !next.any((image) => image.isPrimary)) {
    next[0] = next[0].copyWith(isPrimary: true);
  }
  controller._images = next;
  controller._clearErrors(<String>{'images'});
  controller._notifyChanged();
}

void _setPrimaryImageFor(CreateController controller, String imageId) {
  controller._images = controller._images
      .map((image) => image.copyWith(isPrimary: image.id == imageId))
      .toList(growable: false);
  controller._clearErrors(<String>{'images'});
  controller._notifyChanged();
}
