import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../shared/theme/app_tokens.dart';
import '../../../../shared/widgets/mateya_bottom_navigation.dart';
import '../../../../shared/widgets/mateya_header.dart';
import '../../../onboarding/domain/onboarding_flow.dart';
import '../../application/chat_controller.dart';
import '../../domain/chat_models.dart';

class ChatFlowPage extends StatefulWidget {
  const ChatFlowPage({
    super.key,
    required this.controller,
    required this.onBack,
    required this.onHomeTap,
    required this.onExploreTap,
    required this.onPlusTap,
    required this.onProfileTap,
  });

  final ChatController controller;
  final VoidCallback onBack;
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
  ];
  static const int _maxAttachmentCount = 10;
  static const int _maxAttachmentBytes = 10 * 1024 * 1024;

  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _draftController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String? _lastRoomId;
  int _lastGroupCount = 0;
  int _lastToastVersion = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleControllerChanged);
    _syncDraft();
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
    _draftController.dispose();
    _scrollController.dispose();
    super.dispose();
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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _openAttachmentPicker() async {
    final action = await showModalBottomSheet<_AttachmentAction>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('사진 첨부 기준', style: theme.textTheme.titleLarge),
                const SizedBox(height: 12),
                Text(
                  '실무 기준으로 JPG, PNG, WEBP, GIF 형식과 10MB 이하 이미지를 허용하도록 설계했습니다.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.fieldBorder,
                  ),
                ),
                const SizedBox(height: 16),
                _AttachmentActionTile(
                  icon: Icons.photo_library_outlined,
                  title: '앨범에서 선택',
                  subtitle: '여러 장을 한 번에 고를 수 있습니다.',
                  onTap: () =>
                      Navigator.of(context).pop(_AttachmentAction.gallery),
                ),
                const SizedBox(height: 10),
                _AttachmentActionTile(
                  icon: Icons.photo_camera_outlined,
                  title: '카메라로 촬영',
                  subtitle: '사진 1장을 바로 찍어 첨부합니다.',
                  onTap: () =>
                      Navigator.of(context).pop(_AttachmentAction.camera),
                ),
                const SizedBox(height: 18),
                const _GuideRow(text: '허용 형식: JPG, PNG, WEBP, GIF'),
                const _GuideRow(text: '최대 크기: 10MB'),
                const _GuideRow(text: '메시지당 최대 10장'),
                const _GuideRow(text: '저해상도 이미지는 업로드 전 압축 권장'),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted || action == null) {
      return;
    }

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
    } catch (_) {
      if (!mounted) {
        return;
      }
      _showPendingMessage('사진을 불러오지 못했어요. 권한과 파일 상태를 확인해 주세요.');
    }
  }

  Future<void> _consumePickedFiles(
    List<XFile> pickedFiles, {
    required ChatAttachmentSource source,
  }) async {
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
      _showPendingMessage('사진 ${attachments.length - overflowCount}장을 첨부했어요.');
    }
    if (rejectedTypeCount > 0) {
      _showPendingMessage('지원하지 않는 형식의 사진 $rejectedTypeCount장은 제외했어요.');
    }
    if (rejectedSizeCount > 0) {
      _showPendingMessage('10MB를 초과한 사진 $rejectedSizeCount장은 제외했어요.');
    }
    if (overflowCount > 0) {
      _showPendingMessage('사진은 최대 $_maxAttachmentCount장까지 첨부할 수 있어요.');
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
          child: widget.controller.isDetailOpen
              ? _buildDetailScreen(context)
              : _buildListScreen(context),
        );
      },
    );
  }

  Widget _buildListScreen(BuildContext context) {
    return Column(
      children: <Widget>[
        MateyaHeader.backArrow(onBack: widget.onBack),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _FilterBar(
            currentFilter: widget.controller.filter,
            onChanged: widget.controller.updateFilter,
          ),
        ),
        const SizedBox(height: 24),
        Expanded(child: _buildListBody(context)),
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
      AsyncPhase.idle || AsyncPhase.loading => const _ChatListSkeleton(),
      AsyncPhase.networkError || AsyncPhase.serverError => _RetryState(
        message: widget.controller.listErrorMessage ?? '채팅 목록을 불러오지 못했어요.',
        onRetry: widget.controller.retryRooms,
      ),
      AsyncPhase.success ||
      AsyncPhase.validationError => _buildRoomList(context),
    };
  }

  Widget _buildRoomList(BuildContext context) {
    final rooms = widget.controller.visibleRooms;
    if (rooms.isEmpty) {
      return const _EmptyState(
        title: '표시할 채팅방이 없어요.',
        message: '필터를 바꾸거나 새로운 대화를 시작해 보세요.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      itemCount: rooms.length,
      separatorBuilder: (context, _) => const SizedBox(height: 18),
      itemBuilder: (context, index) {
        final room = rooms[index];
        return _ChatRoomTile(
          room: room,
          onTap: () => widget.controller.openRoom(room.id),
        );
      },
    );
  }

  Widget _buildDetailScreen(BuildContext context) {
    final room = widget.controller.currentRoom;
    if (room == null) {
      return _RetryState(
        message: '채팅방 정보를 찾을 수 없어요.',
        onRetry: widget.controller.closeRoom,
        retryLabel: '목록으로',
      );
    }

    return Column(
      children: <Widget>[
        MateyaHeader.chatDetail(
          title: room.title,
          subtitle: room.subtitle,
          onBack: widget.controller.closeRoom,
        ),
        Expanded(child: _buildDetailBody(context, room)),
        _ChatComposer(
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
      ],
    );
  }

  Widget _buildDetailBody(BuildContext context, ChatRoom room) {
    return switch (widget.controller.roomPhase) {
      AsyncPhase.loading || AsyncPhase.idle => const _ChatDetailSkeleton(),
      AsyncPhase.networkError || AsyncPhase.serverError => _RetryState(
        message: widget.controller.roomErrorMessage ?? '채팅방을 불러오지 못했어요.',
        onRetry: widget.controller.retryRoom,
      ),
      AsyncPhase.success || AsyncPhase.validationError => ListView(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
        children: <Widget>[
          Center(child: _DateChip(label: _formatConversationDate(room))),
          const SizedBox(height: 18),
          for (final group in room.messageGroups) ...<Widget>[
            group.isMine
                ? _OutgoingGroup(group: group)
                : _IncomingGroup(
                    group: group,
                    onToggleTranslation: group.supportsTranslation
                        ? () => widget.controller.toggleTranslation(group.id)
                        : null,
                  ),
            const SizedBox(height: 14),
          ],
        ],
      ),
    };
  }

  String _formatConversationDate(ChatRoom room) {
    final reference = room.messageGroups.isEmpty
        ? DateTime.now()
        : room.messageGroups.first.sentAt;
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    if (_isSameDay(now, reference)) {
      return '오늘 ${_formatMeridiemTime(reference)}';
    }
    if (_isSameDay(yesterday, reference)) {
      return '어제 ${_formatMeridiemTime(reference)}';
    }
    if (now.year == reference.year) {
      return '${reference.month}월 ${reference.day}일 ${_formatMeridiemTime(reference)}';
    }
    return '${reference.year}.${reference.month}.${reference.day} ${_formatMeridiemTime(reference)}';
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.currentFilter, required this.onChanged});

  final ChatListFilter currentFilter;
  final ValueChanged<ChatListFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.disabledSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: ChatListFilter.values
            .map((filter) {
              final selected = filter == currentFilter;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(filter),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(selected ? 12 : 999),
                      boxShadow: selected
                          ? const <BoxShadow>[
                              BoxShadow(
                                color: Color(0x14000000),
                                blurRadius: 2,
                                offset: Offset(0, 0),
                              ),
                              BoxShadow(
                                color: Color(0x14000000),
                                blurRadius: 8.5,
                                offset: Offset(0, 6),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      filter.label,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              );
            })
            .toList(growable: false),
      ),
    );
  }
}

