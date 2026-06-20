import 'package:flutter/material.dart';

import '../../../../shared/localization/mateya_localizations.dart';
import '../../../../shared/theme/app_tokens.dart';
import '../../domain/activity_detail_models.dart';
import 'activity_detail_formatters.dart';
import 'activity_detail_primitives.dart';

class RatingSummaryPanel extends StatelessWidget {
  const RatingSummaryPanel({super.key, required this.summary});

  final ReviewSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                summary.averageRating.toStringAsFixed(1),
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(fontSize: 30),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.star_rounded,
                size: 22,
                color: AppColors.textPrimary,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            l10n.detailsReviewRatingSummary(summary.totalCount),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 22),
          Column(
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
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: ratio,
                          minHeight: 6,
                          backgroundColor: AppColors.divider,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.brandGreen,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
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
    final l10n = context.l10n;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AvatarCircle(
                imageUrl: review.authorAvatarUrl,
                size: 48,
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
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatReviewDate(review.submittedAt),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: <Widget>[
                        const Icon(
                          Icons.star_rounded,
                          size: 18,
                          color: AppColors.textPrimary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.detailsReviewRating(review.rating),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: onHelpfulTap,
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.fieldBorderLight),
                  ),
                  child: Icon(
                    review.isHelpfulByMe
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: review.isHelpfulByMe
                        ? AppColors.brandGreen
                        : AppColors.textPrimary,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review.visibleBody,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(height: 1.55),
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
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Text(
                l10n.detailsReviewHelpfulCount(review.helpfulCount),
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.brandGreen),
              ),
              const Spacer(),
              if (onTranslationTap != null)
                TextButton(
                  onPressed: onTranslationTap,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.brandGreen,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    review.isTranslationVisible
                        ? l10n.detailsReviewViewOriginal
                        : l10n.detailsReviewViewTranslation,
                  ),
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
    final l10n = context.l10n;
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
              index == 0 ? l10n.detailsRepresentativeImage : '${index + 1}',
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
