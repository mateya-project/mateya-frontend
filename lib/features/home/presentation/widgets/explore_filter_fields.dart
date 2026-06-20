import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../shared/localization/mateya_localizations.dart';
import '../../../../shared/theme/app_tokens.dart';

class ExploreLanguageSupportNotice extends StatelessWidget {
  const ExploreLanguageSupportNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.homeUnsupportedExploreLanguageFilter,
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
    );
  }
}

class FilterSection extends StatelessWidget {
  const FilterSection({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class FilterChipButton extends StatelessWidget {
  const FilterChipButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.inverted = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool inverted;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = selected && !inverted
        ? AppColors.brandGreen
        : Colors.white;
    final borderColor = selected ? AppColors.brandGreen : AppColors.divider;
    final textColor = selected && !inverted
        ? Colors.white
        : AppColors.textPrimary;
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: borderColor),
        ),
        child: Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: textColor),
        ),
      ),
    );
  }
}

class CheckboxTag extends StatelessWidget {
  const CheckboxTag({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.enabled = true,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: selected && enabled ? AppColors.brandGreen : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: selected && enabled
                    ? AppColors.brandGreen
                    : enabled
                    ? AppColors.fieldBorderLight
                    : AppColors.divider,
              ),
            ),
            child: selected
                ? const Icon(Icons.check, size: 12, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: enabled ? AppColors.textPrimary : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class DateField extends StatelessWidget {
  const DateField({
    super.key,
    required this.label,
    required this.onTap,
    this.isPlaceholder = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isPlaceholder;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.fieldBorderLight),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isPlaceholder
                      ? AppColors.textMuted
                      : AppColors.textSecondary,
                ),
              ),
            ),
            const Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

class CompactNumberField extends StatelessWidget {
  const CompactNumberField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.fieldBorderLight),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: onChanged,
              decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                hintText: hintText,
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.fieldBorderLight,
                ),
              ),
            ),
          ),
          Text(
            '₩',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
