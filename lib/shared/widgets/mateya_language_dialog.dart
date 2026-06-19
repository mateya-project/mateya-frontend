import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';
import 'mateya_button.dart';

class MateyaLanguageOption {
  const MateyaLanguageOption({
    required this.code,
    required this.label,
    required this.nativeLabel,
  });

  final String code;
  final String label;
  final String nativeLabel;
}

const List<MateyaLanguageOption> kMateyaLanguageOptions =
    <MateyaLanguageOption>[
      MateyaLanguageOption(code: 'ko', label: 'Korean', nativeLabel: '한국어'),
      MateyaLanguageOption(code: 'en', label: 'English', nativeLabel: '영어'),
      MateyaLanguageOption(
        code: 'zh-Hans',
        label: 'Chinese (Simplified)',
        nativeLabel: '중국어(간체)',
      ),
      MateyaLanguageOption(code: 'ja', label: 'Japanese', nativeLabel: '일본어'),
    ];

Future<void> showMateyaLanguageDialog(
  BuildContext context, {
  String initialLanguageCode = 'ko',
}) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Language dialog',
    barrierColor: AppColors.overlay,
    transitionDuration: const Duration(milliseconds: 180),
    pageBuilder: (context, _, _) {
      return _MateyaLanguageDialog(initialLanguageCode: initialLanguageCode);
    },
    transitionBuilder: (context, animation, _, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.96, end: 1).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class _MateyaLanguageDialog extends StatefulWidget {
  const _MateyaLanguageDialog({required this.initialLanguageCode});

  final String initialLanguageCode;

  @override
  State<_MateyaLanguageDialog> createState() => _MateyaLanguageDialogState();
}

class _MateyaLanguageDialogState extends State<_MateyaLanguageDialog> {
  late String _selectedLanguageCode;

  @override
  void initState() {
    super.initState();
    _selectedLanguageCode =
        kMateyaLanguageOptions.any(
          (option) => option.code == widget.initialLanguageCode,
        )
        ? widget.initialLanguageCode
        : kMateyaLanguageOptions.first.code;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedOption = kMateyaLanguageOptions.firstWhere(
      (option) => option.code == _selectedLanguageCode,
      orElse: () => kMateyaLanguageOptions.first,
    );

    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 360),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Color(0x1A111111),
                    blurRadius: 28,
                    offset: Offset(0, 18),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '언어 설정',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '앱에서 사용할 언어를 선택할 수 있습니다. 현재 선택값은 팝업 안에서만 미리보기로 반영됩니다.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      InkResponse(
                        onTap: () => Navigator.of(context).pop(),
                        radius: 20,
                        child: const SizedBox(
                          width: 32,
                          height: 32,
                          child: Icon(
                            Icons.close_rounded,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.subtleBackground,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.language_rounded,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '현재 선택',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                selectedOption.nativeLabel,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                selectedOption.label,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    '지원 언어',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (
                    int index = 0;
                    index < kMateyaLanguageOptions.length;
                    index++
                  ) ...<Widget>[
                    _LanguageOptionTile(
                      option: kMateyaLanguageOptions[index],
                      selected:
                          kMateyaLanguageOptions[index].code ==
                          _selectedLanguageCode,
                      onTap: () {
                        setState(() {
                          _selectedLanguageCode =
                              kMateyaLanguageOptions[index].code;
                        });
                      },
                    ),
                    if (index != kMateyaLanguageOptions.length - 1)
                      const SizedBox(height: 10),
                  ],
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.appSurface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '실제 앱 언어 전환은 아직 연결되지 않았습니다. 이번 변경은 팝업 디자인과 선택 경험을 우선 정리한 상태입니다.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textMuted,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.textPrimary,
                              side: const BorderSide(
                                color: AppColors.fieldBorderLight,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.fieldRadius,
                                ),
                              ),
                            ),
                            child: const Text('닫기'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: MateyaButton(
                          label: '확인',
                          onPressed: () => Navigator.of(context).pop(),
                          tone: MateyaButtonTone.dark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageOptionTile extends StatelessWidget {
  const _LanguageOptionTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final MateyaLanguageOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF0F8F3) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? AppColors.brandGreen : AppColors.fieldBorderLight,
          ),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    option.nativeLabel,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    option.label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: selected ? AppColors.brandGreen : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: selected
                      ? AppColors.brandGreen
                      : AppColors.fieldBorderLight,
                ),
              ),
              child: selected
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
