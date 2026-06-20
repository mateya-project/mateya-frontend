import 'package:flutter/material.dart';

import '../../../../shared/localization/mateya_localizations.dart';
import '../../../../shared/theme/app_tokens.dart';
import '../../../../shared/widgets/mateya_button.dart';
import '../../../../shared/widgets/mateya_header.dart';
import '../../application/create_controller.dart';
import '../../domain/create_models.dart';
import 'create_form_fields.dart';
import 'create_form_primitives.dart';
import 'create_formatters.dart';

class CreateFlowHeader extends StatelessWidget {
  const CreateFlowHeader({
    super.key,
    required this.title,
    required this.progressLabel,
    required this.onBack,
  });

  final String title;
  final String progressLabel;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded),
            color: AppColors.textPrimary,
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  progressLabel,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class CreateFlowProgressHeader extends StatelessWidget {
  const CreateFlowProgressHeader({
    super.key,
    required this.flowType,
    required this.steps,
    required this.currentStep,
    required this.onBack,
  });

  final CreateFlowType flowType;
  final List<CreateStep> steps;
  final CreateStep currentStep;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        MateyaHeader.backArrow(onBack: onBack),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          child: _CreateStepTracker(
            flowType: flowType,
            steps: steps,
            currentStep: currentStep,
          ),
        ),
      ],
    );
  }
}

class CategoryStepView extends StatelessWidget {
  const CategoryStepView({super.key, required this.controller});

  final CreateController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      children: <Widget>[
        Text(
          l10n.createCategoryPromptTitle,
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: 10),
        Text(
          l10n.createCategoryPromptDescription,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final compactWidth = constraints.maxWidth < 420;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                mainAxisExtent: compactWidth ? 244 : 228,
              ),
              itemCount: controller.availableCategories.length,
              itemBuilder: (context, index) {
                final category = controller.availableCategories[index];
                final cardContent = _categoryCardContentFor(category);
                return _CategorySelectionCard(
                  title: cardContent.title,
                  description: cardContent.description,
                  icon: cardContent.icon,
                  selected: controller.selectedCategoryIds.contains(
                    category.id,
                  ),
                  compact: compactWidth,
                  onTap: () => controller.toggleCategory(category.id),
                );
              },
            );
          },
        ),
        if (controller.errorFor('categories') != null) ...<Widget>[
          const SizedBox(height: 12),
          InlineErrorText(text: controller.errorFor('categories')!),
        ],
      ],
    );
  }
}

class CompletedStepView extends StatelessWidget {
  const CompletedStepView({
    super.key,
    required this.controller,
    required this.onDone,
  });

  final CreateController controller;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final result = controller.submitResult;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
      child: Column(
        children: <Widget>[
          const Spacer(),
          Container(
            width: 84,
            height: 84,
            decoration: const BoxDecoration(
              color: AppColors.softGreenBorder,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: AppColors.brandGreen,
              size: 42,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            controller.completedMessage,
            style: theme.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            controller.isEditMode
                ? l10n.createCompletedEditDescription
                : l10n.createCompletedCreateDescription,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (result != null)
            SummaryCard(
              title: result.title,
              body:
                  '${result.placeName}\n${formatCreateDate(result.eventStartsAt)}',
            ),
          const Spacer(),
          MateyaButton(
            label: controller.isEditMode
                ? l10n.createBackToPrevious
                : l10n.createBackToHome,
            onPressed: onDone,
          ),
        ],
      ),
    );
  }
}

class _CreateStepTracker extends StatelessWidget {
  const _CreateStepTracker({
    required this.flowType,
    required this.steps,
    required this.currentStep,
  });

  final CreateFlowType flowType;
  final List<CreateStep> steps;
  final CreateStep currentStep;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentIndex = steps.indexOf(currentStep);

