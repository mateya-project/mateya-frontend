import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../shared/theme/app_tokens.dart';
import '../../domain/create_models.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key, required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.subtleBackground,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(body, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class CapacityStepper extends StatelessWidget {
  const CapacityStepper({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Row(
        children: <Widget>[
          CircleIconButton(
            icon: Icons.remove_rounded,
            onTap: value <= 2 ? null : () => onChanged(value - 1),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Text('$value명', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(
                  '최소 2명, 최대 20명',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          CircleIconButton(
            icon: Icons.add_rounded,
            onTap: value >= 20 ? null : () => onChanged(value + 1),
          ),
        ],
      ),
    );
  }
}

class CircleIconButton extends StatelessWidget {
  const CircleIconButton({super.key, required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: disabled
              ? AppColors.disabledSurface
              : AppColors.subtleBackground,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: disabled ? AppColors.disabledText : AppColors.textPrimary,
        ),
      ),
    );
  }
}

class ImageTile extends StatelessWidget {
  const ImageTile({
    super.key,
    required this.image,
    required this.onRemove,
    required this.onSetPrimary,
  });

  final CreateImageAsset image;
  final VoidCallback onRemove;
  final VoidCallback onSetPrimary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 144,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: image.isPrimary ? AppColors.brandGreen : AppColors.divider,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Stack(
              children: <Widget>[
                Image(
                  image: image.isRemote
                      ? NetworkImage(image.path)
                      : FileImage(File(image.path)) as ImageProvider,
                  width: 144,
                  height: 112,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 144,
                      height: 112,
                      color: AppColors.subtleBackground,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.image_outlined,
                        color: AppColors.textSecondary,
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: image.isPrimary
                          ? AppColors.brandGreen
                          : Colors.black.withValues(alpha: 0.56),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      image.isPrimary ? '대표' : '이미지',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: Material(
                    color: Colors.black.withValues(alpha: 0.42),
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: onRemove,
                      customBorder: const CircleBorder(),
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  image.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: image.isPrimary ? null : onSetPrimary,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(36),
                      side: BorderSide(
                        color: image.isPrimary
                            ? AppColors.disabledButton
                            : AppColors.fieldBorderLight,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(image.isPrimary ? '대표 사진' : '대표로 지정'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
