import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../shared/theme/app_tokens.dart';
import '../../../../shared/widgets/mateya_text_field.dart';
import '../../application/create_controller.dart';
import '../../domain/create_models.dart';
import 'create_form_fields.dart';
import 'create_form_primitives.dart';
import 'create_formatters.dart';

class DetailsStepView extends StatelessWidget {
  const DetailsStepView({
    super.key,
    required this.controller,
    required this.scrollController,
    required this.sectionKeys,
    required this.titleController,
    required this.descriptionController,
    required this.priceController,
    required this.onPickEventDate,
    required this.onPickStartTime,
    required this.onPickEndTime,
    required this.onPickDeadlineDate,
    required this.onPickDeadlineTime,
    required this.onPickImages,
    required this.onDelete,
  });

  final CreateController controller;
  final ScrollController scrollController;
  final Map<String, GlobalKey> sectionKeys;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final Future<void> Function() onPickEventDate;
  final Future<void> Function() onPickStartTime;
  final Future<void> Function() onPickEndTime;
  final Future<void> Function() onPickDeadlineDate;
  final Future<void> Function() onPickDeadlineTime;
  final Future<void> Function() onPickImages;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedPlace = controller.selectedPlace;
    final manualSummary =
        controller.flowType == CreateFlowType.classRegistration &&
            controller.manualPlaceName.trim().isNotEmpty &&
            controller.manualPlaceAddress.trim().isNotEmpty
        ? '${controller.manualPlaceName.trim()}\n${controller.manualPlaceAddress.trim()}'
        : null;
    if (titleController.text != controller.title) {
      titleController.value = TextEditingValue(
        text: controller.title,
        selection: TextSelection.collapsed(offset: controller.title.length),
      );
    }
    if (descriptionController.text != controller.description) {
      descriptionController.value = TextEditingValue(
        text: controller.description,
        selection: TextSelection.collapsed(
          offset: controller.description.length,
        ),
      );
    }
    if (priceController.text != controller.priceText) {
      priceController.value = TextEditingValue(
        text: controller.priceText,
        selection: TextSelection.collapsed(offset: controller.priceText.length),
      );
    }

