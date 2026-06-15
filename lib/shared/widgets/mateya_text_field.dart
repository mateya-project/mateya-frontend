import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_tokens.dart';

class MateyaTextField extends StatefulWidget {
  const MateyaTextField({
    super.key,
    required this.controller,
    this.focusNode,
    this.hintText,
    this.errorText,
    this.keyboardType,
    this.readOnly = false,
    this.maxLength,
    this.autofocus = false,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.inputFormatters,
    this.suffixIcon,
    this.textInputAction,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? hintText;
  final String? errorText;
  final TextInputType? keyboardType;
  final bool readOnly;
  final int? maxLength;
  final bool autofocus;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;

  @override
  State<MateyaTextField> createState() => _MateyaTextFieldState();
}

class _MateyaTextFieldState extends State<MateyaTextField> {
  late final FocusNode _focusNode;
  bool _ownsFocusNode = false;

  @override
  void initState() {
    super.initState();
    _ownsFocusNode = widget.focusNode == null;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(covariant MateyaTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      _focusNode.removeListener(_handleFocusChanged);
      if (_ownsFocusNode) {
        _focusNode.dispose();
      }
      _ownsFocusNode = widget.focusNode == null;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChanged);
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleFocusChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.errorText != null
        ? AppColors.error
        : _focusNode.hasFocus
        ? AppColors.textPrimary
        : AppColors.fieldBorder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          autofocus: widget.autofocus,
          readOnly: widget.readOnly,
          maxLength: widget.maxLength,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          textInputAction: widget.textInputAction,
          onTap: widget.onTap,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            counterText: '',
            hintText: widget.hintText,
            hintStyle: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
            suffixIcon: widget.suffixIcon,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            filled: true,
            fillColor: AppColors.inputBackground,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.fieldRadius),
              borderSide: BorderSide(color: activeColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.fieldRadius),
              borderSide: BorderSide(color: activeColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.fieldRadius),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.fieldRadius),
              borderSide: const BorderSide(color: AppColors.error),
            ),
          ),
        ),
        if (widget.errorText != null) ...<Widget>[
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              const Icon(
                Icons.warning_amber_rounded,
                size: 16,
                color: AppColors.error,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  widget.errorText!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.error),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
