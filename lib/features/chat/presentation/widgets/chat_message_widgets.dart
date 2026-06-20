import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../shared/localization/mateya_localizations.dart';
import '../../../../shared/theme/app_tokens.dart';
import '../../../../shared/widgets/mateya_translation_toggle_button.dart';
import '../../domain/chat_models.dart';
import 'chat_formatters.dart';
import 'chat_list_widgets.dart';

class IncomingGroup extends StatelessWidget {
  const IncomingGroup({
    super.key,
    required this.group,
    required this.onToggleTranslation,
    this.onAvatarTap,
  });

  final ChatMessageGroup group;
  final VoidCallback? onToggleTranslation;
  final VoidCallback? onAvatarTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InkWell(
          onTap: onAvatarTap,
          borderRadius: BorderRadius.circular(999),
          child: NetworkAvatar(
            imageUrl: group.sender.avatarUrl,
            label: group.sender.displayName,
            size: 48,
          ),
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
              _IncomingBubbleCluster(
                group: group,
                onToggleTranslation: onToggleTranslation,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _IncomingBubbleCluster extends StatefulWidget {
  const _IncomingBubbleCluster({
    required this.group,
    required this.onToggleTranslation,
  });

  final ChatMessageGroup group;
  final VoidCallback? onToggleTranslation;

  @override
  State<_IncomingBubbleCluster> createState() => _IncomingBubbleClusterState();
}

class _IncomingBubbleClusterState extends State<_IncomingBubbleCluster> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final metadataColor = AppColors.fieldBorder;

    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 298),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            for (
              var index = 0;
              index < widget.group.bubbles.length;
              index++
            ) ...<Widget>[
              IncomingBubble(
                bubble: widget.group.bubbles[index],
                isTranslatedVisible: widget.group.isTranslatedVisible,
              ),
              if (index != widget.group.bubbles.length - 1)
                const SizedBox(height: 8),
            ],
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Text(
                  formatMeridiemTime(widget.group.sentAt),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: metadataColor,
                  ),
                ),
                if (widget.onToggleTranslation != null)
                  MateyaTranslationToggleButton(
                    label: widget.group.translationToggleLabel,
                    onPressed: widget.onToggleTranslation!,
                    variant: MateyaTranslationToggleButtonVariant.inline,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OutgoingGroup extends StatelessWidget {
  const OutgoingGroup({super.key, required this.group});

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
              child: OutgoingBubble(bubble: bubble),
            ),
          ],
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              formatMeridiemTime(group.sentAt),
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

class OutgoingBubble extends StatelessWidget {
  const OutgoingBubble({super.key, required this.bubble});

  final ChatBubble bubble;

  @override
  Widget build(BuildContext context) {
    final hasText = bubble.resolvedText(false)?.trim().isNotEmpty ?? false;
    final imageOnly = bubble.hasAttachments && !hasText;

    return Align(
      alignment: Alignment.centerRight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.brandGreen,
          borderRadius: BorderRadius.circular(imageOnly ? 18 : 16),
        ),
        child: Padding(
          padding: imageOnly
              ? const EdgeInsets.all(4)
              : const EdgeInsets.fromLTRB(12, 6, 12, 8),
          child: BubblePayload(
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

class IncomingBubble extends StatelessWidget {
  const IncomingBubble({
    super.key,
    required this.bubble,
    required this.isTranslatedVisible,
  });

  final ChatBubble bubble;
  final bool isTranslatedVisible;

  @override
  Widget build(BuildContext context) {
    final hasText =
        bubble.resolvedText(isTranslatedVisible)?.trim().isNotEmpty ?? false;
    final imageOnly = bubble.hasAttachments && !hasText;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 298),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(imageOnly ? 18 : 19),
        ),
        child: Padding(
          padding: imageOnly
              ? const EdgeInsets.all(4)
              : const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: BubblePayload(
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

class BubblePayload extends StatelessWidget {
  const BubblePayload({
    super.key,
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
        MessageAttachmentGrid(attachments: bubble.attachments),
        if (text != null && text!.trim().isNotEmpty) const SizedBox(height: 8),
      ],
      if (text != null && text!.trim().isNotEmpty)
        Text(text!, style: textStyle?.copyWith(color: textColor)),
    ];

    if (children.isEmpty) {
      children.add(
        Text(
          context.l10n.chatAttachmentPhotoOnly,
          style: textStyle?.copyWith(color: textColor),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}

class MessageAttachmentGrid extends StatelessWidget {
  const MessageAttachmentGrid({super.key, required this.attachments});

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
                                AttachmentFallback(label: attachment.fileName),
                          )
                        : Image.file(
                            File(attachment.path),
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                AttachmentFallback(label: attachment.fileName),
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

class AttachmentFallback extends StatelessWidget {
  const AttachmentFallback({
    super.key,
    required this.label,
    this.compact = false,
  });

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

class DateChip extends StatelessWidget {
  const DateChip({super.key, required this.label});

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
