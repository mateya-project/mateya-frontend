import 'package:flutter/material.dart';

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
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      children: <Widget>[
        Text('어떤 모임을 만들까요?', style: theme.textTheme.headlineMedium),
        const SizedBox(height: 10),
        Text(
          '서비스 카테고리는 백엔드 public data 기준 8종으로 맞췄고, 모임은 1개 카테고리만 선택하도록 구성했습니다.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        const PrimaryTypeCard(),
        const SizedBox(height: 28),
        Text('카테고리', style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: controller.availableCategories
              .map(
                (category) => SelectableChip(
                  label: category.label,
                  selected: controller.selectedCategoryIds.contains(
                    category.id,
                  ),
                  onTap: () => controller.toggleCategory(category.id),
                ),
              )
              .toList(growable: false),
        ),
        if (controller.errorFor('categories') != null) ...<Widget>[
          const SizedBox(height: 12),
          InlineErrorText(text: controller.errorFor('categories')!),
        ],
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.subtleBackground,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            '선택한 카테고리는 다음 단계 장소 추천과 최종 상세 입력으로 그대로 전달됩니다.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ),
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
                ? '수정한 내용을 저장했고, 확인 후 이전 화면으로 돌아갈 수 있습니다.'
                : '등록한 내용을 저장했고, 확인 후 홈으로 돌아갈 수 있습니다.',
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
            label: controller.isEditMode ? '이전 화면으로 돌아가기' : '홈으로 돌아가기',
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
            : currentIndex / (stepCount - 1);

        return SizedBox(
          height: 80,
          child: Stack(
            children: <Widget>[
              if (stepCount > 1)
                Positioned(
                  left: lineLeft,
                  right: lineLeft,
                  top: 14,
                  child: Container(height: 2, color: AppColors.divider),
                ),
              if (stepCount > 1)
                Positioned(
                  left: lineLeft,
                  top: 14,
                  child: Container(
                    width: lineWidth * progressFraction,
                    height: 2,
                    color: AppColors.brandGreen,
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
    return switch (step) {
      CreateStep.category => '모임 유형',
      CreateStep.place => flowType == CreateFlowType.group ? '모임 장소' : '클래스 장소',
      CreateStep.details =>
        flowType == CreateFlowType.group ? '모임 상세' : '클래스 상세',
      CreateStep.completed => '완료',
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
          height: 28,
          child: Center(child: _CreateStepNode(state: state)),
        ),
        const SizedBox(height: 10),
        Text(
          'step$stepNumber',
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
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: state == _CreateStepIndicatorState.completed
            ? AppColors.brandGreen
            : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: state == _CreateStepIndicatorState.upcoming
              ? AppColors.fieldBorderLight
              : AppColors.brandGreen,
          width: 2,
        ),
      ),
      child: Center(
        child: switch (state) {
          _CreateStepIndicatorState.completed => const Icon(
            Icons.check_rounded,
            size: 18,
            color: Colors.white,
          ),
          _CreateStepIndicatorState.current => Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: AppColors.brandGreen,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          _CreateStepIndicatorState.upcoming => const SizedBox.shrink(),
        },
      ),
    );
  }
}

class PrimaryTypeCard extends StatelessWidget {
  const PrimaryTypeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.softGreenBorder,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.brandGreenLight),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.temple_buddhist_outlined,
              color: AppColors.brandGreen,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('한국문화 체험', style: theme.textTheme.titleLarge),
                const SizedBox(height: 6),
                Text(
                  '현재 선택 가능한 유일한 모임 유형',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.brandGreen,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '선택됨',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
