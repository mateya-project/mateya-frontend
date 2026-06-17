import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../shared/theme/app_tokens.dart';
import '../../domain/chat_models.dart';
import 'chat_message_widgets.dart';

class ChatComposer extends StatelessWidget {
  const ChatComposer({
    super.key,
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
                      return DraftAttachmentPreview(
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
                  ComposerIconButton(
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
                  ComposerIconButton(
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

class DraftAttachmentPreview extends StatelessWidget {
  const DraftAttachmentPreview({
    super.key,
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
              errorBuilder: (_, _, _) =>
                  AttachmentFallback(label: attachment.fileName, compact: true),
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

class ComposerIconButton extends StatelessWidget {
  const ComposerIconButton({
    super.key,
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

class GuideRow extends StatelessWidget {
  const GuideRow({super.key, required this.text});

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

class AttachmentActionTile extends StatelessWidget {
  const AttachmentActionTile({
    super.key,
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
