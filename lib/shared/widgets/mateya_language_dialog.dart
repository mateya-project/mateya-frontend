import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

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
        nativeLabel: '중국어(간체자)',
      ),
      MateyaLanguageOption(code: 'ja', label: 'Japanese', nativeLabel: '일본어'),
    ];

Future<String?> showMateyaLanguageDialog(
  BuildContext context, {
  String initialLanguageCode = 'ko',
}) {
  return showGeneralDialog<String?>(
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
  static const double _dropdownControlHeight = 52;

  late String _selectedLanguageCode;
  final LayerLink _dropdownLayerLink = LayerLink();
  final GlobalKey _dropdownFieldKey = GlobalKey();
  OverlayEntry? _dropdownOverlayEntry;
  double _dropdownWidth = 0;

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
  void dispose() {
    _removeDropdownOverlay();
    super.dispose();
  }

  bool get _isDropdownExpanded => _dropdownOverlayEntry != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedOption = kMateyaLanguageOptions.firstWhere(
      (option) => option.code == _selectedLanguageCode,
      orElse: () => kMateyaLanguageOptions.first,
    );
    final remainingOptions = kMateyaLanguageOptions
        .where((option) => option.code != _selectedLanguageCode)
        .toList(growable: false);

    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 390),
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Color(0x14111111),
                    blurRadius: 20,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '언어 변경',
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        shape: const CircleBorder(),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          key: const ValueKey<String>('language-dialog-close'),
                          onTap: () => Navigator.of(context).pop(),
                          customBorder: const CircleBorder(),
                          splashColor: Colors.black.withValues(alpha: 0.08),
                          highlightColor: Colors.black.withValues(alpha: 0.04),
                          child: const SizedBox(
                            width: 36,
                            height: 36,
                            child: Icon(
                              Icons.close_rounded,
                              size: 30,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Text(
                    '지원 언어',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _LanguageDropdown(
                    fieldKey: _dropdownFieldKey,
                    layerLink: _dropdownLayerLink,
                    selectedOption: selectedOption,
                    expanded: _isDropdownExpanded,
                    controlHeight: _dropdownControlHeight,
                    onToggle: () => _toggleDropdown(remainingOptions),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () =>
                          Navigator.of(context).pop(_selectedLanguageCode),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: theme.textTheme.titleLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      child: const Text('확인'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _toggleDropdown(List<MateyaLanguageOption> remainingOptions) {
    if (_isDropdownExpanded) {
      _removeDropdownOverlay();
      setState(() {});
      return;
    }
    _updateDropdownMetrics();
    _dropdownOverlayEntry = _buildDropdownOverlay(remainingOptions);
    Overlay.of(context, rootOverlay: true).insert(_dropdownOverlayEntry!);
    setState(() {});
  }

  void _removeDropdownOverlay() {
    _dropdownOverlayEntry?.remove();
    _dropdownOverlayEntry = null;
  }

  OverlayEntry _buildDropdownOverlay(
    List<MateyaLanguageOption> remainingOptions,
  ) {
    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: <Widget>[
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _removeDropdownOverlay();
                  if (mounted) {
                    setState(() {});
                  }
                },
              ),
            ),
            CompositedTransformFollower(
              link: _dropdownLayerLink,
              showWhenUnlinked: false,
              offset: const Offset(0, _dropdownControlHeight - 1),
              child: Material(
                color: Colors.transparent,
                child: SizedBox(
                  width: _dropdownWidth,
                  child: _LanguageDropdownPanel(
                    options: remainingOptions,
                    controlHeight: _dropdownControlHeight,
                    onSelect: (option) {
                      setState(() {
                        _selectedLanguageCode = option.code;
                      });
                      _removeDropdownOverlay();
                      if (mounted) {
                        setState(() {});
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _updateDropdownMetrics() {
    final box =
        _dropdownFieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) {
      return;
    }
    _dropdownWidth = box.size.width;
  }
}

class _LanguageDropdown extends StatelessWidget {
  const _LanguageDropdown({
    required this.fieldKey,
    required this.layerLink,
    required this.selectedOption,
    required this.expanded,
    required this.controlHeight,
    required this.onToggle,
  });

  final Key fieldKey;
  final LayerLink layerLink;
  final MateyaLanguageOption selectedOption;
  final bool expanded;
  final double controlHeight;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final borderRadius = expanded
        ? const BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
          )
        : BorderRadius.circular(14);

    return CompositedTransformTarget(
      link: layerLink,
      child: Material(
        key: fieldKey,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: BorderSide(
            color: AppColors.textPrimary.withValues(alpha: 0.45),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: controlHeight,
          child: InkWell(
            key: const ValueKey<String>('language-dropdown-toggle'),
            onTap: onToggle,
            splashColor: Colors.black.withValues(alpha: 0.06),
            highlightColor: Colors.black.withValues(alpha: 0.03),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      selectedOption.nativeLabel,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 28,
                    color: AppColors.textPrimary,
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

class _LanguageDropdownPanel extends StatelessWidget {
  const _LanguageDropdownPanel({
    required this.options,
    required this.controlHeight,
    required this.onSelect,
  });

  final List<MateyaLanguageOption> options;
  final double controlHeight;
  final ValueChanged<MateyaLanguageOption> onSelect;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: const ValueKey<String>('language-dropdown-panel'),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(14),
          bottomRight: Radius.circular(14),
        ),
        side: BorderSide(color: AppColors.textPrimary.withValues(alpha: 0.45)),
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 6,
      shadowColor: const Color(0x14111111),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (int index = 0; index < options.length; index++) ...<Widget>[
            InkWell(
              key: ValueKey<String>('language-option-${options[index].code}'),
              onTap: () => onSelect(options[index]),
              splashColor: Colors.black.withValues(alpha: 0.06),
              highlightColor: Colors.black.withValues(alpha: 0.03),
              child: SizedBox(
                width: double.infinity,
                height: controlHeight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      options[index].nativeLabel,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (index != options.length - 1)
              const Divider(height: 1, thickness: 1, color: Color(0xFFB9B1A4)),
          ],
        ],
      ),
    );
  }
}
