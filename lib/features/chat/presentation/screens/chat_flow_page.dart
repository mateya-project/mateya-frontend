import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../shared/localization/mateya_localizations.dart';
import '../../../../shared/media/image_picker_lost_data.dart';
import '../../../../shared/navigation/mateya_user_profile_navigation.dart';
import '../../../../shared/permissions/mateya_permission_dialogs.dart';
import '../../../../shared/report/report_repository.dart';
import '../../../../shared/theme/app_tokens.dart';
import '../../../../shared/widgets/mateya_bottom_navigation.dart';
import '../../../../shared/widgets/mateya_header.dart';
import '../../../../shared/widgets/mateya_motion.dart';
import '../../../../shared/widgets/mateya_report_sheet.dart';
import '../../../onboarding/domain/onboarding_flow.dart';
import '../../application/chat_controller.dart';
import '../../domain/chat_models.dart';
import '../widgets/chat_composer_widgets.dart';
import '../widgets/chat_formatters.dart';
import '../widgets/chat_list_widgets.dart';
import '../widgets/chat_message_widgets.dart';
import '../widgets/chat_status_widgets.dart';

class ChatFlowPage extends StatefulWidget {
  const ChatFlowPage({
    super.key,
    required this.controller,
    this.onBack,
    required this.onHomeTap,
    required this.onExploreTap,
    required this.onPlusTap,
    required this.onProfileTap,
  });

  final ChatController controller;
  final VoidCallback? onBack;
  final VoidCallback onHomeTap;
  final VoidCallback onExploreTap;
  final VoidCallback onPlusTap;
  final VoidCallback onProfileTap;

  @override
  State<ChatFlowPage> createState() => _ChatFlowPageState();
}

class _ChatFlowPageState extends State<ChatFlowPage> {
  static const List<String> _allowedPhotoExtensions = <String>[
    'jpg',
    'jpeg',
    'png',
    'webp',
    'gif',
    'heic',
    'heif',
  ];
  static const int _maxAttachmentCount = 10;
  static const int _maxAttachmentBytes = 10 * 1024 * 1024;
  static const String _pendingAttachmentRecoveryKey =
      'chat.pending_attachment_recovery';

  final ImagePicker _imagePicker = ImagePicker();
  final ReportRepository _reportRepository = ReportRepository();
  final TextEditingController _draftController = TextEditingController();
  final ScrollController _listScrollController = ScrollController();
  final ScrollController _scrollController = ScrollController();

