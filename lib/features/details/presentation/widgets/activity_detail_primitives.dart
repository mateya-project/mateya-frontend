import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../shared/widgets/mateya_profile_avatar.dart';
import '../../../../shared/theme/app_tokens.dart';
import '../../domain/activity_detail_models.dart';

class ParticipantAvatarRow extends StatelessWidget {
  const ParticipantAvatarRow({
    super.key,
    required this.participants,
    required this.onParticipantTap,
  });

  final List<ActivityParticipant> participants;
  final Future<void> Function(String userId) onParticipantTap;

  @override
  Widget build(BuildContext context) {
    final visible = participants.take(8).toList(growable: false);
    final remaining = participants.length - visible.length;

    return SizedBox(
      height: 40,
      child: Stack(
        children: <Widget>[
          for (var index = 0; index < visible.length; index += 1)
            Positioned(
              left: index * 26,
              child: InkWell(
                onTap: () => onParticipantTap(visible[index].id),
                borderRadius: BorderRadius.circular(999),
                child: AvatarCircle(
                  imageUrl: visible[index].avatarUrl,
                  size: 40,
                  initials: visible[index].name.substring(0, 1),
                  borderColor: Colors.white,
                ),
              ),
            ),
          if (remaining > 0)
            Positioned(
              left: visible.length * 26,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.darkButton,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                alignment: Alignment.center,
                child: Text(
                  '+$remaining',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class AvatarCircle extends StatelessWidget {
  const AvatarCircle({
    super.key,
    required this.imageUrl,
    required this.size,
    required this.initials,
    this.borderColor,
  });

  final String? imageUrl;
  final double size;
  final String initials;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return MateyaProfileAvatar(
      imageUrl: imageUrl,
      size: size,
      borderColor: borderColor,
      borderWidth: borderColor == null ? 0 : 2,
    );
  }
}

class NetworkOrFileImage extends StatelessWidget {
  const NetworkOrFileImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
  });

  final String imageUrl;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final fallback = DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[Color(0xFFB8E8B2), Color(0xFFE9F7EE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(Icons.image_outlined, color: Colors.white, size: 28),
      ),
    );

    if (imageUrl.startsWith('/')) {
      return Image.file(
        File(imageUrl),
        fit: fit,
        errorBuilder: (_, _, _) => fallback,
      );
    }

    return Image.network(
      imageUrl,
      fit: fit,
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

class HeroCircleButton extends StatelessWidget {
  const HeroCircleButton({super.key, required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 24,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.36),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}

class BottomGlyphButton extends StatelessWidget {
  const BottomGlyphButton({super.key, required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 24,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: AppColors.subtleBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
        ),
        child: Icon(icon, color: AppColors.textPrimary),
      ),
    );
  }
}

class InfoLine extends StatelessWidget {
  const InfoLine({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, size: 18, color: AppColors.textPrimary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(height: 1.4),
          ),
        ),
      ],
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.compact = false});

  final String title;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: compact
          ? Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 19)
          : Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 24),
    );
  }
}

class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      padding: padding,
      child: child,
    );
  }
}

class CategoryPill extends StatelessWidget {
  const CategoryPill({super.key, required this.label, this.filled = false});

  final String label;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: filled ? AppColors.brandGreen : Colors.white,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: filled ? Colors.white : AppColors.textPrimary,
        ),
      ),
    );
  }
}
