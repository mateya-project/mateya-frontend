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
  final l10n = MateyaLocalizations.current;
  if (controller.flowType == CreateFlowType.classRegistration) {
    return <String, String?>{};
  }
  if (controller._selectedCategoryIds.isNotEmpty) {
    return <String, String?>{};
  }
  return <String, String?>{'categories': l10n.createValidationSelectCategory};
}

Map<String, String?> _validatePlaceStepFor(CreateController controller) {
  final l10n = MateyaLocalizations.current;
  if (controller._selectedPlace != null) {
    return <String, String?>{};
  }
  if (controller.flowType == CreateFlowType.classRegistration &&
      controller._manualPlaceName.trim().isNotEmpty &&
      controller._manualPlaceAddress.trim().isNotEmpty) {
    if (controller.selectedCategoryId == null) {
      return <String, String?>{
        'categories': l10n.createValidationSelectClassCategoryFirst,
      };
    }
    return <String, String?>{};
  }
  return <String, String?>{
    'place': controller.flowType == CreateFlowType.classRegistration
        ? l10n.createValidationSelectPlaceOrManual
        : l10n.createValidationSelectPlace,
  };
}

Map<String, String?> _validateDetailStepFor(CreateController controller) {
  final l10n = MateyaLocalizations.current;
  final errors = <String, String?>{};
  final now = controller._now();
  final normalizedToday = DateTime(now.year, now.month, now.day);
  final title = controller._title.trim();
  final description = controller._description.trim();

  if (title.isEmpty) {
    errors['title'] = l10n.createValidationEnterEntityName(
      controller.flowType.entityLabel,
    );
  } else if (title.length > 100) {
    errors['title'] = l10n.createValidationTitleMaxLength;
  }

  if (description.length > 3000) {
    errors['description'] = l10n.createValidationDescriptionMaxLength;
  }

  if (controller._eventDate == null) {
    errors['eventDate'] = l10n.createValidationSelectDate;
  } else if (controller._eventDate!.isBefore(normalizedToday)) {
    errors['eventDate'] = l10n.createValidationNoPastDate;
  }

  if (controller._startTime == null || controller._endTime == null) {
    errors['time'] = l10n.createValidationSelectStartEndTime;
  } else if (controller._eventDate != null) {
    final startAt = _combineFor(controller._eventDate!, controller._startTime!);
    final endAt = _combineFor(controller._eventDate!, controller._endTime!);
    if (!endAt.isAfter(startAt)) {
      errors['time'] = l10n.createValidationEndAfterStart;
    }
  }

  if (controller._participantCapacity < 2 ||
      controller._participantCapacity > 20) {
    errors['participantCapacity'] = l10n.createValidationCapacityRange;
  }

  final hasDeadlineDate = controller._deadlineDate != null;
  final hasDeadlineTime = controller._deadlineTime != null;
  if (!hasDeadlineDate && !hasDeadlineTime) {
    errors['deadline'] = l10n.createValidationSelectDeadline;
  } else if (hasDeadlineDate != hasDeadlineTime) {
    errors['deadline'] = l10n.createValidationSelectDeadlineTogether;
  } else if (hasDeadlineDate &&
      hasDeadlineTime &&
      controller._eventDate != null) {
    final deadlineAt = _combineFor(
      controller._deadlineDate!,
      controller._deadlineTime!,
    );
    if (deadlineAt.isBefore(now)) {
      errors['deadline'] = l10n.createValidationDeadlineFuture;
    } else {
      final startAt = controller._startTime == null
          ? null
          : _combineFor(controller._eventDate!, controller._startTime!);
      if (startAt != null && !deadlineAt.isBefore(startAt)) {
        errors['deadline'] = l10n.createValidationDeadlineBeforeStart;
      }
    }
  }

  if (controller._languageCodes.isEmpty) {
    errors['languages'] = l10n.createValidationSelectLanguage;
  }

  if (controller._priceType == null) {
    errors['priceType'] = l10n.createValidationSelectPriceType;
  } else if (controller._priceType == CreatePriceType.paid) {
    final price = _parsedPriceFor(controller);
    if (price == null) {
      errors['price'] = l10n.createValidationEnterPaidPrice;
    } else if (price < 0 || price > 200000) {
      errors['price'] = l10n.createValidationPriceRange;
    }
  }

  if (controller.flowType == CreateFlowType.group &&
      controller._images.isEmpty) {
    errors['images'] = l10n.createValidationRegisterImage;
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
    description: MateyaLocalizations.current.createManualPlacePreviewDescription,
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