  String? _lastRoomId;
  int _lastGroupCount = 0;
  int _lastToastVersion = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleControllerChanged);
    _listScrollController.addListener(_handleListScroll);
    _scrollController.addListener(_handleDetailScroll);
    _syncDraft();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      unawaited(_restoreLostAttachments());
    });
  }

  @override
  void didUpdateWidget(covariant ChatFlowPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller == widget.controller) {
      return;
    }
    oldWidget.controller.removeListener(_handleControllerChanged);
    widget.controller.addListener(_handleControllerChanged);
    _syncDraft();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleControllerChanged);
    _listScrollController
      ..removeListener(_handleListScroll)
      ..dispose();
    _scrollController.removeListener(_handleDetailScroll);
    _draftController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleListScroll() {
    if (!_listScrollController.hasClients) {
      return;
    }
    if (_listScrollController.position.extentAfter < 280) {
      widget.controller.loadMoreRooms();
    }
  }

  void _handleDetailScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    if (_scrollController.position.extentBefore < 120) {
      widget.controller.loadOlderMessages();
    }
  }

  void _handleControllerChanged() {
    _syncDraft();
    if (widget.controller.toastMessage != null &&
        widget.controller.toastVersion != _lastToastVersion) {
      _lastToastVersion = widget.controller.toastVersion;
      _showPendingMessage(widget.controller.toastMessage!);
      widget.controller.clearToast();
    }
    final room = widget.controller.currentRoom;
    final roomId = widget.controller.selectedRoomId;
    final groupCount = room?.messageGroups.length ?? 0;
    final shouldScroll =
        widget.controller.isDetailOpen &&
        widget.controller.roomPhase == AsyncPhase.success &&
        (roomId != _lastRoomId || groupCount != _lastGroupCount);

    _lastRoomId = roomId;
    _lastGroupCount = groupCount;

    if (!shouldScroll) {
      return;
    }

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

  void _syncDraft() {
    if (_draftController.text == widget.controller.draft) {
      return;
    }
    _draftController.value = TextEditingValue(
      text: widget.controller.draft,
      selection: TextSelection.collapsed(
        offset: widget.controller.draft.length,
      ),
    );
  }

  void _showPendingMessage(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final messenger = ScaffoldMessenger.maybeOf(context);
      if (messenger == null) {
        return;
      }
      messenger.showSnackBar(SnackBar(content: Text(message)));
    });
  }

  Future<String?> _submitChatReport(
    ChatRoom room,
    String body,
    List<XFile> images,
  ) async {
    try {
      await _reportRepository.submitReport(
        targetType: ReportTargetType.chatMessage,
        targetId: room.id,
        reason: body,
        images: images,
      );
      return null;
    } on ReportRepositoryException catch (error) {
      return error.message;
    }
  }

  Future<void> _openReportSheet(ChatRoom room) {
    return showMateyaReportSheet(
      context,
      subjectLabel: room.title,
      onSubmit: (body, images) => _submitChatReport(room, body, images),
    );
  }

  Future<void> _openSenderProfile(String userId) async {
    await openMateyaUserProfile(context, userId);
  }

  Future<void> _restoreLostAttachments() async {
    final l10n = context.l10n;
    if (!await _consumePendingAttachmentRecoveryFlag()) {
      return;
    }
    final recovery = await recoverLostImagePickerData(
      _imagePicker.retrieveLostData,
      fallbackErrorMessage: l10n.chatAttachmentRecoveryFailed,
    );
    if (!mounted || recovery.isEmpty) {
      return;
    }
    if (recovery.errorMessage != null) {
      _showPendingMessage(recovery.errorMessage!);
      return;
    }

    await _consumePickedFiles(
      recovery.files,
      source: ChatAttachmentSource.gallery,
    );
  }

  Future<void> _openAttachmentPicker() async {
    final action = await showModalBottomSheet<_AttachmentAction>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final l10n = context.l10n;
        final theme = Theme.of(context);
        return SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              24,
              12,
              24,
              20 + MediaQuery.of(context).viewPadding.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.disabledButton,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  l10n.chatAttachmentSheetTitle,
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.chatAttachmentSheetDescription,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 18),
                AttachmentActionTile(
                  icon: Icons.photo_library_outlined,
                  title: l10n.chatAttachmentGalleryTitle,
                  subtitle: l10n.chatAttachmentGallerySubtitle,
                  onTap: () =>
                      Navigator.of(context).pop(_AttachmentAction.gallery),
                ),
                const SizedBox(height: 12),
                AttachmentActionTile(
                  icon: Icons.photo_camera_outlined,
                  title: l10n.chatAttachmentCameraTitle,
                  subtitle: l10n.chatAttachmentCameraSubtitle,
                  onTap: () =>
                      Navigator.of(context).pop(_AttachmentAction.camera),
                ),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                  decoration: BoxDecoration(
                    color: AppColors.appSurface,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      GuideRow(text: l10n.chatAttachmentGuideFormats),
                      GuideRow(text: l10n.chatAttachmentGuideMaxSize),
                      GuideRow(
                        text: l10n.chatAttachmentGuideMaxCount(
                          _maxAttachmentCount,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted || action == null) {
      return;
    }

    await _markPendingAttachmentRecovery();

    try {
      switch (action) {
        case _AttachmentAction.gallery:
          final pickedFiles = await _imagePicker.pickMultiImage(
            imageQuality: 88,
            maxWidth: 2400,
          );
          if (!mounted || pickedFiles.isEmpty) {
            return;
          }
          await _consumePickedFiles(
            pickedFiles,
            source: ChatAttachmentSource.gallery,
          );
          return;
        case _AttachmentAction.camera:
          final pickedFile = await _imagePicker.pickImage(
            source: ImageSource.camera,
            imageQuality: 88,
            maxWidth: 2400,
          );
          if (!mounted || pickedFile == null) {
            return;
          }
          await _consumePickedFiles(<XFile>[
            pickedFile,
          ], source: ChatAttachmentSource.camera);
          return;
      }
    } on PlatformException catch (error) {
      if (!mounted) {
        return;
      }

      if (error.code == 'photo_access_denied' ||
          error.code == 'camera_access_denied') {
        final actionResult = await showMateyaPermissionRecoveryDialog(
          context,
          title: error.code == 'camera_access_denied'
              ? context.l10n.chatAttachmentCameraRecoveryTitle
              : context.l10n.chatAttachmentPhotoRecoveryTitle,
          message: error.code == 'camera_access_denied'
              ? context.l10n.chatAttachmentCameraRecoveryMessage
              : context.l10n.chatAttachmentPhotoRecoveryMessage,
          retryLabel: context.l10n.commonRetry,
        );
        if (!mounted) {
          return;
        }
        if (actionResult == MateyaPermissionRecoveryAction.retry) {
          await _openAttachmentPicker();
          return;
        }
      }
      if (!mounted) {
        return;
      }
      _showPendingMessage(context.l10n.chatAttachmentLoadFailed);
    } finally {
      await _clearPendingAttachmentRecovery();
    }
  }

  Future<void> _markPendingAttachmentRecovery() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_pendingAttachmentRecoveryKey, true);
  }

  Future<bool> _consumePendingAttachmentRecoveryFlag() async {
    final preferences = await SharedPreferences.getInstance();
    final shouldRecover =
        preferences.getBool(_pendingAttachmentRecoveryKey) ?? false;
    if (shouldRecover) {
      await preferences.remove(_pendingAttachmentRecoveryKey);
    }
    return shouldRecover;
  }

  Future<void> _clearPendingAttachmentRecovery() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_pendingAttachmentRecoveryKey);
  }

  Future<void> _consumePickedFiles(
    List<XFile> pickedFiles, {
    required ChatAttachmentSource source,
  }) async {
    final l10n = context.l10n;
    final attachments = <ChatAttachment>[];
    var rejectedTypeCount = 0;
    var rejectedSizeCount = 0;

    for (var index = 0; index < pickedFiles.length; index += 1) {
      final file = pickedFiles[index];
      final fileName = file.name.isEmpty ? 'image_$index' : file.name;
      final extension = _extractExtension(fileName);
      if (!_allowedPhotoExtensions.contains(extension)) {
        rejectedTypeCount += 1;
        continue;
      }

      final fileSize = await file.length();
      if (fileSize > _maxAttachmentBytes) {
        rejectedSizeCount += 1;
        continue;
      }

      attachments.add(
        ChatAttachment(
          id: 'draft-${DateTime.now().microsecondsSinceEpoch}-$index',
          path: file.path,
          fileName: fileName,
          fileSizeBytes: fileSize,
          source: source,
        ),
      );
    }

    final overflowCount = widget.controller.addDraftAttachments(attachments);

    if (!mounted) {
      return;
    }

    if (attachments.isNotEmpty &&
        rejectedTypeCount == 0 &&
        rejectedSizeCount == 0) {
      _showPendingMessage(
        l10n.chatAttachmentAddedCount(attachments.length - overflowCount),
      );
    }
    if (rejectedTypeCount > 0) {
      _showPendingMessage(
        l10n.chatAttachmentRejectedTypeCount(rejectedTypeCount),
      );
    }
    if (rejectedSizeCount > 0) {
      _showPendingMessage(
        l10n.chatAttachmentRejectedSizeCount(rejectedSizeCount),
      );
    }
    if (overflowCount > 0) {
      _showPendingMessage(
        l10n.chatAttachmentOverflowCount(_maxAttachmentCount),
      );
    }
  }

  String _extractExtension(String fileName) {
    final dotIndex = fileName.lastIndexOf('.');
    if (dotIndex == -1 || dotIndex == fileName.length - 1) {
      return '';
    }
    return fileName.substring(dotIndex + 1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        return ColoredBox(
          color: widget.controller.isDetailOpen
              ? AppColors.appSurface
              : AppColors.background,
          child: MateyaFadeSlideSwitcher(
            duration: const Duration(milliseconds: 220),
            child: KeyedSubtree(
              key: ValueKey<String>(
                widget.controller.isDetailOpen ? 'chat-detail' : 'chat-list',
              ),
              child: widget.controller.isDetailOpen
                  ? _buildDetailScreen(context)
                  : _buildListScreen(context),
            ),
          ),
        );
      },
    );
  }

  Widget _buildListScreen(BuildContext context) {
    final isCompactHeight = MediaQuery.sizeOf(context).height < 780;
    final sectionSpacing = isCompactHeight ? 12.0 : 16.0;

    return Column(
      children: <Widget>[
        widget.onBack == null
            ? const MateyaHeader.noBackArrow()
            : MateyaHeader.backArrow(onBack: widget.onBack),
        SizedBox(height: sectionSpacing),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ChatFilterBar(
            currentFilter: widget.controller.filter,
            onChanged: widget.controller.updateFilter,
          ),
        ),
        SizedBox(height: sectionSpacing),
        Expanded(
          child: Column(
            children: <Widget>[
              Expanded(child: _buildListBody(context)),
              if (!isCompactHeight)
                const Padding(
                  padding: EdgeInsets.fromLTRB(34, 16, 34, 12),
                  child: ChatListGuidance(),
                ),
            ],
          ),
        ),
        MateyaBottomNavigation(
          currentTab: MateyaBottomTab.chat,
          onHomeTap: widget.onHomeTap,
          onExploreTap: widget.onExploreTap,
          onPlusTap: widget.onPlusTap,
          onChatTap: () {},
          onProfileTap: widget.onProfileTap,
        ),
      ],
    );
  }

  Widget _buildListBody(BuildContext context) {
    return switch (widget.controller.listPhase) {
      AsyncPhase.idle || AsyncPhase.loading => const ChatListSkeleton(),
      AsyncPhase.networkError || AsyncPhase.serverError => ChatRetryState(
        message:
            widget.controller.listErrorMessage ??
            context.l10n.chatListLoadError,
        onRetry: widget.controller.retryRooms,
      ),
      AsyncPhase.success ||
      AsyncPhase.validationError => _buildRoomList(context),
    };
  }

  Widget _buildRoomList(BuildContext context) {
    final rooms = widget.controller.visibleRooms;
    if (rooms.isEmpty) {
      return ChatEmptyState(
        title: context.l10n.chatListEmptyTitle,
        message: context.l10n.chatListEmptyBody,
      );
    }

    return ListView.separated(
      controller: _listScrollController,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      itemCount: rooms.length + (widget.controller.hasMoreRooms ? 1 : 0),
      separatorBuilder: (context, _) => const SizedBox(height: 18),
      itemBuilder: (context, index) {
        if (index >= rooms.length) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Center(
              child: widget.controller.isLoadingMoreRooms
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      context.l10n.chatListLoadMoreHint,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
            ),
          );
        }
        final room = rooms[index];
        return ChatRoomTile(
          room: room,
          onTap: () => widget.controller.openRoom(room.id),
        );
      },
    );
  }

  Widget _buildDetailScreen(BuildContext context) {
    final room = widget.controller.currentRoom;
    if (room == null) {
      return ChatRetryState(
        message: context.l10n.chatRoomMissing,
        onRetry: widget.controller.closeRoom,
        retryLabel: context.l10n.chatBackToList,
      );
    }

    return Column(
      children: <Widget>[
        MateyaHeader.chatDetail(
          title: room.title,
          subtitle: room.subtitle,
          onBack: widget.controller.closeRoom,
          onReportTap: () => _openReportSheet(room),
        ),
        Expanded(child: _buildDetailBody(context, room)),
        AnimatedPadding(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: ChatComposer(
            draftController: _draftController,
            selectedAttachments: widget.controller.draftAttachments,
            canSend: widget.controller.canSendMessage,
            onChanged: widget.controller.updateDraft,
            onAttachTap: _openAttachmentPicker,
            onRemoveAttachment: widget.controller.removeDraftAttachment,
            onSendTap: () {
              widget.controller.sendMessage();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDetailBody(BuildContext context, ChatRoom room) {
    return switch (widget.controller.roomPhase) {
      AsyncPhase.loading || AsyncPhase.idle => const ChatDetailSkeleton(),
      AsyncPhase.networkError || AsyncPhase.serverError => ChatRetryState(
        message:
            widget.controller.roomErrorMessage ??
            context.l10n.chatRoomLoadError,
        onRetry: widget.controller.retryRoom,
      ),
      AsyncPhase.success || AsyncPhase.validationError => ListView(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
        children: <Widget>[
          if (widget.controller.hasOlderMessages ||
              widget.controller.isLoadingOlderMessages)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Center(
                child: widget.controller.isLoadingOlderMessages
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        context.l10n.chatOlderMessagesHint,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
              ),
            ),
          Center(child: DateChip(label: formatConversationDate(room))),
          const SizedBox(height: 18),
          for (final group in room.messageGroups) ...<Widget>[
            group.isMine
                ? OutgoingGroup(group: group)
                : IncomingGroup(
                    group: group,
                    onAvatarTap: () {
                      unawaited(_openSenderProfile(group.sender.id));
                    },
                    onToggleTranslation: group.supportsTranslation
                        ? () {
                            unawaited(
                              widget.controller.toggleTranslation(group.id),
                            );
                          }
                        : null,
                  ),
            const SizedBox(height: 14),
          ],
        ],
      ),
    };
  }
}

enum _AttachmentAction { gallery, camera }
