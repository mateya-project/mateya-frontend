import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

import '../../../../shared/theme/app_tokens.dart';
import '../../domain/onboarding_flow.dart';

class NeighborhoodMapCard extends StatelessWidget {
  const NeighborhoodMapCard({
    super.key,
    required this.selection,
    required this.isLoading,
  });

  final NeighborhoodSelection? selection;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final target = selection != null
        ? NLatLng(selection!.latitude, selection!.longitude)
        : const NLatLng(37.5666, 126.9790);

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: double.infinity,
        height: 280,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            NaverMap(
              key: ValueKey<String>(
                selection == null
                    ? 'default-map'
                    : '${selection!.latitude}-${selection!.longitude}',
              ),
              options: NaverMapViewOptions(
                initialCameraPosition: NCameraPosition(
                  target: target,
                  zoom: 15,
                ),
              ),
              onMapReady: (mapController) async {
                if (selection != null) {
                  await mapController.addOverlay(
                    NMarker(id: 'selected-neighborhood', position: target),
                  );
                }
              },
            ),
            if (isLoading)
              Container(
                color: Colors.white.withValues(alpha: 0.72),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}

class AgreementRow extends StatelessWidget {
  const AgreementRow({
    super.key,
    required this.label,
    required this.selected,
    required this.onChanged,
    this.emphasized = false,
    this.helperText,
    this.onDetailTap,
    this.checkboxKey,
    this.detailKey,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onChanged;
  final bool emphasized;
  final String? helperText;
  final VoidCallback? onDetailTap;
  final Key? checkboxKey;
  final Key? detailKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final detailTap = onDetailTap ?? () => onChanged(!selected);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Semantics(
          checked: selected,
          label: '$label 동의',
          child: InkWell(
            key: checkboxKey,
            onTap: () => onChanged(!selected),
            borderRadius: BorderRadius.circular(6),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: selected ? AppColors.brandGreen : Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: selected
                      ? AppColors.brandGreen
                      : const Color(0xFF58616A),
                ),
              ),
              child: selected
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 18,
                    )
                  : null,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: InkWell(
            key: detailKey,
            onTap: emphasized ? () => onChanged(!selected) : detailTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    label,
                    style:
                        (emphasized
                                ? theme.textTheme.titleLarge
                                : theme.textTheme.bodyMedium)
                            ?.copyWith(
                              fontSize: emphasized ? 20 : 14,
                              fontWeight: emphasized
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                  ),
                  if (helperText != null) ...<Widget>[
                    const SizedBox(height: 4),
                    Text(helperText!, style: theme.textTheme.bodySmall),
                  ],
                ],
              ),
            ),
          ),
        ),
        if (!emphasized)
          IconButton(
            onPressed: detailTap,
            splashRadius: 18,
            icon: const Icon(
              Icons.chevron_right_rounded,
              size: 24,
              color: Color(0xFF5A5F66),
            ),
          ),
      ],
    );
  }
}

class SelectableField extends StatelessWidget {
  const SelectableField({
    super.key,
    required this.value,
    required this.onTap,
    this.placeholder,
    this.errorText,
  });

  final String value;
  final String? placeholder;
  final VoidCallback onTap;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasValue = value.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.fieldRadius),
          child: Container(
            height: AppSpacing.inputHeight,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.fieldRadius),
              border: Border.all(
                color: errorText == null
                    ? AppColors.fieldBorder
                    : AppColors.error,
              ),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    hasValue ? value : (placeholder ?? ''),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: hasValue
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down_rounded),
              ],
            ),
          ),
        ),
        if (errorText != null) ...<Widget>[
          const SizedBox(height: 8),
          Text(
            errorText!,
            style: theme.textTheme.bodySmall?.copyWith(color: AppColors.error),
          ),
        ],
      ],
    );
  }
}

class SinglePreviewField extends StatelessWidget {
  const SinglePreviewField({
    super.key,
    required this.hintText,
    this.hasFocusStyle = false,
  });

  final String hintText;
  final bool hasFocusStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasFocusStyle ? AppColors.textPrimary : AppColors.fieldBorder,
        ),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      alignment: Alignment.centerLeft,
      child: Text(
        hintText,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: hintText.isEmpty
              ? AppColors.textPrimary
              : AppColors.textSecondary,
        ),
      ),
    );
  }
}

class BusinessNumberPreview extends StatelessWidget {
  const BusinessNumberPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('사업자 번호', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 21),
        Row(
          children: const <Widget>[
            Expanded(child: SinglePreviewField(hintText: '111')),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text('-'),
            ),
            Expanded(child: SinglePreviewField(hintText: '11')),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text('-'),
            ),
            Expanded(flex: 2, child: SinglePreviewField(hintText: '11111')),
          ],
        ),
      ],
    );
  }
}
