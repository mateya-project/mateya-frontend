import 'package:flutter/material.dart';

import '../../../../shared/theme/app_tokens.dart';

class ActivityImage extends StatelessWidget {
  const ActivityImage({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.aspectRatio,
    required this.borderRadius,
  });

  final String? imageUrl;
  final double? width;
  final double? height;
  final double? aspectRatio;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    assert(
      height != null || aspectRatio != null,
      'Either height or aspectRatio must be provided.',
    );

    final fallback = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFFB8E8B2), Color(0xFFE9F7EE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(Icons.image_outlined, color: Colors.white, size: 34),
      ),
    );

    final imageChild = imageUrl == null
        ? fallback
        : ClipRRect(
            borderRadius: borderRadius,
            child: Image.network(
              imageUrl!,
              width: width,
              height: height,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => fallback,
              loadingBuilder: (context, child, progress) {
                if (progress == null) {
                  return child;
                }
                return fallback;
              },
            ),
          );

    if (aspectRatio != null) {
      return AspectRatio(aspectRatio: aspectRatio!, child: imageChild);
    }

    return imageChild;
  }
}

class RatingLabel extends StatelessWidget {
  const RatingLabel({super.key, required this.rating, this.compact = false});

  final double rating;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final style = compact
        ? Theme.of(context).textTheme.bodyMedium
        : Theme.of(context).textTheme.bodyLarge;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Icon(Icons.star_rounded, color: AppColors.textPrimary, size: 18),
        const SizedBox(width: 4),
        Text(rating.toStringAsFixed(2), style: style),
      ],
    );
  }
}

class ParticipantLabel extends StatelessWidget {
  const ParticipantLabel({
    super.key,
    required this.current,
    required this.capacity,
    this.compact = false,
  });

  final int current;
  final int capacity;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final style = compact
        ? Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.brandGreen)
        : Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppColors.brandGreen);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          Icons.groups_2_outlined,
          color: AppColors.brandGreen,
          size: compact ? 18 : 20,
        ),
        const SizedBox(width: 4),
        Text('$current/$capacity 참여', style: style),
      ],
    );
  }
}

class CategoryBadge extends StatelessWidget {
  const CategoryBadge({
    super.key,
    required this.label,
    this.filled = false,
    this.small = false,
    this.compactOutline = false,
  });

  final String label;
  final bool filled;
  final bool small;
  final bool compactOutline;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = filled ? AppColors.brandGreen : Colors.white;
    final borderColor = compactOutline
        ? AppColors.softGreenBorder
        : filled
        ? AppColors.brandGreen
        : AppColors.divider;
    final textColor = filled ? Colors.white : AppColors.textPrimary;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compactOutline || small ? 8 : 12,
        vertical: small ? 4 : 8,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class DotDivider extends StatelessWidget {
  const DotDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3,
      height: 3,
      decoration: const BoxDecoration(
        color: AppColors.textMuted,
        shape: BoxShape.circle,
      ),
    );
  }
}
