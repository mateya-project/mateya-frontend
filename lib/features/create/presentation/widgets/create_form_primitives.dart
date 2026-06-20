import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../shared/localization/mateya_localizations.dart';
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
    final l10n = context.l10n;

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
                Text(
                  l10n.createCapacityValue(value),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.createCapacityHelper,
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

class CreateImageSlotTile extends StatelessWidget {
  const CreateImageSlotTile({
    super.key,
    required this.image,
    required this.index,
    required this.onRemove,
    this.onSetPrimary,
  });

  final CreateImageAsset image;
  final int index;
  final VoidCallback onRemove;
  final VoidCallback? onSetPrimary;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    final tile = Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              border: Border.all(
                color: image.isPrimary
                    ? AppColors.brandGreen
                    : AppColors.fieldBorderLight,
                width: image.isPrimary ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image(
              image: image.isRemote
                  ? NetworkImage(image.path)
                  : FileImage(File(image.path)) as ImageProvider,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const ColoredBox(
                  color: AppColors.subtleBackground,
                  child: Center(
                    child: Icon(
                      Icons.image_outlined,
                      color: AppColors.textSecondary,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Positioned(
          left: 8,
          top: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: image.isPrimary
                  ? AppColors.brandGreen
                  : Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              image.isPrimary ? l10n.createPrimaryImageBadge : '${index + 1}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
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

    if (onSetPrimary == null) {
      return tile;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onSetPrimary,
        borderRadius: BorderRadius.circular(16),
        child: tile,
      ),
    );
  }
}

class CreateImagePickerSlot extends StatelessWidget {
  const CreateImagePickerSlot({
    super.key,
    required this.countLabel,
    required this.onTap,
  });

  final String countLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _CreateDashedTile(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.add_photo_alternate_outlined,
            color: AppColors.textMuted,
            size: 28,
          ),
          const SizedBox(height: 6),
          Text(
            countLabel,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class CreateImageEmptySlot extends StatelessWidget {
  const CreateImageEmptySlot({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CreateDashedTile();
  }
}

class _CreateDashedTile extends StatelessWidget {
  const _CreateDashedTile({this.onTap, this.child});

  final VoidCallback? onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final tile = CustomPaint(
      painter: const _CreateDashedRoundedRectPainter(),
      child: Container(
        width: 92,
        height: 92,
        decoration: BoxDecoration(
          color: AppColors.subtleBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: child,
      ),
    );

    if (onTap == null) {
      return tile;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: tile,
      ),
    );
  }
}

class _CreateDashedRoundedRectPainter extends CustomPainter {
  const _CreateDashedRoundedRectPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const radius = Radius.circular(16);
    const dashWidth = 6.0;
    const dashGap = 4.0;

    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect.deflate(0.75), radius);
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..color = AppColors.fieldBorderLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = (distance + dashWidth)
            .clamp(0.0, metric.length)
            .toDouble();
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += dashWidth + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
