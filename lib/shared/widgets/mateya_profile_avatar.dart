import 'dart:io';

import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

class MateyaProfileAvatar extends StatelessWidget {
  const MateyaProfileAvatar({
    super.key,
    required this.size,
    this.imageUrl,
    this.borderColor,
    this.borderWidth = 0,
    this.backgroundColor = AppColors.subtleBackground,
    this.iconColor = AppColors.textSecondary,
    this.iconScale = 0.46,
  });

  final double size;
  final String? imageUrl;
  final Color? borderColor;
  final double borderWidth;
  final Color backgroundColor;
  final Color iconColor;
  final double iconScale;

  @override
  Widget build(BuildContext context) {
    final resolvedImageUrl = _normalizeImageUrl(imageUrl);
    final border = borderColor == null || borderWidth <= 0
        ? null
        : Border.all(color: borderColor!, width: borderWidth);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: border,
      ),
      clipBehavior: Clip.antiAlias,
      child: resolvedImageUrl == null
          ? _AvatarFallback(
              size: size,
              iconScale: iconScale,
              iconColor: iconColor,
            )
          : _AvatarImage(
              imageUrl: resolvedImageUrl,
              size: size,
              iconScale: iconScale,
              iconColor: iconColor,
            ),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback({
    required this.size,
    required this.iconScale,
    required this.iconColor,
  });

  final double size;
  final double iconScale;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.person_rounded, size: size * iconScale, color: iconColor);
  }
}

class _AvatarImage extends StatelessWidget {
  const _AvatarImage({
    required this.imageUrl,
    required this.size,
    required this.iconScale,
    required this.iconColor,
  });

  final String imageUrl;
  final double size;
  final double iconScale;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final fallback = _AvatarFallback(
      size: size,
      iconScale: iconScale,
      iconColor: iconColor,
    );
    return imageUrl.startsWith('/')
        ? Image.file(
            File(imageUrl),
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => fallback,
          )
        : Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => fallback,
            loadingBuilder: (context, child, progress) {
              if (progress == null) {
                return child;
              }
              return fallback;
            },
          );
  }
}

String? _normalizeImageUrl(String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) {
    return null;
  }
  return trimmed;
}
