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
                              'globe 팝업 UI만 먼저 구현되어 있으며 실제 언어 전환은 아직 연결되지 않았습니다.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
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
                  Text(
                    '지원 언어',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.subtleBackground,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.fieldRadius,
                      ),
                      border: Border.all(color: AppColors.fieldBorderLight),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedLanguageCode,
                        isExpanded: true,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.fieldRadius,
                        ),
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.textSecondary,
                        ),
                        items: kMateyaLanguageOptions.map((option) {
                          return DropdownMenuItem<String>(
                            value: option.code,
                            child: Text(
                              '${option.nativeLabel} (${option.label})',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _selectedLanguageCode = value;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.appSurface,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      '선택값은 현재 팝업 내부에서만 유지됩니다.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textMuted,
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
