import 'package:flutter/material.dart';

import '../../../../shared/theme/app_tokens.dart';
import '../../../../shared/widgets/mateya_skeleton.dart';

class RetryState extends StatelessWidget {
  const RetryState({super.key, required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.wifi_tethering_error_rounded, size: 36),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.brandGreen,
              ),
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.travel_explore_rounded,
              size: 44,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 12),
            Text(
              '조건에 맞는 활동이 아직 없어요.',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              '검색어 또는 필터를 조정해서 다시 찾아보세요.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class InlineErrorText extends StatelessWidget {
  const InlineErrorText({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Icon(
          Icons.warning_amber_rounded,
          color: AppColors.error,
          size: 16,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            message,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.error),
          ),
        ),
      ],
    );
  }
}

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return MateyaSkeleton(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: const <Widget>[
          MateyaSkeletonBlock(height: 34, width: 168),
          SizedBox(height: 16),
          MateyaSkeletonBlock(height: 470),
          SizedBox(height: 24),
          MateyaSkeletonBlock(height: 34, width: 220),
          SizedBox(height: 23),
          MateyaSkeletonBlock(height: 336),
          SizedBox(height: 32),
          MateyaSkeletonBlock(height: 336),
        ],
      ),
    );
  }
}

class ExploreSkeleton extends StatelessWidget {
  const ExploreSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return MateyaSkeleton(
      child: ListView(
        padding: const EdgeInsets.only(top: 6, bottom: 16),
        children: const <Widget>[
          MateyaSkeletonBlock(height: 110),
          SizedBox(height: 24),
          MateyaSkeletonBlock(height: 110),
          SizedBox(height: 24),
          MateyaSkeletonBlock(height: 110),
          SizedBox(height: 24),
          MateyaSkeletonBlock(height: 110),
        ],
      ),
    );
  }
}
