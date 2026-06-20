import 'package:flutter/material.dart';

import '../../../../shared/localization/mateya_localizations.dart';
import '../../../../shared/theme/app_tokens.dart';
import '../../domain/home_models.dart';
import 'explore_filter_fields.dart';
import 'home_formatters.dart';

class ExploreFilterSheet extends StatefulWidget {
  const ExploreFilterSheet({
    super.key,
    required this.categories,
    required this.initialFilter,
    required this.defaultFilter,
    required this.validator,
    this.activityRegionName,
  });

  final List<ActivityCategory> categories;
  final ExploreFilter initialFilter;
  final ExploreFilter defaultFilter;
  final String? Function(ExploreFilter filter) validator;
  final String? activityRegionName;

  @override
  State<ExploreFilterSheet> createState() => _ExploreFilterSheetState();
}

class _ExploreFilterSheetState extends State<ExploreFilterSheet> {
  late ExploreFilter _draft;
  late final TextEditingController _minPriceController;
  late final TextEditingController _maxPriceController;
  String? _validationMessage;

  @override
  void initState() {
    super.initState();
    _draft = widget.initialFilter;
    _minPriceController = TextEditingController(
      text: _draft.minPrice?.toString() ?? '',
    );
    _maxPriceController = TextEditingController(
      text: _draft.maxPrice?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final viewInsets = MediaQuery.of(context).viewInsets;

    return Container(
      color: const Color(0x80000000),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          l10n.homeFilterTitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: AppColors.divider),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      16,
                      20,
                      20 + viewInsets.bottom,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FilterSection(
                          title: l10n.homeFilterSort,
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: ActivitySortOption.values.map((option) {
                              return FilterChipButton(
                                label: option.label,
                                selected: _draft.sort == option,
                                onTap: () {
                                  setState(() {
                                    _draft = _draft.copyWith(sort: option);
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                        FilterSection(
                          title: l10n.homeFilterCategory,
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: widget.categories.map((category) {
                              final selected = category.isAll
                                  ? _draft.categoryIds.contains('all')
                                  : _draft.categoryIds.contains(category.id);
                              return FilterChipButton(
                                label: category.label,
                                selected: selected,
                                onTap: () => _toggleCategory(category),
                              );
                            }).toList(),
                          ),
                        ),
                        FilterSection(
                          title: l10n.homeFilterAudience,
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: ActivityAudienceOption.values.map((
                              option,
                            ) {
                              return FilterChipButton(
                                label: option.label,
                                selected: _draft.audiences.contains(option),
                                inverted: true,
                                onTap: () => _toggleAudience(option),
                              );
                            }).toList(),
                          ),
                        ),
                        FilterSection(
                          title: l10n.homeFilterLanguage,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Wrap(
                                spacing: 12,
                                runSpacing: 8,
                                children: kPrimaryLanguages.map((language) {
                                  final supported =
                                      kSupportedExploreLanguageCodes.contains(
                                        language.code,
                                      );
                                  return CheckboxTag(
                                    label: language.label,
                                    selected: _draft.languages.contains(
                                      language.code,
                                    ),
                                    enabled: supported,
                                    onTap: () => _toggleLanguage(language.code),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 8),
                              const ExploreLanguageSupportNotice(),
                            ],
                          ),
                        ),
                        FilterSection(
                          title: l10n.homeFilterRegion,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                _buildDistanceSummary(),
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      decoration: TextDecoration.underline,
                                    ),
                              ),
                              const SizedBox(height: 12),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: AppColors.brandGreen,
                                  inactiveTrackColor:
                                      AppColors.subtleBackground,
                                  thumbColor: Colors.white,
                                  overlayColor: AppColors.brandGreen.withValues(
                                    alpha: 0.12,
                                  ),
                                ),
                                child: Slider(
                                  value: _draft.distance.index.toDouble(),
                                  divisions:
                                      DistanceRangeOption.values.length - 1,
                                  max: (DistanceRangeOption.values.length - 1)
                                      .toDouble(),
                                  min: 0,
                                  onChanged: (value) {
                                    setState(() {
                                      _draft = _draft.copyWith(
                                        distance: DistanceRangeOption
                                            .values[value.round()],
                                      );
                                    });
                                  },
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    l10n.homeFilterNear,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                  const Spacer(),
                                  Text(
                                    l10n.homeFilterFar,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        FilterSection(
                          title: l10n.homeFilterSchedule,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: DateField(
                                  label: _draft.startDate == null
                                      ? l10n.homeFilterStartDate
                                      : formatIsoDate(_draft.startDate!),
                                  isPlaceholder: _draft.startDate == null,
                                  onTap: () async {
                                    final selected = await _pickDate(
                                      _draft.startDate,
                                    );
                                    if (selected != null) {
                                      setState(() {
                                        _draft = _draft.copyWith(
                                          startDate: selected,
                                        );
                                      });
                                    }
                                  },
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Text('-'),
                              ),
                              Expanded(
                                child: DateField(
                                  label: _draft.endDate == null
                                      ? l10n.homeFilterEndDate
                                      : formatIsoDate(_draft.endDate!),
                                  isPlaceholder: _draft.endDate == null,
                                  onTap: () async {
                                    final selected = await _pickDate(
                                      _draft.endDate,
                                    );
                                    if (selected != null) {
                                      setState(() {
                                        _draft = _draft.copyWith(
                                          endDate: selected,
                                        );
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        FilterSection(
                          title: l10n.homeFilterCost,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: CompactNumberField(
                                  controller: _minPriceController,
                                  hintText: l10n.homeFilterMinPrice,
                                  onChanged: (_) => _syncPriceDraft(),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Text('-'),
                              ),
                              Expanded(
                                child: CompactNumberField(
                                  controller: _maxPriceController,
                                  hintText: l10n.homeFilterMaxPrice,
                                  onChanged: (_) => _syncPriceDraft(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        FilterSection(
                          title: l10n.homeFilterStatus,
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: ActivityStatusOption.values.map((status) {
                              return FilterChipButton(
                                label: status.label,
                                selected: _draft.statuses.contains(status),
                                inverted: true,
                                onTap: () {
                                  final next = Set<ActivityStatusOption>.from(
                                    _draft.statuses,
                                  );
                                  if (!next.add(status)) {
                                    next.remove(status);
                                  }
                                  setState(() {
                                    _draft = _draft.copyWith(statuses: next);
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                        if (_validationMessage != null) ...<Widget>[
                          Text(
                            _validationMessage!,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.error),
                          ),
                          const SizedBox(height: 12),
                        ],
                        Row(
                          children: <Widget>[
                            TextButton(
                              onPressed: _resetDraft,
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.textPrimary,
                                minimumSize: const Size(0, 44),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                l10n.commonReset,
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: 148,
                              height: 44,
                              child: FilledButton(
                                onPressed: _applyAndClose,
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.brandGreen,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(l10n.commonApply),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<DateTime?> _pickDate(DateTime? initialDate) {
    return showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime(2026, 6, 4),
      firstDate: DateTime(2025),
      lastDate: DateTime(2027, 12, 31),
    );
  }

  void _toggleCategory(ActivityCategory category) {
    final next = Set<String>.from(_draft.categoryIds);
    if (category.isAll) {
      setState(() {
        _draft = _draft.copyWith(categoryIds: <String>{'all'});
      });
      return;
    }

    next.remove('all');
    if (!next.add(category.id)) {
      next.remove(category.id);
    }
    if (next.isEmpty) {
      next.add('all');
    }
    setState(() {
      _draft = _draft.copyWith(categoryIds: next);
    });
  }

  void _toggleAudience(ActivityAudienceOption option) {
    final next = Set<ActivityAudienceOption>.from(_draft.audiences);
    if (!next.add(option)) {
      next.remove(option);
    }
    if (next.isEmpty) {
      next.add(ActivityAudienceOption.everyone);
    }
    setState(() {
      _draft = _draft.copyWith(audiences: next);
    });
  }

  void _toggleLanguage(String code) {
    final next = Set<String>.from(_draft.languages);
    if (!next.add(code)) {
      next.remove(code);
    }
    setState(() {
      _draft = _draft.copyWith(languages: next);
    });
  }

  void _syncPriceDraft() {
    setState(() {
      _draft = _draft.copyWith(
        minPrice: _parseNumber(_minPriceController.text),
        maxPrice: _parseNumber(_maxPriceController.text),
      );
    });
  }

  void _resetDraft() {
    setState(() {
      _draft = widget.defaultFilter;
      _validationMessage = null;
      _minPriceController.text =
          widget.defaultFilter.minPrice?.toString() ?? '';
      _maxPriceController.text =
          widget.defaultFilter.maxPrice?.toString() ?? '';
    });
  }

  void _applyAndClose() {
    final message = widget.validator(_draft);
    if (message != null) {
      setState(() {
        _validationMessage = message;
      });
      return;
    }
    Navigator.of(context).pop(_draft);
  }

  int? _parseNumber(String value) {
    final normalized = value.replaceAll(',', '').trim();
    if (normalized.isEmpty) {
      return null;
    }
    return int.tryParse(normalized);
  }

  String _buildDistanceSummary() {
    final l10n = context.l10n;
    final regionName = widget.activityRegionName?.trim();
    final targetLabel = switch (_draft.distance) {
      DistanceRangeOption.local => l10n.homeDistanceLocal,
      DistanceRangeOption.within1km => l10n.homeDistanceWithin1km,
      DistanceRangeOption.within5km => l10n.homeDistanceWithin5km,
      DistanceRangeOption.within10km => l10n.homeDistanceWithin10km,
    };

    if (regionName == null || regionName.isEmpty) {
      return l10n.homeFilterDistanceFromActivityRegion(targetLabel);
    }
    return l10n.homeFilterDistanceFromRegion(regionName, targetLabel);
  }
}
