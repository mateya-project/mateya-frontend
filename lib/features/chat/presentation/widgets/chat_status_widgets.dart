import 'package:flutter/material.dart';

import '../../../../shared/localization/mateya_localizations.dart';
import '../../../../shared/theme/app_tokens.dart';
import '../../../../shared/widgets/mateya_skeleton.dart';

class ChatRetryState extends StatelessWidget {
  const ChatRetryState({
    super.key,
    required this.message,
    required this.onRetry,
    this.retryLabel,
  });

  final String message;
  final VoidCallback onRetry;
  final String? retryLabel;

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
              child: Text(retryLabel ?? context.l10n.commonRetry),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatEmptyState extends StatelessWidget {
  const ChatEmptyState({super.key, required this.title, required this.message});

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

class ChatListSkeleton extends StatelessWidget {
  const ChatListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return MateyaSkeleton(
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        itemCount: 6,
        separatorBuilder: (context, _) => const SizedBox(height: 18),
        itemBuilder: (context, index) {
          return const Row(
            children: <Widget>[
              MateyaSkeletonBlock(width: 54, height: 54, radius: 27),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    MateyaSkeletonBlock(width: 140, height: 16, radius: 8),
                    SizedBox(height: 8),
                    MateyaSkeletonBlock(
                      width: double.infinity,
                      height: 14,
                      radius: 8,
                    ),
                    SizedBox(height: 6),
                    MateyaSkeletonBlock(width: 120, height: 14, radius: 8),
                  ],
                ),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  MateyaSkeletonBlock(width: 44, height: 14, radius: 8),
                  SizedBox(height: 14),
                  MateyaSkeletonBlock(width: 25, height: 25, radius: 12.5),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class ChatListGuidance extends StatelessWidget {
  const ChatListGuidance({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.chatListGuidance,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: AppColors.textMuted,
        height: 17 / 12,
      ),
    );
  }
}

class ChatDetailSkeleton extends StatelessWidget {
  const ChatDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return MateyaSkeleton(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
        children: const <Widget>[
          Center(
            child: MateyaSkeletonBlock(width: 124, height: 24, radius: 12),
          ),
          SizedBox(height: 22),
          Align(
            alignment: Alignment.centerRight,
            child: MateyaSkeletonBlock(width: 180, height: 38, radius: 16),
          ),
          SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: MateyaSkeletonBlock(width: 210, height: 38, radius: 16),
          ),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              MateyaSkeletonBlock(width: 48, height: 48, radius: 24),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    MateyaSkeletonBlock(width: 92, height: 12, radius: 6),
                    SizedBox(height: 12),
                    MateyaSkeletonBlock(width: 156, height: 36, radius: 18),
                    SizedBox(height: 8),
                    MateyaSkeletonBlock(width: 156, height: 36, radius: 18),
                    SizedBox(height: 8),
                    MateyaSkeletonBlock(
                      width: double.infinity,
                      height: 72,
                      radius: 18,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
