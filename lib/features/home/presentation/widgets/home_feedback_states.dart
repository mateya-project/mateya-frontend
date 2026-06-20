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
          MateyaSkeletonBlock(height: 32, width: 148, radius: 16),
          SizedBox(height: 16),
          _FeaturedActivityCardSkeleton(),
          SizedBox(height: 28),
          MateyaSkeletonBlock(height: 32, width: 188, radius: 16),
          SizedBox(height: 23),
          _VerticalActivityCardSkeleton(),
          SizedBox(height: 32),
          _VerticalActivityCardSkeleton(),
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
          _CompactActivityRowSkeleton(),
          _ExploreSkeletonDivider(),
          _CompactActivityRowSkeleton(),
          _ExploreSkeletonDivider(),
          _CompactActivityRowSkeleton(),
          _ExploreSkeletonDivider(),
          _CompactActivityRowSkeleton(),
        ],
      ),
    );
  }
}

class _FeaturedActivityCardSkeleton extends StatelessWidget {
  const _FeaturedActivityCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const <Widget>[
        MateyaSkeletonBlock(height: 338, radius: 14),
        SizedBox(height: 18),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MateyaSkeletonBlock(height: 24, width: 212, radius: 12),
                  SizedBox(height: 8),
                  MateyaSkeletonBlock(height: 16, width: 160, radius: 8),
                  SizedBox(height: 6),
                  MateyaSkeletonBlock(height: 16, width: 192, radius: 8),
                  SizedBox(height: 12),
                  MateyaSkeletonBlock(height: 18, width: 84, radius: 9),
                ],
              ),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                MateyaSkeletonBlock(height: 20, width: 54, radius: 10),
                SizedBox(height: 68),
                MateyaSkeletonBlock(height: 18, width: 62, radius: 9),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _VerticalActivityCardSkeleton extends StatelessWidget {
  const _VerticalActivityCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MateyaSkeletonBlock(height: 236, radius: 13),
          Padding(
            padding: EdgeInsets.fromLTRB(13, 9, 13, 11),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      MateyaSkeletonBlock(height: 20, width: 206, radius: 10),
                      SizedBox(height: 8),
                      MateyaSkeletonBlock(height: 16, width: 188, radius: 8),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    MateyaSkeletonBlock(height: 20, width: 52, radius: 10),
                    SizedBox(height: 24),
                    MateyaSkeletonBlock(height: 18, width: 58, radius: 9),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactActivityRowSkeleton extends StatelessWidget {
  const _CompactActivityRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        MateyaSkeletonBlock(width: 110, height: 110, radius: 6),
        SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 4, bottom: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                MateyaSkeletonBlock(height: 18, width: 156, radius: 9),
                SizedBox(height: 10),
                MateyaSkeletonBlock(height: 16, width: 180, radius: 8),
                SizedBox(height: 8),
                MateyaSkeletonBlock(height: 16, width: 152, radius: 8),
                SizedBox(height: 12),
                MateyaSkeletonBlock(height: 14, width: 92, radius: 7),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ExploreSkeletonDivider extends StatelessWidget {
  const _ExploreSkeletonDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Divider(height: 1, color: AppColors.divider),
    );
  }
}
