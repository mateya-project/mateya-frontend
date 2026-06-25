import 'package:flutter/material.dart';

import '../../../../shared/localization/mateya_localizations.dart';
import '../../../../shared/theme/app_tokens.dart';
import '../../../../shared/widgets/mateya_profile_avatar.dart';
import '../../domain/mypage_models.dart';

class MyPageActivityHistoryCard extends StatelessWidget {
  const MyPageActivityHistoryCard({
    super.key,
    required this.activity,
    this.onTap,
  });

  final ActivityHistoryEntry activity;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 176,
                    child: Image.network(
                      activity.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.subtleBackground,
                          child: const Center(
                            child: Icon(
                              Icons.image_outlined,
                              size: 34,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  top: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      activity.categoryLabel,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                if (activity.isHostedByMe)
                  Positioned(
                    right: 12,
                    top: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.brandGreen,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        onTap == null ? l10n.mypageHostBadge : l10n.commonEdit,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                if (onTap != null)
                  Positioned(
                    right: 14,
                    bottom: 12,
                    child: Row(
                      children: <Widget>[
                        Text(
                          l10n.mypageEditActivityCta,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    activity.title,
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: <Widget>[
                      MyPageMetaPill(
                        icon: Icons.calendar_today_rounded,
                        text: activity.dateLabel,
                      ),
                      MyPageMetaPill(
                        icon: Icons.schedule_rounded,
                        text: activity.timeLabel,
                      ),
                      MyPageMetaPill(
                        icon: Icons.group_outlined,
                        text: activity.participantLabel,
                      ),
                      MyPageMetaPill(
                        icon: Icons.payments_outlined,
                        text: activity.priceLabel,
                      ),
                    ],
                  ),
                  if (activity.rating != null) ...<Widget>[
                    const SizedBox(height: 12),
                    Row(
                      children: <Widget>[
                        const Icon(
                          Icons.star_rounded,
                          size: 18,
                          color: Color(0xFFFFC107),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          activity.rating!.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyPageSelectionField extends StatelessWidget {
  const MyPageSelectionField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String? value;
  final List<SelectionOption> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          key: ValueKey<String?>('$label-$value'),
          initialValue: value,
          isExpanded: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.inputBackground,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.fieldRadius),
              borderSide: const BorderSide(color: AppColors.fieldBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.fieldRadius),
              borderSide: const BorderSide(color: AppColors.textPrimary),
            ),
          ),
          items: items
              .map(
                (option) => DropdownMenuItem<String>(
                  value: option.code,
                  child: Text(option.label),
                ),
              )
              .toList(growable: false),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class MyPageSectionCard extends StatelessWidget {
  const MyPageSectionCard({
    super.key,
    required this.child,
    this.backgroundColor = Colors.white,
  });

  final Widget child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: AppColors.divider),
      boxShadow: const <BoxShadow>[
        BoxShadow(
          color: Color(0x08000000),
          blurRadius: 18,
          offset: Offset(0, 10),
        ),
      ],
    );

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: decoration,
        child: Padding(padding: const EdgeInsets.all(16), child: child),
      ),
    );
  }
}

class MyPageActionTile extends StatelessWidget {
  const MyPageActionTile({super.key, required this.item});

  final MyPageActionItem item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: item.onTap,
      child: Row(
        children: <Widget>[
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: item.isDanger
                  ? AppColors.error.withValues(alpha: 0.08)
                  : AppColors.subtleBackground,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              item.icon,
              color: item.isDanger ? AppColors.error : AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: item.isDanger ? AppColors.error : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

class MyPageMetaPill extends StatelessWidget {
  const MyPageMetaPill({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.subtleBackground,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(text, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class MyPageAvatarImage extends StatelessWidget {
  const MyPageAvatarImage({
    super.key,
    required this.imageUrl,
    required this.size,
  });

  final String? imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    return MateyaProfileAvatar(imageUrl: imageUrl, size: size, iconScale: 0.52);
  }
}

class MyPageActionItem {
  const MyPageActionItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDanger = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDanger;
}
