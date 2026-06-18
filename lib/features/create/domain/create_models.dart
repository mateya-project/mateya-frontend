import 'package:flutter/material.dart';

enum CreateFlowType { group, classRegistration }

enum CreateStep { category, place, details, completed }

enum CreatePriceType { free, paid }

enum ChatProvisionStatus { created, failed }

class CreateCategoryOption {
  const CreateCategoryOption({required this.id, required this.label});

  final String id;
  final String label;
}

class CreateCategoryDetailOption {
  const CreateCategoryDetailOption({required this.code, required this.label});

  final String code;
  final String label;
}

class CreateLanguageOption {
  const CreateLanguageOption({required this.code, required this.label});

  final String code;
  final String label;
}

class CreateAudienceOption {
  const CreateAudienceOption({required this.id, required this.label});

  final String id;
  final String label;
}

class CreatePlaceSuggestion {
  const CreatePlaceSuggestion({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.distanceKm,
    this.latitude,
    this.longitude,
    this.categoryIds = const <String>{},
    this.serverCategoryCode,
    this.categoryDetailCode,
    this.categoryDetailName,
  });

  final String id;
  final String name;
  final String address;
  final String description;
  final int distanceKm;
  final double? latitude;
  final double? longitude;
  final Set<String> categoryIds;
  final String? serverCategoryCode;
  final String? categoryDetailCode;
  final String? categoryDetailName;

  bool get hasCoordinates => latitude != null && longitude != null;
}

class CreateImageAsset {
  const CreateImageAsset({
    required this.id,
    required this.path,
    required this.name,
    required this.sizeBytes,
    this.isPrimary = false,
  });

  final String id;
  final String path;
  final String name;
  final int sizeBytes;
  final bool isPrimary;

  bool get isRemote =>
      path.startsWith('http://') || path.startsWith('https://');

  CreateImageAsset copyWith({
    String? id,
    String? path,
    String? name,
    int? sizeBytes,
    bool? isPrimary,
  }) {
    return CreateImageAsset(
      id: id ?? this.id,
      path: path ?? this.path,
      name: name ?? this.name,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      isPrimary: isPrimary ?? this.isPrimary,
    );
  }
}

class CreateEditableDraft {
  const CreateEditableDraft({
    required this.activityId,
    required this.flowType,
    required this.categoryIds,
    required this.place,
    required this.title,
    required this.description,
    required this.eventDate,
    required this.startTime,
    required this.endTime,
    required this.participantCapacity,
    required this.languageCodes,
    required this.priceType,
    required this.priceText,
    required this.audienceIds,
    required this.images,
    this.registrationDeadlineDate,
    this.registrationDeadlineTime,
    this.categoryDetailCode,
  });

  final String activityId;
  final CreateFlowType flowType;
  final Set<String> categoryIds;
  final CreatePlaceSuggestion place;
  final String title;
  final String description;
  final DateTime eventDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final int participantCapacity;
  final DateTime? registrationDeadlineDate;
  final TimeOfDay? registrationDeadlineTime;
  final Set<String> languageCodes;
  final CreatePriceType priceType;
  final String priceText;
  final Set<String> audienceIds;
  final List<CreateImageAsset> images;
  final String? categoryDetailCode;
}

class CreateSubmissionDraft {
  const CreateSubmissionDraft({
    required this.flowType,
    required this.categoryIds,
    required this.place,
    required this.title,
    required this.description,
    required this.eventDate,
    required this.startTime,
    required this.endTime,
    required this.participantCapacity,
    required this.languageCodes,
    required this.audienceIds,
    required this.images,
    this.registrationDeadlineDate,
    this.registrationDeadlineTime,
    this.priceType,
    this.price,
  });

  final CreateFlowType flowType;
  final Set<String> categoryIds;
  final CreatePlaceSuggestion place;
  final String title;
  final String description;
  final DateTime eventDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final int participantCapacity;
  final DateTime? registrationDeadlineDate;
  final TimeOfDay? registrationDeadlineTime;
  final Set<String> languageCodes;
  final CreatePriceType? priceType;
  final int? price;
  final Set<String> audienceIds;
  final List<CreateImageAsset> images;

  DateTime get eventStartsAt => DateTime(
    eventDate.year,
    eventDate.month,
    eventDate.day,
    startTime.hour,
    startTime.minute,
  );

  DateTime get eventEndsAt => DateTime(
    eventDate.year,
    eventDate.month,
    eventDate.day,
    endTime.hour,
    endTime.minute,
  );

  DateTime? get registrationDeadlineAt {
    final date = registrationDeadlineDate;
    final time = registrationDeadlineTime;
    if (date == null || time == null) {
      return null;
    }
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}

class CreateSubmitResult {
  const CreateSubmitResult({
    required this.id,
    required this.flowType,
    required this.title,
    required this.placeName,
    required this.eventStartsAt,
    required this.chatStatus,
  });

  final String id;
  final CreateFlowType flowType;
  final String title;
  final String placeName;
  final DateTime eventStartsAt;
  final ChatProvisionStatus chatStatus;
}

abstract final class CreateFormOptions {
  static const List<CreateLanguageOption> languages = <CreateLanguageOption>[
    CreateLanguageOption(code: 'ko', label: '한국어'),
    CreateLanguageOption(code: 'en', label: '영어'),
    CreateLanguageOption(code: 'ja', label: '일본어'),
    CreateLanguageOption(code: 'zh', label: '중국어'),
  ];

  static const List<CreateAudienceOption> audiences = <CreateAudienceOption>[
    CreateAudienceOption(id: 'everyone', label: '누구나'),
    CreateAudienceOption(id: 'foreigner', label: '외국인 환영'),
    CreateAudienceOption(id: 'korean', label: '한국인 환영'),
    CreateAudienceOption(id: 'tourist', label: '관광객 추천'),
    CreateAudienceOption(id: 'beginner', label: '초보자 환영'),
  ];
}

extension CreateFlowTypeX on CreateFlowType {
  String get label => switch (this) {
    CreateFlowType.group => '모임 생성',
    CreateFlowType.classRegistration => '클래스 등록',
  };

  String get entityLabel => switch (this) {
    CreateFlowType.group => '모임',
    CreateFlowType.classRegistration => '클래스',
  };

  String get submitLabel => switch (this) {
    CreateFlowType.group => '모임 생성하기',
    CreateFlowType.classRegistration => '클래스 등록하기',
  };

  String get editLabel => switch (this) {
    CreateFlowType.group => '모임 수정',
    CreateFlowType.classRegistration => '클래스 수정',
  };

  String get updateSubmitLabel => switch (this) {
    CreateFlowType.group => '모임 수정하기',
    CreateFlowType.classRegistration => '클래스 수정하기',
  };
}

extension CreatePriceTypeX on CreatePriceType {
  String get label => switch (this) {
    CreatePriceType.free => '무료',
    CreatePriceType.paid => '유료',
  };
}