class _ChatRoomTile extends StatelessWidget {
  const _ChatRoomTile({required this.room, required this.onTap});

  final ChatRoom room;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _NetworkAvatar(imageUrl: room.imageUrl, label: room.title, size: 54),
          const SizedBox(width: 15),
          Expanded(
            child: SizedBox(
              height: 66,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    room.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    room.lastMessagePreview,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.fieldBorder,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 54,
            height: 56,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  _formatRoomTimestamp(room.lastMessageAt),
                  textAlign: TextAlign.right,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.fieldBorder,
                  ),
                ),
                const Spacer(),
                if (room.unreadCount > 0) _UnreadBadge(count: room.unreadCount),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IncomingGroup extends StatelessWidget {
  const _IncomingGroup({
    required this.group,
    required this.onToggleTranslation,
  });

  final ChatMessageGroup group;
  final VoidCallback? onToggleTranslation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _NetworkAvatar(
          imageUrl: group.sender.avatarUrl,
          label: group.sender.displayName,
          size: 48,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                group.sender.displayName,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              for (final bubble in group.bubbles) ...<Widget>[
                _IncomingBubble(
                  bubble: bubble,
                  isTranslatedVisible: group.isTranslatedVisible,
                ),
                const SizedBox(height: 8),
              ],
              Row(
                children: <Widget>[
                  Text(
                    _formatMeridiemTime(group.sentAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.fieldBorder,
                    ),
                  ),
                  const Spacer(),
                  if (onToggleTranslation != null)
                    TextButton(
                      onPressed: onToggleTranslation,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        foregroundColor: AppColors.brandGreen,
                      ),
                      child: Text(
                        group.translationToggleLabel,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: AppColors.brandGreen,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.brandGreen,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OutgoingGroup extends StatelessWidget {
  const _OutgoingGroup({required this.group});

  final ChatMessageGroup group;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          for (final bubble in group.bubbles) ...<Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: _OutgoingBubble(bubble: bubble),
            ),
          ],
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _formatMeridiemTime(group.sentAt),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.fieldBorder),
            ),
          ),
        ],
      ),
    );
  }
}

