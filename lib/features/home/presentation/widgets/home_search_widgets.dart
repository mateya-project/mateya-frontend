import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../shared/localization/mateya_localizations.dart';
import '../../../../shared/theme/app_tokens.dart';
import '../../application/home_controller.dart';
import '../../domain/home_models.dart';
import 'home_feedback_states.dart';

class HomeSearchBar extends StatefulWidget {
  const HomeSearchBar({
    super.key,
    this.controller,
    this.focusNode,
    required this.hintText,
    required this.helperText,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    required this.onFilterTap,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String hintText;
  final String helperText;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final VoidCallback onFilterTap;

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  late FocusNode _focusNode;
  late bool _ownsFocusNode;
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    _attachFocusNode(widget.focusNode);
    _attachController(widget.controller);
  }

  @override
  void didUpdateWidget(covariant HomeSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      _detachFocusNode();
      _attachFocusNode(widget.focusNode);
    }
    if (oldWidget.controller != widget.controller) {
      _detachController();
      _attachController(widget.controller);
    }
  }

  @override
  void dispose() {
    _detachFocusNode();
    _detachController();
    super.dispose();
  }

  void _attachFocusNode(FocusNode? focusNode) {
    _ownsFocusNode = focusNode == null;
    _focusNode = focusNode ?? FocusNode();
    _focusNode.addListener(_handleStateChanged);
  }

  void _detachFocusNode() {
    _focusNode.removeListener(_handleStateChanged);
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
  }

  void _attachController(TextEditingController? controller) {
    _controller = controller;
    _controller?.addListener(_handleStateChanged);
  }

  void _detachController() {
    _controller?.removeListener(_handleStateChanged);
    _controller = null;
  }

  void _handleStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final shouldHidePlaceholder =
        _focusNode.hasFocus || (widget.controller?.text.isNotEmpty ?? false);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 2,
            offset: Offset(0, 0),
          ),
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            child: Row(
              children: <Widget>[
                const Icon(
                  Icons.search_rounded,
                  color: AppColors.textSecondary,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: IgnorePointer(
                    ignoring: widget.readOnly,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextField(
                          controller: widget.controller,
                          focusNode: _focusNode,
                          readOnly: widget.readOnly,
                          onTap: widget.onTap,
                          onChanged: widget.onChanged,
                          decoration: InputDecoration(
                            isCollapsed: true,
                            border: InputBorder.none,
                            hintText: shouldHidePlaceholder
                                ? null
                                : widget.hintText,
                            hintStyle: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textPrimary),
                          ),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textPrimary),
                        ),
                        if (!shouldHidePlaceholder) ...<Widget>[
                          const SizedBox(height: 2),
                          Text(
                            widget.helperText,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: widget.onFilterTap,
                  icon: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.subtleBackground,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: const Icon(
                      Icons.tune_rounded,
                      color: AppColors.textPrimary,
                      size: 18,
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
}

class ExploreCategoryStrip extends StatelessWidget {
  const ExploreCategoryStrip({
    super.key,
    required this.categories,
    required this.selectedCategoryIds,
    required this.onSelectCategory,
  });

  final List<ActivityCategory> categories;
  final Set<String> selectedCategoryIds;
  final ValueChanged<String> onSelectCategory;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category.isAll
              ? selectedCategoryIds.contains('all')
              : selectedCategoryIds.contains(category.id);
          return ChoiceChip(
            label: Text(category.label),
            selected: isSelected,
            onSelected: (_) => onSelectCategory(category.id),
            showCheckmark: false,
            labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isSelected ? Colors.white : AppColors.textPrimary,
            ),
            selectedColor: AppColors.brandGreen,
            backgroundColor: Colors.white,
            side: BorderSide(
              color: isSelected ? AppColors.brandGreen : AppColors.divider,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          );
        },
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemCount: categories.length,
      ),
    );
  }
}

class ExploreResultsFooter extends StatelessWidget {
  const ExploreResultsFooter({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (controller.isLoadingMoreExplore) {
      return const Padding(
        padding: EdgeInsets.only(top: 8, bottom: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (controller.exploreLoadMoreErrorMessage != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        child: Column(
          children: <Widget>[
            InlineErrorText(message: controller.exploreLoadMoreErrorMessage!),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => unawaited(controller.loadMoreExplore()),
              child: Text(l10n.homeLoadMore),
            ),
          ],
        ),
      );
    }
    if (!controller.hasMoreExplore) {
      return Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        child: Text(
          l10n.homeLoadedAllActivities(controller.exploreActivities.length),
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      );
    }
    return const Padding(
      padding: EdgeInsets.only(bottom: 24),
      child: SizedBox.shrink(),
    );
  }
}
