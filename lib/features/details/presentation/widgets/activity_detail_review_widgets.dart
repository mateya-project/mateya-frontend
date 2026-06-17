import 'package:flutter/material.dart';

import '../../../../shared/theme/app_tokens.dart';
import '../../domain/activity_detail_models.dart';
import 'activity_detail_formatters.dart';
import 'activity_detail_primitives.dart';

class RatingSummaryPanel extends StatelessWidget {
  const RatingSummaryPanel({super.key, required this.summary});

  final ReviewSummary summary;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 86,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  summary.averageRating.toStringAsFixed(2),
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(fontSize: 30),
                ),
                const SizedBox(height: 6),
                Row(
                  children: List<Widget>.generate(
                    5,
                    (_) => const Icon(
                      Icons.star_rounded,
                      size: 18,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '총 ${summary.totalCount}개 후기',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              children: List<Widget>.generate(5, (index) {
                final star = 5 - index;
                final count = summary.ratingCounts[star] ?? 0;
                final ratio = summary.totalCount == 0
                    ? 0.0
                    : count / summary.totalCount;
                return Padding(
                  padding: EdgeInsets.only(bottom: index == 4 ? 0 : 10),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 18,
                        child: Text(
                          '$star',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            value: ratio,
                            minHeight: 8,
                            backgroundColor: AppColors.subtleBackground,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.brandGreen,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 20,
                        child: Text(
                          '$count',
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  const ReviewCard({
    super.key,
    required this.review,
    required this.onHelpfulTap,
    required this.onTranslationTap,
  });

  final ActivityReview review;
  final VoidCallback onHelpfulTap;
  final VoidCallback? onTranslationTap;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              AvatarCircle(
                imageUrl: review.authorAvatarUrl,
                size: 42,
                initials: review.authorName.isNotEmpty
                    ? review.authorName.substring(0, 1)
                    : 'U',
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      review.authorName,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatReviewDate(review.submittedAt),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  const Icon(
                    Icons.star_rounded,
                    size: 18,
                    color: AppColors.textPrimary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${review.rating}점',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            review.visibleBody,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(height: 1.6),
          ),
          if (review.imageUrls.isNotEmpty) ...<Widget>[
            const SizedBox(height: 14),
            SizedBox(
              height: 84,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 84,
                    child: NetworkOrFileImage(
                      imageUrl: review.imageUrls[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemCount: review.imageUrls.length,
              ),
            ),
          ],
          const SizedBox(height: 14),
          Row(
            children: <Widget>[
              InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: onHelpfulTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 2,
                    vertical: 4,
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        review.isHelpfulByMe
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 18,
                        color: review.isHelpfulByMe
                            ? AppColors.brandGreen
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '도움이 돼요',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: review.isHelpfulByMe
                              ? AppColors.brandGreen
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${review.helpfulCount}명에게 도움이 됨',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Spacer(),
              if (onTranslationTap != null)
                TextButton(
                  onPressed: onTranslationTap,
                  child: Text(review.isTranslationVisible ? '원문보기' : '번역보기'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class ReviewImageTile extends StatelessWidget {
  const ReviewImageTile({
    super.key,
    required this.imagePath,
    required this.index,
    required this.onRemove,
  });

  final String imagePath;
  final int index;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            width: 92,
            height: 92,
            child: NetworkOrFileImage(imageUrl: imagePath, fit: BoxFit.cover),
          ),
        ),
        Positioned(
          left: 8,
          top: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              index == 0 ? '대표' : '${index + 1}',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.white),
            ),
          ),
        ),
        if (onRemove != null)
          Positioned(
            right: 6,
            top: 6,
            child: InkWell(
              onTap: onRemove,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.58),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