class _OutgoingBubble extends StatelessWidget {
  const _OutgoingBubble({required this.bubble});

  final ChatBubble bubble;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.brandGreen,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
          child: _BubblePayload(
            bubble: bubble,
            text: bubble.resolvedText(false),
            textStyle: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.white),
            textColor: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _IncomingBubble extends StatelessWidget {
  const _IncomingBubble({
    required this.bubble,
    required this.isTranslatedVisible,
  });

  final ChatBubble bubble;
  final bool isTranslatedVisible;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 298),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(19),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: _BubblePayload(
            bubble: bubble,
            text: bubble.resolvedText(isTranslatedVisible),
            textStyle: Theme.of(context).textTheme.bodyLarge,
            textColor: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _ChatComposer extends StatelessWidget {
  const _ChatComposer({
    required this.draftController,
    required this.selectedAttachments,
    required this.canSend,
    required this.onChanged,
    required this.onAttachTap,
    required this.onRemoveAttachment,
    required this.onSendTap,
  });

  final TextEditingController draftController;
  final List<ChatAttachment> selectedAttachments;
  final bool canSend;
  final ValueChanged<String> onChanged;
  final VoidCallback onAttachTap;
  final ValueChanged<String> onRemoveAttachment;
  final VoidCallback onSendTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(6),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (selectedAttachments.isNotEmpty) ...<Widget>[
                SizedBox(
                  height: 72,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: selectedAttachments.length,
                    separatorBuilder: (context, _) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final attachment = selectedAttachments[index];
                      return _DraftAttachmentPreview(
                        attachment: attachment,
                        onRemove: () => onRemoveAttachment(attachment.id),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
              ],
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  _ComposerIconButton(
                    icon: Icons.camera_alt_rounded,
                    iconColor: AppColors.brandGreen,
                    onTap: onAttachTap,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.appSurface,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            color: Color(0x1F000000),
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: draftController,
                        onChanged: onChanged,
                        minLines: 1,
                        maxLines: 4,
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                          hintText: '메시지를 입력하세요',
                          hintStyle: Theme.of(context).textTheme.bodyMedium,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.fromLTRB(
                            14,
                            11,
                            14,
                            11,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _ComposerIconButton(
                    icon: Icons.send_rounded,
                    iconColor: canSend
                        ? AppColors.brandGreen
                        : AppColors.disabledText,
                    onTap: canSend ? onSendTap : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DraftAttachmentPreview extends StatelessWidget {
  const _DraftAttachmentPreview({
    required this.attachment,
    required this.onRemove,
  });

  final ChatAttachment attachment;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            width: 72,
            height: 72,
            child: Image.file(
              File(attachment.path),
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _AttachmentFallback(
                label: attachment.fileName,
                compact: true,
              ),
            ),
          ),
        ),
        Positioned(
          right: -6,
          top: -6,
          child: Material(
            color: Colors.white,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onRemove,
              child: const SizedBox(
                width: 24,
                height: 24,
                child: Icon(Icons.close_rounded, size: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ComposerIconButton extends StatelessWidget {
  const _ComposerIconButton({
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.appSurface,
      elevation: 4,
      shadowColor: const Color(0x1F000000),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, size: 20, color: iconColor),
        ),
      ),
    );
  }
}

class _BubblePayload extends StatelessWidget {
  const _BubblePayload({
    required this.bubble,
    required this.text,
    required this.textStyle,
    required this.textColor,
  });

  final ChatBubble bubble;
  final String? text;
  final TextStyle? textStyle;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      if (bubble.hasAttachments) ...<Widget>[
        _MessageAttachmentGrid(attachments: bubble.attachments),
        if (text != null && text!.trim().isNotEmpty) const SizedBox(height: 8),
      ],
      if (text != null && text!.trim().isNotEmpty)
        Text(text!, style: textStyle?.copyWith(color: textColor)),
    ];

    if (children.isEmpty) {
      children.add(Text('사진', style: textStyle?.copyWith(color: textColor)));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}

class _MessageAttachmentGrid extends StatelessWidget {
  const _MessageAttachmentGrid({required this.attachments});

  final List<ChatAttachment> attachments;

  @override
  Widget build(BuildContext context) {
    final displayAttachments = attachments.take(4).toList(growable: false);
    final isSingle = displayAttachments.length == 1;

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: displayAttachments
          .asMap()
          .entries
          .map((entry) {
            final index = entry.key;
            final attachment = entry.value;
            final hiddenCount = attachments.length - displayAttachments.length;
            final showOverlay =
                hiddenCount > 0 && index == displayAttachments.length - 1;

            return ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  SizedBox(
                    width: isSingle ? 182 : 110,
                    height: isSingle ? 182 : 110,
                    child: attachment.path.startsWith('http')
                        ? Image.network(
                            attachment.path,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                _AttachmentFallback(label: attachment.fileName),
                          )
                        : Image.file(
                            File(attachment.path),
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                _AttachmentFallback(label: attachment.fileName),
                          ),
                  ),
                  if (showOverlay)
                    Container(
                      width: isSingle ? 182 : 110,
                      height: isSingle ? 182 : 110,
                      color: Colors.black45,
                      alignment: Alignment.center,
                      child: Text(
                        '+$hiddenCount',
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(color: Colors.white),
                      ),
                    ),
                ],
              ),
            );
          })
          .toList(growable: false),
    );
  }
}

class _AttachmentFallback extends StatelessWidget {
  const _AttachmentFallback({required this.label, this.compact = false});

  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.disabledSurface,
        borderRadius: BorderRadius.circular(compact ? 16 : 14),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            label,
            maxLines: compact ? 2 : 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.fieldBorder),
          ),
        ),
      ),
    );
  }
}

