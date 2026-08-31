import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../shared/localization/mateya_localizations.dart';
import '../../../shared/theme/app_tokens.dart';
import '../../../shared/widgets/mateya_bottom_navigation.dart';
import '../../../shared/widgets/mateya_header.dart';
import '../../onboarding/domain/onboarding_flow.dart';
import '../application/ai_conversation_controller.dart';
import '../data/ai_repository.dart';
import '../domain/ai_models.dart';
import 'ai_widgets.dart';

class AiConversationFlowPage extends StatefulWidget {
  const AiConversationFlowPage({
    super.key,
    required this.repository,
    this.seed,
    this.onPlaceTap,
    this.onCreateActivityTap,
    this.onActivityTap,
    this.onOpenNearbyMap,
    this.onHomeTap,
    this.onExploreTap,
    this.onPlusTap,
    this.onChatTap,
    this.onProfileTap,
  });

  final AiRepository repository;
  final AiConversationSeed? seed;
  final ValueChanged<String>? onPlaceTap;
  final ValueChanged<String>? onCreateActivityTap;
  final ValueChanged<String>? onActivityTap;
  final VoidCallback? onOpenNearbyMap;
  final VoidCallback? onHomeTap;
  final VoidCallback? onExploreTap;
  final VoidCallback? onPlusTap;
  final VoidCallback? onChatTap;
  final VoidCallback? onProfileTap;

  @override
  State<AiConversationFlowPage> createState() => _AiConversationFlowPageState();
}