    return ListView(
      key: const PageStorageKey<String>('create-details-scroll'),
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      children: <Widget>[
        Text(
          controller.flowType == CreateFlowType.group
              ? '모임 정보를 입력해 주세요'
              : '클래스 정보를 입력해 주세요',
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: 10),
        Text(
          '필수 항목이 모두 채워져야 등록 버튼이 활성화되도록 프론트 검증을 먼저 구현했습니다.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        if (controller.flowType == CreateFlowType.group) ...<Widget>[
          SummaryCard(
            title: '선택한 카테고리',
            body: controller.availableCategories
                .where(
                  (category) =>
                      controller.selectedCategoryIds.contains(category.id),
                )
                .map((category) => category.label)
                .join(', '),
          ),
          const SizedBox(height: 12),
        ],
        if (selectedPlace != null || manualSummary != null) ...<Widget>[
          SummaryCard(
            title: '선택한 장소',
            body: selectedPlace != null
                ? '${selectedPlace.name}\n${selectedPlace.address}'
                : manualSummary!,
          ),
          const SizedBox(height: 24),
        ],
        Container(
          key: sectionKeys['title'],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                controller.flowType == CreateFlowType.group ? '모임명' : '클래스 이름',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              MateyaTextField(
                controller: titleController,
                hintText: controller.flowType == CreateFlowType.group
                    ? '예: 북촌 한옥 다도 체험 같이 가요'
                    : '예: 초보자를 위한 전통 다도 클래스',
                errorText: controller.errorFor('title'),
                maxLength: 100,
                onChanged: controller.updateTitle,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          key: sectionKeys['description'],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('소개', style: theme.textTheme.titleLarge),
              const SizedBox(height: 10),
              MultilineField(
                controller: descriptionController,
                hintText: '활동 소개, 준비물, 분위기 등을 자유롭게 적어 주세요.',
                maxLength: 3000,
                errorText: controller.errorFor('description'),
                onChanged: controller.updateDescription,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          key: sectionKeys['eventDate'],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('날짜와 시간', style: theme.textTheme.titleLarge),
              const SizedBox(height: 10),
              PickerField(
                label: '날짜',
                value: formatCreateDate(controller.eventDate),
                placeholder: '날짜 선택',
                errorText: controller.errorFor('eventDate'),
                icon: Icons.calendar_today_rounded,
                onTap: onPickEventDate,
              ),
              const SizedBox(height: 12),
              Container(
                key: sectionKeys['time'],
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: PickerField(
                        label: '시작 시간',
                        value: formatCreateTime(controller.startTime),
                        placeholder: '시작 시간',
                        errorText: null,
                        icon: Icons.schedule_rounded,
                        onTap: onPickStartTime,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PickerField(
                        label: '종료 시간',
                        value: formatCreateTime(controller.endTime),
                        placeholder: '종료 시간',
                        errorText: null,
                        icon: Icons.schedule_rounded,
                        onTap: onPickEndTime,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (controller.errorFor('time') != null) ...<Widget>[
          const SizedBox(height: 10),
          InlineErrorText(text: controller.errorFor('time')!),
        ],
        const SizedBox(height: 24),
        Container(
          key: sectionKeys['participantCapacity'],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('모집 인원', style: theme.textTheme.titleLarge),
              const SizedBox(height: 10),
              CapacityStepper(
                value: controller.participantCapacity,
                onChanged: controller.updateParticipantCapacity,
              ),
              if (controller.errorFor('participantCapacity') !=
                  null) ...<Widget>[
                const SizedBox(height: 10),
                InlineErrorText(
                  text: controller.errorFor('participantCapacity')!,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          key: sectionKeys['deadline'],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text('모집 마감', style: theme.textTheme.titleLarge),
                  ),
                  if (controller.deadlineDate != null ||
                      controller.deadlineTime != null)
                    TextButton(
                      onPressed: controller.clearDeadline,
                      child: const Text('초기화'),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: PickerField(
                      label: '마감 날짜',
                      value: formatCreateDate(controller.deadlineDate),
                      placeholder: '선택 안 함',
                      errorText: null,
                      icon: Icons.event_available_rounded,
                      onTap: onPickDeadlineDate,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PickerField(
                      label: '마감 시간',
                      value: formatCreateTime(controller.deadlineTime),
                      placeholder: '선택 안 함',
                      errorText: null,
                      icon: Icons.alarm_rounded,
                      onTap: onPickDeadlineTime,
                    ),
                  ),
                ],
              ),
              if (controller.errorFor('deadline') != null) ...<Widget>[
                const SizedBox(height: 10),
                InlineErrorText(text: controller.errorFor('deadline')!),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          key: sectionKeys['languages'],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('진행 언어', style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: CreateFormOptions.languages
                    .map(
                      (language) => SelectableChip(
                        label: language.label,
                        selected: controller.languageCodes.contains(
                          language.code,
                        ),
                        onTap: () => controller.toggleLanguage(language.code),
                      ),
                    )
                    .toList(growable: false),
              ),
              if (controller.errorFor('languages') != null) ...<Widget>[
                const SizedBox(height: 12),
                InlineErrorText(text: controller.errorFor('languages')!),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          key: sectionKeys['priceType'],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('비용', style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              Row(
                children: CreatePriceType.values
                    .map(
                      (type) => Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: type == CreatePriceType.free ? 8 : 0,
                            left: type == CreatePriceType.paid ? 8 : 0,
                          ),
                          child: ToggleCard(
                            label: type.label,
                            selected: controller.priceType == type,
                            onTap: () => controller.updatePriceType(type),
                          ),
                        ),
                      ),
                    )
                    .toList(growable: false),
              ),
              if (controller.errorFor('priceType') != null) ...<Widget>[
                const SizedBox(height: 12),
                InlineErrorText(text: controller.errorFor('priceType')!),
              ],
              if (controller.priceType == CreatePriceType.paid) ...<Widget>[
                const SizedBox(height: 12),
                Container(
                  key: sectionKeys['price'],
                  child: MateyaTextField(
                    controller: priceController,
                    hintText: '예: 15000',
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    errorText: controller.errorFor('price'),
                    onChanged: controller.updatePriceText,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text('참가 대상', style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: CreateFormOptions.audiences
              .map(
                (audience) => SelectableChip(
                  label: audience.label,
                  selected: controller.audienceIds.contains(audience.id),
                  onTap: () => controller.toggleAudience(audience.id),
                ),
              )
              .toList(growable: false),
        ),
        const SizedBox(height: 24),
        Container(
          key: sectionKeys['images'],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text('대표 이미지', style: theme.textTheme.titleLarge),
                  ),
                  Text(
                    '${controller.images.length}/${CreateController.maxImageCount}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: onPickImages,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: AppColors.fieldBorderLight),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.add_photo_alternate_outlined),
                label: const Text('이미지 추가'),
              ),
              const SizedBox(height: 12),
              if (controller.images.isEmpty)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.subtleBackground,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Text(
                    controller.flowType == CreateFlowType.group
                        ? '모임은 대표 이미지를 최소 1장 등록하도록 구성했습니다.'
                        : '클래스 이미지는 현재 선택 입력으로 두고, 기본 이미지 정책은 백엔드 연결 전에 확정할 수 있게 열어뒀습니다.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                )
              else
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: controller.images
                      .map(
                        (image) => ImageTile(
                          image: image,
                          onRemove: () => controller.removeImage(image.id),
                          onSetPrimary: () =>
                              controller.setPrimaryImage(image.id),
                        ),
                      )
                      .toList(growable: false),
                ),
              if (controller.errorFor('images') != null) ...<Widget>[
                const SizedBox(height: 12),
                InlineErrorText(text: controller.errorFor('images')!),
              ],
            ],
          ),
        ),
        if (onDelete != null) ...<Widget>[
          const SizedBox(height: 28),
          OutlinedButton(
            onPressed: controller.isDeleteLoading ? null : onDelete,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error),
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              controller.isDeleteLoading
                  ? '삭제 중...'
                  : '${controller.flowType.entityLabel} 삭제하기',
            ),
          ),
        ],
        const SizedBox(height: 24),
      ],
    );
  }
}