class _NetworkAvatar extends StatelessWidget {
  const _NetworkAvatar({
    required this.imageUrl,
    required this.label,
    required this.size,
  });

  final String? imageUrl;
  final String label;
  final double size;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(size / 2);

    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        width: size,
        height: size,
        child: imageUrl == null
            ? _FallbackAvatar(label: label, size: size)
            : Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    _FallbackAvatar(label: label, size: size),
              ),
      ),
    );
  }
}

class _FallbackAvatar extends StatelessWidget {
  const _FallbackAvatar({required this.label, required this.size});

  final String label;
  final double size;

  @override
  Widget build(BuildContext context) {
    final trimmed = label.trim();
    final initials = trimmed.isEmpty ? '?' : trimmed.substring(0, 1);

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[Color(0xFF90E0A0), Color(0xFF5AC366)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _UnreadBadge extends StatelessWidget {
  const _UnreadBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final label = count > 20 ? '20+' : '$count';

    return Container(
      constraints: const BoxConstraints(minWidth: 25, minHeight: 25),
      padding: const EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
        color: AppColors.brandGreen,
        borderRadius: BorderRadius.circular(12.5),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.disabledSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}

class _GuideRow extends StatelessWidget {
  const _GuideRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 7),
            child: Icon(Icons.circle, size: 6, color: AppColors.brandGreen),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _AttachmentActionTile extends StatelessWidget {
  const _AttachmentActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.appSurface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: <Widget>[
            Icon(icon, color: AppColors.brandGreen),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.fieldBorder,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.fieldBorder,
            ),
          ],
        ),
      ),
    );
  }
}

