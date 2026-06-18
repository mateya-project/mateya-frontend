part of 'create_controller.dart';

CreateSubmissionDraft? _buildDraftFor(CreateController controller) {
  final eventDate = controller._eventDate;
  final startTime = controller._startTime;
  final endTime = controller._endTime;
  final selectedPlace =
      controller._selectedPlace ?? _buildManualPlaceFor(controller);
  if (eventDate == null ||
      startTime == null ||
      endTime == null ||
      selectedPlace == null) {
    return null;
  }

  return CreateSubmissionDraft(
    flowType: controller.flowType,
    categoryIds: Set<String>.from(controller._selectedCategoryIds),
    place: selectedPlace,
    title: controller._title.trim(),
    description: controller._description.trim(),
    eventDate: eventDate,
    startTime: startTime,
    endTime: endTime,
    participantCapacity: controller._participantCapacity,
    registrationDeadlineDate: controller._deadlineDate,
    registrationDeadlineTime: controller._deadlineTime,
    languageCodes: Set<String>.from(controller._languageCodes),
    priceType: controller._priceType,
    price: _parsedPriceFor(controller),
    audienceIds: Set<String>.from(controller._audienceIds),
    images: controller._images,
  );
}

Map<String, String?> _validateStepFor(
  CreateController controller,
  CreateStep targetStep,
) {
  return switch (targetStep) {
    CreateStep.category => _validateCategoryStepFor(controller),
    CreateStep.place => _validatePlaceStepFor(controller),
    CreateStep.details => _validateDetailStepFor(controller),
    CreateStep.completed => <String, String?>{},
  };
}

Map<String, String?> _validateCategoryStepFor(CreateController controller) {
  if (controller.flowType == CreateFlowType.classRegistration) {
    return <String, String?>{};
  }
  if (controller._selectedCategoryIds.isNotEmpty) {
    return <String, String?>{};
  }
  return <String, String?>{'categories': '카테고리를 1개 선택해 주세요.'};
}

Map<String, String?> _validatePlaceStepFor(CreateController controller) {
  if (controller._selectedPlace != null) {
    return <String, String?>{};
  }
  if (controller.flowType == CreateFlowType.classRegistration &&
      controller._manualPlaceName.trim().isNotEmpty &&
      controller._manualPlaceAddress.trim().isNotEmpty) {
    if (controller.selectedCategoryId == null) {
      return <String, String?>{'categories': '클래스 카테고리를 먼저 선택해 주세요.'};
    }
    return <String, String?>{};
  }
  return <String, String?>{
    'place': controller.flowType == CreateFlowType.classRegistration
        ? '장소를 선택하거나 장소명과 주소를 입력해 주세요.'
        : '장소를 1개 선택해 주세요.',
  };
}

Map<String, String?> _validateDetailStepFor(CreateController controller) {
  final errors = <String, String?>{};
  final now = controller._now();
  final normalizedToday = DateTime(now.year, now.month, now.day);
  final title = controller._title.trim();
  final description = controller._description.trim();

  if (title.isEmpty) {
    errors['title'] = '${controller.flowType.entityLabel} 이름을 입력해 주세요.';
  } else if (title.length > 100) {
    errors['title'] = '제목은 100자 이하여야 해요.';
  }

  if (description.length > 3000) {
    errors['description'] = '소개는 3000자 이하여야 해요.';
  }

  if (controller._eventDate == null) {
    errors['eventDate'] = '날짜를 선택해 주세요.';
  } else if (controller._eventDate!.isBefore(normalizedToday)) {
    errors['eventDate'] = '과거 날짜는 선택할 수 없어요.';
  }

  if (controller._startTime == null || controller._endTime == null) {
    errors['time'] = '시작 시간과 종료 시간을 모두 선택해 주세요.';
  } else if (controller._eventDate != null) {
    final startAt = _combineFor(controller._eventDate!, controller._startTime!);
    final endAt = _combineFor(controller._eventDate!, controller._endTime!);
    if (!endAt.isAfter(startAt)) {
      errors['time'] = '종료 시간은 시작 시간보다 늦어야 해요.';
    }
  }

  if (controller._participantCapacity < 2 ||
      controller._participantCapacity > 20) {
    errors['participantCapacity'] = '모집 인원은 2명에서 20명 사이여야 해요.';
  }

  final hasDeadlineDate = controller._deadlineDate != null;
  final hasDeadlineTime = controller._deadlineTime != null;
  if (hasDeadlineDate != hasDeadlineTime) {
    errors['deadline'] = '모집 마감 날짜와 시간을 함께 선택해 주세요.';
  } else if (hasDeadlineDate &&
      hasDeadlineTime &&
      controller._eventDate != null) {
    final deadlineAt = _combineFor(
      controller._deadlineDate!,
      controller._deadlineTime!,
    );
    if (deadlineAt.isBefore(now)) {
      errors['deadline'] = '모집 마감 일시는 현재 시각 이후여야 해요.';
    } else {
      final startAt = controller._startTime == null
          ? null
          : _combineFor(controller._eventDate!, controller._startTime!);
      if (startAt != null && !deadlineAt.isBefore(startAt)) {
        errors['deadline'] = '모집 마감 일시는 시작 시간보다 앞서야 해요.';
      }
    }
  }

  if (controller._languageCodes.isEmpty) {
    errors['languages'] = '진행 언어를 1개 이상 선택해 주세요.';
  }

  if (controller._priceType == null) {
    errors['priceType'] = '비용 유형을 선택해 주세요.';
  } else if (controller._priceType == CreatePriceType.paid) {
    final price = _parsedPriceFor(controller);
    if (price == null) {
      errors['price'] = '유료 금액을 입력해 주세요.';
    } else if (price < 0 || price > 200000) {
      errors['price'] = '유료 금액은 0원 이상 200,000원 이하로 입력해 주세요.';
    }
  }

  if (controller.flowType == CreateFlowType.group &&
      controller._images.isEmpty) {
    errors['images'] = '대표 이미지를 1장 이상 등록해 주세요.';
  }

  return errors;
}

int? _parsedPriceFor(CreateController controller) {
  final digits = controller._priceText.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.isEmpty) {
    return null;
  }
  return int.tryParse(digits);
}

DateTime _combineFor(DateTime date, TimeOfDay time) {
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}

CreatePlaceSuggestion? _buildManualPlaceFor(CreateController controller) {
  if (controller.flowType != CreateFlowType.classRegistration) {
    return null;
  }
  final name = controller._manualPlaceName.trim();
  final address = controller._manualPlaceAddress.trim();
  if (name.isEmpty || address.isEmpty) {
    return null;
  }
  return CreatePlaceSuggestion(
    id: 'manual-class-place',
    name: name,
    address: address,
    description: '직접 입력한 클래스 장소',
    distanceKm: 0,
    categoryIds: controller.selectedCategoryId == null
        ? const <String>{}
        : <String>{controller.selectedCategoryId!},
    serverCategoryCode: controller.selectedCategoryId,
    categoryDetailCode: controller._selectedCategoryDetailCode,
    categoryDetailName: controller.availableCategoryDetails
        .where((item) => item.code == controller._selectedCategoryDetailCode)
        .firstOrNull
        ?.label,
  );
}