class _AiConversationFlowPageState extends State<AiConversationFlowPage> {
  late final AiConversationController _controller;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();
  final List<XFile> _pendingImages = <XFile>[];
  bool _shareLocation = false;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _controller = AiConversationController(repository: widget.repository)
      ..addListener(_handleChanged);
    _controller.initialize(seed: widget.seed);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_handleChanged)
      ..dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleChanged() {
    if (!mounted) {
      return;
    }
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) {
        return;
      }
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _send([String? quickMessage]) async {
    final message = quickMessage ?? _messageController.text;
    if (message.trim().isEmpty && _pendingImages.isEmpty) {
      return;
    }
    setState(() => _isUploading = _pendingImages.isNotEmpty);
    try {
      Position? position;
      if (_shareLocation && _pendingImages.isNotEmpty) {
        position = await _currentPositionForAttachment();
        if (position == null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.aiLocationUnavailable)),
          );
        }
      }
      final attachments = <AiMessageAttachment>[];
      for (final image in _pendingImages) {
        final imageUrl = await widget.repository.uploadAiImage(image);
        attachments.add(
          AiMessageAttachment(
            imageUrl: imageUrl,
            latitude: position?.latitude,
            longitude: position?.longitude,
            accuracyMeters: position?.accuracy,
            capturedAt: DateTime.now(),
            locationShared: position != null,
          ),
        );
      }
      final sent = await _controller.sendMessage(
        message,
        attachments: attachments,
      );
      if (sent) {
        _messageController.clear();
        setState(() {
          _pendingImages.clear();
          _shareLocation = false;
        });
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.aiPhotoSendFailed)));
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  Future<void> _pickImages() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(context.l10n.aiGallerySelect),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(context.l10n.aiCameraTake),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source == null || !mounted) {
      return;
    }
    final available = 3 - _pendingImages.length;
    if (available <= 0) {
      return;
    }
    try {
      final picked = <XFile>[];
      if (source == ImageSource.gallery) {
        picked.addAll(
          await _imagePicker.pickMultiImage(imageQuality: 88, maxWidth: 1920),
        );
      } else {
        final image = await _imagePicker.pickImage(
          source: ImageSource.camera,
          imageQuality: 88,
          maxWidth: 1920,
        );
        if (image != null) {
          picked.add(image);
        }
      }
      if (mounted) {
        setState(() => _pendingImages.addAll(picked.take(available)));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.aiPhotoLoadFailed)));
      }
    }
  }

  Future<Position?> _currentPositionForAttachment() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return null;
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        toolbarHeight: 84,
        centerTitle: true,
        titleSpacing: 0,
        title: _controller.isRoomOpen
            ? const _AiHeaderTitle()
            : const _MateyaAiWordmark(),
        leading: IconButton(
          onPressed: _controller.isRoomOpen
              ? _controller.closeConversation
              : () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        actions: <Widget>[
          const Padding(
            padding: EdgeInsets.only(right: 4),
            child: MateyaLanguageButton(),
          ),
          if (_controller.isRoomOpen)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'archive') {
                  _controller.archiveCurrent();
                }
              },
              itemBuilder: (_) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'archive',
                  child: Text(context.l10n.aiArchiveConversation),
                ),
              ],
            ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: _controller.isRoomOpen ? _buildRoom() : _buildList(),
      ),
      bottomNavigationBar: MediaQuery.viewInsetsOf(context).bottom > 0
          ? null
          : MateyaBottomNavigation(
              currentTab: MateyaBottomTab.chat,
              onHomeTap: widget.onHomeTap ?? () => Navigator.of(context).pop(),
              onExploreTap:
                  widget.onExploreTap ?? () => Navigator.of(context).pop(),
              onPlusTap: widget.onPlusTap ?? () {},
              onChatTap: widget.onChatTap ?? () => Navigator.of(context).pop(),
              onProfileTap:
                  widget.onProfileTap ?? () => Navigator.of(context).pop(),
            ),
    );
  }

  Widget _buildList() {
    if (_controller.listPhase == AsyncPhase.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_controller.listPhase == AsyncPhase.serverError) {
      return _AiRetry(
        message: _controller.errorMessage ?? '목록을 불러오지 못했어요.',
        onRetry: _controller.loadConversations,
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      children: <Widget>[
        _AiStartCard(onStart: _controller.startConversation),
        if (_controller.conversations.isNotEmpty) ...<Widget>[
          const SizedBox(height: 28),
          Text(
            context.l10n.aiContinueTitle,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          for (final item in _controller.conversations) ...<Widget>[
            _AiConversationTile(
              item: item,
              onTap: () => _controller.openConversation(item.id),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ],
    );
  }

  Widget _buildRoom() {
    final conversation = _controller.current;
    if (conversation == null || _controller.roomPhase == AsyncPhase.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: <Widget>[
        _ConditionStrip(conversation: conversation),
        Expanded(
          child: ListView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: <Widget>[
              if (conversation.messages.isEmpty) const _AiWelcomeMessage(),
              for (final message in conversation.messages) ...<Widget>[
                _MessageBubble(
                  message: message,
                  onQuickAction: _handleQuickAction,
                  onPlaceTap: _openPlace,
                  onCreateTap: _openCreate,
                  onActivityTap: _openActivity,
                ),
                const SizedBox(height: 14),
              ],
              if (_controller.isSending || _isUploading)
                _TypingIndicator(
                  message: _isUploading
                      ? context.l10n.aiUploadingPhoto
                      : _controller.progressMessage ??
                            context.l10n.aiCheckingData,
                ),
              if (_controller.errorMessage != null) ...<Widget>[
                const SizedBox(height: 10),
                Text(
                  _controller.errorMessage!,
                  style: const TextStyle(color: AppColors.error),
                ),
              ],
            ],
          ),
        ),
        _Composer(
          controller: _messageController,
          enabled: !_controller.isSending && !_isUploading,
          pendingImages: _pendingImages,
          shareLocation: _shareLocation,
          onAttach: _pickImages,
          onRemoveImage: (index) =>
              setState(() => _pendingImages.removeAt(index)),
          onShareLocationChanged: (value) =>
              setState(() => _shareLocation = value),
          onSend: _send,
        ),
      ],
    );
  }

  void _openPlace(String placeId) {
    widget.repository.recordEvent(
      eventType: 'PLACE_VIEW',
      conversationId: _controller.current?.id,
      runId: _controller.current?.lastRunId,
      anchorPlaceId: _controller.current?.anchorPlaceId,
      recommendedPlaceId: placeId,
    );
    widget.onPlaceTap?.call(placeId);
  }

  void _openCreate(String placeId) {
    widget.repository.recordEvent(
      eventType: 'ACTIVITY_CREATE',
      conversationId: _controller.current?.id,
      runId: _controller.current?.lastRunId,
      anchorPlaceId: _controller.current?.anchorPlaceId,
      recommendedPlaceId: placeId,
    );
    widget.onCreateActivityTap?.call(placeId);
  }

  void _openActivity(String activityId) {
    widget.repository.recordEvent(
      eventType: 'ACTIVITY_VIEW',
      conversationId: _controller.current?.id,
      runId: _controller.current?.lastRunId,
      anchorPlaceId: _controller.current?.anchorPlaceId,
      activityId: activityId,
    );
    widget.onActivityTap?.call(activityId);
  }

  void _handleQuickAction(AiQuickAction action) {
    if (action.id == 'OPEN_NEARBY_MAP' && widget.onOpenNearbyMap != null) {
      widget.onOpenNearbyMap!();
      return;
    }
    _send(action.message);
  }
}

class _AiHeaderTitle extends StatelessWidget {
  const _AiHeaderTitle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      // The text makes this lockup visually right-heavy even when AppBar
      // centers its bounds. Add optical space on the right to center the mark.
      padding: const EdgeInsets.only(right: 16),
      child: Row(
        key: const ValueKey<String>('ai-room-header-lockup'),
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const AiRobotAvatar(size: 38),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'MateYa AI',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                Text(
                  context.l10n.aiGuideSubtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MateyaAiWordmark extends StatelessWidget {
  const _MateyaAiWordmark();

  @override
  Widget build(BuildContext context) {
    return const Text.rich(
      TextSpan(
        children: <InlineSpan>[
          TextSpan(
            text: 'Mate',
            style: TextStyle(color: Colors.black),
          ),
          TextSpan(
            text: 'Ya',
            style: TextStyle(color: AppColors.brandGreen),
          ),
        ],
      ),
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
    );
  }
}

class _AiStartCard extends StatelessWidget {
  const _AiStartCard({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AiColors.purple50,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AiColors.purple200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const AiRobotAvatar(size: 58),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  context.l10n.aiStartHeadline,
                  style: const TextStyle(
                    height: 1.45,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          AiPrimaryButton(
            label: context.l10n.aiNewTravelPlan,
            onPressed: onStart,
          ),
        ],
      ),
    );
  }
}

class _AiConversationTile extends StatelessWidget {
  const _AiConversationTile({required this.item, required this.onTap});

  final AiConversationSummary item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: <Widget>[
            const AiRobotAvatar(size: 46),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.lastMessagePreview ??
                        context.l10n.aiContinueConditions,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}

class _ConditionStrip extends StatelessWidget {
  const _ConditionStrip({required this.conversation});

  final AiConversation conversation;

  @override
  Widget build(BuildContext context) {
    final chips = <String>[
      if (conversation.anchorPlaceName != null) conversation.anchorPlaceName!,
      if (conversation.visitDate != null) _dateLabel(conversation.visitDate!),
      '${conversation.radiusKm.toStringAsFixed(0)}km',
      ...conversation.interests,
    ];
    return Container(
      height: 52,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
        itemCount: chips.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, index) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: AiColors.purple50,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AiColors.purple200),
          ),
          child: Text(
            chips[index],
            style: const TextStyle(
              color: AiColors.purple800,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _AiWelcomeMessage extends StatelessWidget {
  const _AiWelcomeMessage();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const AiRobotAvatar(size: 40),
          const SizedBox(width: 10),
          Expanded(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: AiColors.purple50,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  context.l10n.aiWelcome,
                  style: const TextStyle(height: 1.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.onQuickAction,
    required this.onPlaceTap,
    required this.onCreateTap,
    required this.onActivityTap,
  });

  final AiMessage message;
  final ValueChanged<AiQuickAction> onQuickAction;
  final ValueChanged<String> onPlaceTap;
  final ValueChanged<String> onCreateTap;
  final ValueChanged<String> onActivityTap;

  @override
  Widget build(BuildContext context) {
    if (message.isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 280),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.brandGreen,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              if (message.attachments.isNotEmpty) ...<Widget>[
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: message.attachments
                      .map(
                        (attachment) => ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            attachment.imageUrl,
                            width: 92,
                            height: 92,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const SizedBox(
                              width: 92,
                              height: 92,
                              child: ColoredBox(
                                color: AiColors.purple100,
                                child: Icon(Icons.broken_image_outlined),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                if (message.attachments.any(
                  (item) => item.locationShared,
                )) ...<Widget>[
                  const SizedBox(height: 6),
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Colors.white,
                      ),
                      SizedBox(width: 3),
                      Text(
                        '위치 포함',
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 8),
              ],
              Text(message.text, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const AiRobotAvatar(size: 38),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AiColors.purple50,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(message.text, style: const TextStyle(height: 1.5)),
              ),
              for (final part in message.parts) ...<Widget>[
                const SizedBox(height: 10),
                _PartView(
                  part: part,
                  onQuickAction: onQuickAction,
                  onPlaceTap: onPlaceTap,
                  onCreateTap: onCreateTap,
                  onActivityTap: onActivityTap,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _PartView extends StatelessWidget {
  const _PartView({
    required this.part,
    required this.onQuickAction,
    required this.onPlaceTap,
    required this.onCreateTap,
    required this.onActivityTap,
  });

  final AiMessagePart part;
  final ValueChanged<AiQuickAction> onQuickAction;
  final ValueChanged<String> onPlaceTap;
  final ValueChanged<String> onCreateTap;
  final ValueChanged<String> onActivityTap;

  @override
  Widget build(BuildContext context) {
    return switch (part) {
      AiTextPart() => const SizedBox.shrink(),
      AiNoticePart(:final text) => AiEvidenceNotice(text: text),
      AiDateAlternativesPart(:final items) => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: items
            .map(
              (item) => ActionChip(
                backgroundColor: Colors.white,
                side: const BorderSide(color: AiColors.purple300),
                label: Text(
                  '${_dateLabel(item.visitDate)} · ${(item.relativeConcentration * 100).round()}%',
                ),
                onPressed: () => onQuickAction(
                  AiQuickAction(
                    id: 'DATE_${item.visitDate.toIso8601String()}',
                    label: _dateLabel(item.visitDate),
                    message: _isoDate(item.visitDate),
                  ),
                ),
              ),
            )
            .toList(),
      ),
      AiQuickActionsPart(:final items) => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: items
            .map(
              (item) => ActionChip(
                backgroundColor: Colors.white,
                side: const BorderSide(color: AiColors.purple300),
                label: Text(item.label),
                onPressed: () => onQuickAction(item),
              ),
            )
            .toList(),
      ),
      AiPlaceRecommendationsPart(:final items) => Column(
        children: items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _RecommendationCard(
                  item: item,
                  onPlaceTap: () => onPlaceTap(item.placeId),
                  onCreateTap: () => onCreateTap(item.placeId),
                  onActivityTap: item.activityId == null
                      ? null
                      : () => onActivityTap(item.activityId!),
                ),
              ),
            )
            .toList(),
      ),
      AiAnchorPlaceChoicesPart(:final query, :final items) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            context.l10n.aiPlaceSearchResult(query),
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Semantics(
                button: true,
                label: context.l10n.aiSelectAnchor(item.name),
                child: ListTile(
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: AiColors.purple200),
                  ),
                  title: Text(
                    item.name,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text(
                    item.address ??
                        <String>[
                          if (item.regionSido != null) item.regionSido!,
                          if (item.regionSigungu != null) item.regionSigungu!,
                        ].join(' '),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => onQuickAction(
                    AiQuickAction(
                      id: 'ANCHOR_${item.placeId}',
                      label: item.name,
                      message: '[PLACE_ID:${item.placeId}:${item.name}]',
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    };
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({
    required this.item,
    required this.onPlaceTap,
    required this.onCreateTap,
    required this.onActivityTap,
  });

  final AiPlaceRecommendation item;
  final VoidCallback onPlaceTap;
  final VoidCallback onCreateTap;
  final VoidCallback? onActivityTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AiColors.purple200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AiColors.purple100,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  context.l10n.aiScore(item.score.round()),
                  style: const TextStyle(
                    color: AiColors.purple800,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            <String>[
              if (item.regionSido != null) item.regionSido!,
              if (item.regionSigungu != null) item.regionSigungu!,
              if (item.distanceKm != null)
                '${item.distanceKm!.toStringAsFixed(1)}km',
            ].join(' · '),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(item.reason, style: const TextStyle(height: 1.4)),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: AiOutlinedButton(
                  label: context.l10n.aiViewPlace,
                  onPressed: onPlaceTap,
                  icon: Icons.place_outlined,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AiPrimaryButton(
                  label: item.activityId == null
                      ? context.l10n.aiCreateActivity
                      : context.l10n.aiViewActivity,
                  onPressed: item.activityId == null
                      ? onCreateTap
                      : onActivityTap,
                  icon: Icons.group_add_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.enabled,
    required this.onSend,
    required this.pendingImages,
    required this.shareLocation,
    required this.onAttach,
    required this.onRemoveImage,
    required this.onShareLocationChanged,
  });

  final TextEditingController controller;
  final bool enabled;
  final VoidCallback onSend;
  final List<XFile> pendingImages;
  final bool shareLocation;
  final VoidCallback onAttach;
  final ValueChanged<int> onRemoveImage;
  final ValueChanged<bool> onShareLocationChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        10,
        16,
        10 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (pendingImages.isNotEmpty) ...<Widget>[
            SizedBox(
              height: 78,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: pendingImages.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) => Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: FutureBuilder<List<int>>(
                        future: pendingImages[index].readAsBytes(),
                        builder: (context, snapshot) => snapshot.hasData
                            ? Image.memory(
                                Uint8List.fromList(snapshot.data!),
                                width: 68,
                                height: 68,
                                fit: BoxFit.cover,
                              )
                            : const SizedBox(
                                width: 68,
                                height: 68,
                                child: ColoredBox(
                                  color: AiColors.purple100,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                    Positioned(
                      right: -7,
                      top: -7,
                      child: Semantics(
                        button: true,
                        label: context.l10n.aiAttachmentRemove(index + 1),
                        child: InkWell(
                          onTap: enabled ? () => onRemoveImage(index) : null,
                          child: const CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.black87,
                            child: Icon(
                              Icons.close,
                              size: 13,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CheckboxListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              value: shareLocation,
              onChanged: enabled
                  ? (value) => onShareLocationChanged(value ?? false)
                  : null,
              title: Text(
                context.l10n.aiShareCurrentLocation,
                style: const TextStyle(fontSize: 13),
              ),
              subtitle: Text(
                context.l10n.aiShareLocationNotice,
                style: const TextStyle(fontSize: 11),
              ),
            ),
          ],
          Row(
            children: <Widget>[
              Semantics(
                button: true,
                label: context.l10n.aiAttachPhoto,
                child: IconButton(
                  onPressed: enabled && pendingImages.length < 3
                      ? onAttach
                      : null,
                  icon: const Icon(Icons.add_photo_alternate_outlined),
                ),
              ),
              Expanded(
                child: TextField(
                  key: const ValueKey<String>('ai-message-composer'),
                  controller: controller,
                  enabled: enabled,
                  maxLength: 500,
                  minLines: 1,
                  maxLines: 4,
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: context.l10n.aiComposerHint,
                    hintMaxLines: 1,
                    hintStyle: const TextStyle(fontSize: 14),
                    filled: true,
                    fillColor: AppColors.subtleBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (_) => onSend(),
                ),
              ),
              const SizedBox(width: 8),
              Semantics(
                button: true,
                label: context.l10n.aiSendMessage,
                child: IconButton.filled(
                  onPressed: enabled ? onSend : null,
                  style: IconButton.styleFrom(
                    backgroundColor: AiColors.purple600,
                  ),
                  icon: const Icon(Icons.arrow_upward_rounded),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const AiRobotAvatar(size: 34),
        const SizedBox(width: 10),
        const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        const SizedBox(width: 8),
        Text(message),
      ],
    );
  }
}

class _AiRetry extends StatelessWidget {
  const _AiRetry({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(message),
            const SizedBox(height: 12),
            AiPrimaryButton(
              label: '다시 시도',
              onPressed: onRetry,
              expanded: false,
            ),
          ],
        ),
      ),
    );
  }
}

String _dateLabel(DateTime date) =>
    DateFormat.MMMd(MateyaLocalizations.locale.toLanguageTag()).format(date);

String _isoDate(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