    return LayoutBuilder(
      builder: (context, constraints) {
        final stepCount = steps.length;
        final cellWidth = stepCount == 0
            ? constraints.maxWidth
            : constraints.maxWidth / stepCount;
        final lineLeft = cellWidth / 2;
        final lineWidth = (constraints.maxWidth - cellWidth).clamp(
          0.0,
          constraints.maxWidth,
        );
        final progressFraction = stepCount <= 1
            ? 1.0
            : currentIndex == stepCount - 1
            ? 1.0
            : (currentIndex + 0.5) / (stepCount - 1);

        return SizedBox(
          height: 78,
          child: Stack(
            children: <Widget>[
              if (stepCount > 1)
                Positioned(
                  left: lineLeft,
                  right: lineLeft,
                  top: 13,
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              if (stepCount > 1)
                Positioned(
                  left: lineLeft,
                  top: 13,
                  child: Container(
                    width: lineWidth * progressFraction,
                    height: 3,
                    decoration: BoxDecoration(
                      color: AppColors.brandGreen,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  for (int index = 0; index < stepCount; index++)
                    Expanded(
                      child: _CreateStepTrackerItem(
                        stepNumber: index + 1,
                        label: _stepLabel(steps[index]),
                        state: _stepState(index, currentIndex),
                        theme: theme,
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _stepLabel(CreateStep step) {
    final l10n = MateyaLocalizations.current;
    return switch (step) {
      CreateStep.category => l10n.createStepCategory,
      CreateStep.place =>
        flowType == CreateFlowType.group
            ? l10n.createStepPlaceGroup
            : l10n.createStepPlaceClass,
      CreateStep.details =>
        flowType == CreateFlowType.group
            ? l10n.createStepDetailsGroup
            : l10n.createStepDetailsClass,
      CreateStep.completed => l10n.createCompletedProgress,
    };
  }

  _CreateStepIndicatorState _stepState(int index, int currentIndex) {
    if (index < currentIndex) {
      return _CreateStepIndicatorState.completed;
    }
    if (index == currentIndex) {
      return _CreateStepIndicatorState.current;
    }
    return _CreateStepIndicatorState.upcoming;
  }
}

enum _CreateStepIndicatorState { completed, current, upcoming }

class _CreateStepTrackerItem extends StatelessWidget {
  const _CreateStepTrackerItem({
    required this.stepNumber,
    required this.label,
    required this.state,
    required this.theme,
  });

  final int stepNumber;
  final String label;
  final _CreateStepIndicatorState state;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final isCurrent = state == _CreateStepIndicatorState.current;

    return Column(
      children: <Widget>[
        SizedBox(
          height: 30,
          child: Center(child: _CreateStepNode(state: state)),
        ),
        const SizedBox(height: 8),
        Text(
          '$stepNumber',
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isCurrent ? AppColors.textPrimary : AppColors.textSecondary,
            fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _CreateStepNode extends StatelessWidget {
  const _CreateStepNode({required this.state});

  final _CreateStepIndicatorState state;

  @override
  Widget build(BuildContext context) {
    if (state == _CreateStepIndicatorState.upcoming) {
      return Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.fieldBorderLight, width: 1.4),
        ),
      );
    }

    return Container(
      width: 30,
      height: 30,
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.brandGreen, width: 1.8),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.brandGreen,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Center(
          child: switch (state) {
            _CreateStepIndicatorState.completed => const Icon(
              Icons.check_rounded,
              size: 17,
              color: Colors.white,
            ),
            _CreateStepIndicatorState.current => Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            _CreateStepIndicatorState.upcoming => const SizedBox.shrink(),
          },
        ),
      ),
    );
  }
}

class _CategorySelectionCard extends StatelessWidget {
  const _CategorySelectionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.selected,
    required this.compact,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final bool selected;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleBoxHeight = compact ? 62.0 : 56.0;
    final descriptionBoxHeight = compact ? 76.0 : 68.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
          decoration: BoxDecoration(
            color: selected ? AppColors.softGreenBorder : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? AppColors.brandGreenLight : AppColors.divider,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(icon, size: 40, color: AppColors.textPrimary),
              const Spacer(),
              SizedBox(
                height: titleBoxHeight,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                height: descriptionBoxHeight,
                child: Text(
                  description,
                  maxLines: compact ? 4 : 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

_CategoryCardContent _categoryCardContentFor(CreateCategoryOption category) {
  final predefined = _categoryCardContents()[category.id];
  if (predefined != null) {
    return predefined;
  }

  return _CategoryCardContent(
    title: category.label,
    description: MateyaLocalizations.current.createCategoryPromptDescription,
    icon: Icons.category_outlined,
  );
}

Map<String, _CategoryCardContent> _categoryCardContents() {
  final l10n = MateyaLocalizations.current;
  return <String, _CategoryCardContent>{
    'TOURIST_ATTRACTION': _CategoryCardContent(
      title: l10n.activityCategoryTouristAttraction,
      description: l10n.createCategoryDescriptionTourist,
      icon: Icons.temple_buddhist_outlined,
    ),
    'TRAVEL_COURSE': _CategoryCardContent(
      title: l10n.activityCategoryTravelCourse,
      description: l10n.createCategoryDescriptionTravelCourse,
      icon: Icons.location_on_outlined,
    ),
    'CULTURE_TRADITION': _CategoryCardContent(
      title: l10n.createCategoryTitleCultureTradition,
      description: l10n.createCategoryDescriptionCultureTradition,
      icon: Icons.account_balance_outlined,
    ),
    'EVENT_PERFORMANCE_FESTIVAL': _CategoryCardContent(
      title: l10n.createCategoryTitleEventPerformanceFestival,
      description: l10n.createCategoryDescriptionFestival,
      icon: Icons.celebration_outlined,
    ),
    'SPORTS': _CategoryCardContent(
      title: l10n.activityCategorySports,
      description: l10n.createCategoryDescriptionSports,
      icon: Icons.sports_soccer_outlined,
    ),
    'ACTIVITY_LEPORTS': _CategoryCardContent(
      title: l10n.createCategoryTitleActivityLeports,
      description: l10n.createCategoryDescriptionActivityLeports,
      icon: Icons.downhill_skiing_outlined,
    ),
    'PUBLIC_FACILITY': _CategoryCardContent(
      title: l10n.activityCategoryPublicFacility,
      description: l10n.createCategoryDescriptionPublicFacility,
      icon: Icons.auto_awesome_outlined,
    ),
    'SHOPPING': _CategoryCardContent(
      title: l10n.activityCategoryShopping,
      description: l10n.createCategoryDescriptionShopping,
      icon: Icons.shopping_bag_outlined,
    ),
  };
}

class _CategoryCardContent {
  const _CategoryCardContent({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;
}