class _RetryState extends StatelessWidget {
  const _RetryState({
    required this.message,
    required this.onRetry,
    this.retryLabel = '다시 시도',
  });

  final String message;
  final VoidCallback onRetry;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.sms_failed_outlined,
              size: 34,
              color: AppColors.fieldBorder,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.fieldBorder,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.brandGreen,
                foregroundColor: Colors.white,
              ),
              child: Text(retryLabel),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.chat_bubble_outline_rounded,
              size: 34,
              color: AppColors.fieldBorder,
            ),
            const SizedBox(height: 12),
            Text(title, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.fieldBorder,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatListSkeleton extends StatelessWidget {
  const _ChatListSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      itemCount: 6,
      separatorBuilder: (context, _) => const SizedBox(height: 18),
      itemBuilder: (context, index) {
        return const Row(
          children: <Widget>[
            _SkeletonBox(width: 54, height: 54, radius: 27),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _SkeletonBox(width: 140, height: 16, radius: 8),
                  SizedBox(height: 8),
                  _SkeletonBox(width: double.infinity, height: 14, radius: 8),
                  SizedBox(height: 6),
                  _SkeletonBox(width: 120, height: 14, radius: 8),
                ],
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                _SkeletonBox(width: 44, height: 14, radius: 8),
                SizedBox(height: 14),
                _SkeletonBox(width: 25, height: 25, radius: 12.5),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _ChatDetailSkeleton extends StatelessWidget {
  const _ChatDetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
      children: const <Widget>[
        Center(child: _SkeletonBox(width: 124, height: 24, radius: 12)),
        SizedBox(height: 22),
        Align(
          alignment: Alignment.centerRight,
          child: _SkeletonBox(width: 180, height: 38, radius: 16),
        ),
        SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: _SkeletonBox(width: 210, height: 38, radius: 16),
        ),
        SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _SkeletonBox(width: 48, height: 48, radius: 24),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _SkeletonBox(width: 92, height: 12, radius: 6),
                  SizedBox(height: 12),
                  _SkeletonBox(width: 156, height: 36, radius: 18),
                  SizedBox(height: 8),
                  _SkeletonBox(width: 156, height: 36, radius: 18),
                  SizedBox(height: 8),
                  _SkeletonBox(width: double.infinity, height: 72, radius: 18),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.width,
    required this.height,
    required this.radius,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.disabledSurface,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

String _formatRoomTimestamp(DateTime sentAt) {
  final now = DateTime.now();
  final difference = now.difference(sentAt);

  if (difference.inMinutes < 1) {
    return '방금';
  }
  if (difference.inMinutes < 60) {
    return '${difference.inMinutes}분 전';
  }
  if (now.year == sentAt.year &&
      now.month == sentAt.month &&
      now.day == sentAt.day) {
    return '${difference.inHours}시간 전';
  }

  final yesterday = now.subtract(const Duration(days: 1));
  if (yesterday.year == sentAt.year &&
      yesterday.month == sentAt.month &&
      yesterday.day == sentAt.day) {
    return '어제';
  }

  if (now.year == sentAt.year) {
    return '${sentAt.month}월 ${sentAt.day}일';
  }
  if (now.year - sentAt.year == 1) {
    return '작년';
  }
  return '${sentAt.year}.${sentAt.month}.${sentAt.day}';
}

String _formatMeridiemTime(DateTime dateTime) {
  final hour = dateTime.hour;
  final period = hour >= 12 ? '오후' : '오전';
  final displayHour = hour == 0
      ? 12
      : hour > 12
      ? hour - 12
      : hour;
  final minute = dateTime.minute.toString().padLeft(2, '0');
  return '$period $displayHour:$minute';
}

bool _isSameDay(DateTime left, DateTime right) {
  return left.year == right.year &&
      left.month == right.month &&
      left.day == right.day;
}

enum _AttachmentAction { gallery, camera }
