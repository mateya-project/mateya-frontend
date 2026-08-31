class AiConversationSeed {
  const AiConversationSeed({
    this.entryPoint = 'HOME',
    this.anchorPlaceId,
    this.anchorPlaceName,
    this.visitDate,
    this.radiusKm = 10,
    this.interests = const <String>[],
  });

  final String entryPoint;
  final String? anchorPlaceId;
  final String? anchorPlaceName;
  final DateTime? visitDate;
  final double radiusKm;
  final List<String> interests;
}

class AiConversationSummary {
  const AiConversationSummary({
    required this.id,
    required this.title,
    required this.updatedAt,
    required this.radiusKm,
    this.anchorPlaceId,
    this.anchorPlaceName,
    this.visitDate,
    this.lastMessagePreview,
    this.interests = const <String>[],
    this.dispersalPreference = 'BALANCED',
  });

  final String id;
  final String title;
  final String? anchorPlaceId;
  final String? anchorPlaceName;
  final DateTime? visitDate;
  final double radiusKm;
  final List<String> interests;
  final String dispersalPreference;
  final String? lastMessagePreview;
  final DateTime updatedAt;
}

class AiConversation {
  const AiConversation({
    required this.id,
    required this.title,
    required this.updatedAt,
    required this.radiusKm,
    required this.messages,
    this.anchorPlaceId,
    this.anchorPlaceName,
    this.visitDate,
    this.interests = const <String>[],
    this.dispersalPreference = 'BALANCED',
    this.lastRunId,
  });

  final String id;
  final String title;
  final String? anchorPlaceId;
  final String? anchorPlaceName;
  final DateTime? visitDate;
  final double radiusKm;
  final List<String> interests;
  final String dispersalPreference;
  final String? lastRunId;
  final DateTime updatedAt;
  final List<AiMessage> messages;
}

class AiMessage {
  const AiMessage({
    required this.id,
    required this.role,
    required this.status,
    required this.text,
    required this.createdAt,
    this.runId,
    this.parts = const <AiMessagePart>[],
    this.attachments = const <AiMessageAttachment>[],
  });

  final String id;
  final String role;
  final String status;
  final String text;
  final String? runId;
  final DateTime createdAt;
  final List<AiMessagePart> parts;
  final List<AiMessageAttachment> attachments;

  bool get isUser => role == 'USER';
}

class AiMessageAttachment {
  const AiMessageAttachment({
    required this.imageUrl,
    this.latitude,
    this.longitude,
    this.accuracyMeters,
    this.capturedAt,
    this.locationShared = false,
  });

  final String imageUrl;
  final double? latitude;
  final double? longitude;
  final double? accuracyMeters;
  final DateTime? capturedAt;
  final bool locationShared;
}

sealed class AiMessagePart {
  const AiMessagePart(this.type);

  final String type;
}

class AiTextPart extends AiMessagePart {
  const AiTextPart(this.text) : super('TEXT');

  final String text;
}

class AiDateAlternativesPart extends AiMessagePart {
  const AiDateAlternativesPart(this.items) : super('DATE_ALTERNATIVES');

  final List<AiDateAlternative> items;
}

class AiPlaceRecommendationsPart extends AiMessagePart {
  const AiPlaceRecommendationsPart(this.items) : super('PLACE_RECOMMENDATIONS');

  final List<AiPlaceRecommendation> items;
}

class AiAnchorPlaceChoicesPart extends AiMessagePart {
  const AiAnchorPlaceChoicesPart({required this.query, required this.items})
    : super('ANCHOR_PLACE_CHOICES');

  final String query;
  final List<AiAnchorPlaceChoice> items;
}

class AiAnchorPlaceChoice {
  const AiAnchorPlaceChoice({
    required this.placeId,
    required this.name,
    this.address,
    this.regionSido,
    this.regionSigungu,
  });

  final String placeId;
  final String name;
  final String? address;
  final String? regionSido;
  final String? regionSigungu;
}

class AiQuickActionsPart extends AiMessagePart {
  const AiQuickActionsPart(this.items) : super('QUICK_ACTIONS');

  final List<AiQuickAction> items;
}

class AiNoticePart extends AiMessagePart {
  const AiNoticePart(this.text) : super('NOTICE');

  final String text;
}

class AiDateAlternative {
  const AiDateAlternative({
    required this.visitDate,
    required this.relativeConcentration,
  });

  final DateTime visitDate;
  final double relativeConcentration;
}

class AiPlaceRecommendation {
  const AiPlaceRecommendation({
    required this.placeId,
    required this.name,
    required this.score,
    required this.reason,
    required this.cta,
    this.imageUrl,
    this.scoreBreakdown,
    this.regionSido,
    this.regionSigungu,
    this.distanceKm,
    this.activityId,
  });

  final String placeId;
  final String name;
  final String? regionSido;
  final String? regionSigungu;
  final double? distanceKm;
  final String? imageUrl;
  final double score;
  final AiScoreBreakdown? scoreBreakdown;
  final String reason;
  final String cta;
  final String? activityId;
}

class AiScoreBreakdown {
  const AiScoreBreakdown({
    required this.total,
    this.userFit,
    this.feasibility,
    this.dispersalContribution,
    this.languageParticipation,
    this.dataConfidence,
  });

  final double? userFit;
  final double? feasibility;
  final double? dispersalContribution;
  final double? languageParticipation;
  final double? dataConfidence;
  final double total;
}

class AiQuickAction {
  const AiQuickAction({
    required this.id,
    required this.label,
    required this.message,
  });

  final String id;
  final String label;
  final String message;
}

class AiHomeHighlight {
  const AiHomeHighlight({
    required this.anchorPlaceId,
    required this.anchorPlaceName,
    required this.placeId,
    required this.name,
    required this.reason,
    this.category,
    this.regionSido,
    this.regionSigungu,
    this.distanceKm,
    this.imageUrl,
  });

  final String anchorPlaceId;
  final String anchorPlaceName;
  final String placeId;
  final String name;
  final String? category;
  final String? regionSido;
  final String? regionSigungu;
  final double? distanceKm;
  final String? imageUrl;
  final String reason;
}

class AiPlaceDetail {
  const AiPlaceDetail({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.category,
    this.categoryDetailName,
    this.regionSido,
    this.regionSigungu,
    this.imageUrl,
    this.thumbnailUrl,
    this.latitude,
    this.longitude,
    this.favorited = false,
  });

  final String id;
  final String name;
  final String address;
  final String description;
  final String category;
  final String? categoryDetailName;
  final String? regionSido;
  final String? regionSigungu;
  final String? imageUrl;
  final String? thumbnailUrl;
  final double? latitude;
  final double? longitude;
  final bool favorited;

  String? get previewImageUrl => imageUrl ?? thumbnailUrl;
}

class AiPlaceActivity {
  const AiPlaceActivity({
    required this.id,
    required this.title,
    required this.placeName,
    this.imageUrl,
    this.startAt,
  });

  final String id;
  final String title;
  final String placeName;
  final String? imageUrl;
  final DateTime? startAt;
}
