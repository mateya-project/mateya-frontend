import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../shared/media/image_picker_lost_data.dart';
import '../../../../shared/permissions/mateya_permission_dialogs.dart';
import '../../../../shared/theme/app_tokens.dart';
import '../../../../shared/widgets/mateya_button.dart';
import 'activity_detail_review_widgets.dart';

class ReviewComposerSheet extends StatefulWidget {
  const ReviewComposerSheet({super.key, required this.onSubmit});

  final Future<String?> Function(
    int rating,
    String body,
    List<String> imageUrls,
  )
  onSubmit;

  @override
  State<ReviewComposerSheet> createState() => _ReviewComposerSheetState();
}

class _ReviewComposerSheetState extends State<ReviewComposerSheet> {
  static const int _maxImageCount = 5;
  static const int _gridColumnCount = 3;

  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _bodyController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<XFile> _images = <XFile>[];

  int _rating = 0;
  int? _draggingIndex;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChanged);
    _restoreLostImages();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChanged);
    _bodyController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  bool get _canSubmit => _rating > 0 && _bodyController.text.trim().isNotEmpty;

  Future<void> _restoreLostImages() async {
    final recovery = await recoverLostImagePickerData(
      _imagePicker.retrieveLostData,
      fallbackErrorMessage: '이전에 선택하던 후기 이미지를 복구하지 못했어요. 다시 선택해 주세요.',
    );
    if (!mounted || recovery.isEmpty) {
      return;
    }
    if (recovery.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(recovery.errorMessage!)));
      return;
    }

    final available = _maxImageCount - _images.length;
    if (available <= 0) {
      return;
    }

    final restored = recovery.files.take(available).toList(growable: false);
    if (restored.isEmpty) {
      return;
    }

    setState(() {
      _images.addAll(restored);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('이전에 선택하던 후기 이미지 ${restored.length}장을 복구했어요.')),
    );
  }

  Future<void> _pickImages() async {
    final available = _maxImageCount - _images.length;
    if (available <= 0) {
      return;
    }

    final shouldContinue = await showMateyaPermissionNoticeDialog(
      context,
      title: '사진 권한 안내',
      message:
          '후기에 사진을 첨부하려면 사진 보관함 접근 권한이 필요합니다. 권한을 거부하셔도 후기 텍스트 작성과 평점 등록은 계속할 수 있습니다.',
      confirmLabel: '사진 선택하기',
      cancelLabel: '나중에',
    );

    if (!mounted || !shouldContinue) {
      return;
    }

    try {
      final picked = await _imagePicker.pickMultiImage(imageQuality: 88);
      if (!mounted || picked.isEmpty) {
        return;
      }
      setState(() {
        _images.addAll(picked.take(available));
      });
    } on PlatformException catch (error) {
      if (!mounted) {
        return;
      }
      if (error.code == 'photo_access_denied') {
        final action = await showMateyaPermissionRecoveryDialog(
          context,
          title: '사진 권한이 필요해요',
          message:
              '후기 사진 첨부를 사용하려면 사진 보관함 접근 권한이 필요합니다. 권한이 없어도 텍스트 후기와 평점 등록은 계속할 수 있고, 다시 시도하거나 앱 설정에서 권한을 허용할 수 있습니다.',
          retryLabel: '다시 시도',
        );
        if (!mounted) {
          return;
        }
        if (action == MateyaPermissionRecoveryAction.retry) {
          await _pickImages();
          return;
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('사진을 불러오지 못했어요. 권한과 파일 상태를 확인해 주세요.')),
      );
    }
  }

  void _moveImage(int fromIndex, int toIndex) {
    if (fromIndex == toIndex) {
      return;
    }
    setState(() {
      final item = _images.removeAt(fromIndex);
      if (toIndex > _images.length) {
        toIndex = _images.length;
      }
      _images.insert(toIndex, item);
      _draggingIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;
    final textLength = _bodyController.text.length;

    return Container(
      color: AppColors.overlay,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                      Expanded(
                        child: Text(
                          '후기 작성하기',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: List<Widget>.generate(5, (index) {
                      final star = index + 1;
                      final isActive = star <= _rating;
                      return IconButton(
                        onPressed: () => setState(() => _rating = star),
                        icon: Icon(
                          isActive
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          color: isActive
                              ? AppColors.textPrimary
                              : AppColors.fieldBorderLight,
                          size: 34,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _focusNode.hasFocus
                            ? AppColors.textPrimary
                            : AppColors.fieldBorderLight,
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        TextField(
                          controller: _bodyController,
                          focusNode: _focusNode,
                          maxLines: 6,
                          maxLength: 500,
                          decoration: const InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                            hintText: '활동에서 좋았던 점이나 다음 참가자에게 도움이 될 내용을 남겨 주세요.',
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                        Text(
                          '$textLength/500 자',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    '이미지 (최대 5장)',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(fontSize: 17),
                  ),
                  const SizedBox(height: 8),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      const spacing = 10.0;
                      final slotWidth =
                          (constraints.maxWidth -
                              (_gridColumnCount - 1) * spacing) /
                          _gridColumnCount;
                      final slotCount = _maxImageCount;

                      return Wrap(
                        spacing: spacing,
                        runSpacing: spacing,
                        children: List<Widget>.generate(slotCount, (slotIndex) {
                          final hasImage = slotIndex < _images.length;
                          final isPrimaryAddSlot =
                              !hasImage && slotIndex == _images.length;

                          if (hasImage) {
                            final item = _images[slotIndex];
                            final isDragging = _draggingIndex == slotIndex;
                            return DragTarget<int>(
                              onWillAcceptWithDetails: (details) =>
                                  details.data != slotIndex,
                              onAcceptWithDetails: (details) =>
                                  _moveImage(details.data, slotIndex),
                              builder: (context, candidateData, rejectedData) {
                                return SizedBox(
                                  width: slotWidth,
                                  height: slotWidth,
                                  child: Opacity(
                                    opacity: isDragging ? 0.45 : 1,
                                    child: LongPressDraggable<int>(
                                      data: slotIndex,
                                      onDragStarted: () => setState(
                                        () => _draggingIndex = slotIndex,
                                      ),
                                      onDragEnd: (_) =>
                                          setState(() => _draggingIndex = null),
                                      feedback: Material(
                                        color: Colors.transparent,
                                        child: SizedBox(
                                          width: slotWidth,
                                          height: slotWidth,
                                          child: ReviewImageTile(
                                            imagePath: item.path,
                                            index: slotIndex,
                                            onRemove: null,
                                          ),
                                        ),
                                      ),
                                      child: ReviewImageTile(
                                        imagePath: item.path,
                                        index: slotIndex,
                                        onRemove: () => setState(
                                          () => _images.removeAt(slotIndex),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }

                          return DragTarget<int>(
                            onWillAcceptWithDetails: (details) =>
                                details.data < _images.length,
                            onAcceptWithDetails: (details) =>
                                _moveImage(details.data, _images.length),
                            builder: (context, candidateData, rejectedData) {
                              return SizedBox(
                                width: slotWidth,
                                height: slotWidth,
                                child: _ReviewImagePlaceholderTile(
                                  showAddButton: isPrimaryAddSlot,
                                  countLabel:
                                      '${_images.length}/$_maxImageCount',
                                  onTap: isPrimaryAddSlot ? _pickImages : null,
                                ),
                              );
                            },
                          );
                        }),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '첫 번째 사진이 대표 이미지가 됩니다. 길게 눌러 순서를 바꿀 수 있어요.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  MateyaButton(
                    label: _isSubmitting ? '작성 중...' : '작성하기',
                    enabled: _canSubmit && !_isSubmitting,
                    onPressed: _canSubmit && !_isSubmitting
                        ? () async {
                            final navigator = Navigator.of(context);
                            final messenger = ScaffoldMessenger.of(context);
                            setState(() {
                              _isSubmitting = true;
                            });
                            final message = await widget.onSubmit(
                              _rating,
                              _bodyController.text,
                              _images
                                  .map((image) => image.path)
                                  .toList(growable: false),
                            );
                            if (!mounted) {
                              return;
                            }
                            setState(() {
                              _isSubmitting = false;
                            });
                            if (message == null) {
                              navigator.pop();
                              messenger.showSnackBar(
                                const SnackBar(content: Text('후기를 등록했어요.')),
                              );
                            } else {
                              messenger.showSnackBar(
                                SnackBar(content: Text(message)),
                              );
                            }
                          }
                        : null,
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

class _ReviewImagePlaceholderTile extends StatelessWidget {
  const _ReviewImagePlaceholderTile({
    required this.showAddButton,
    required this.countLabel,
    this.onTap,
  });

  final bool showAddButton;
  final String countLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final child = _DashedBorderBox(
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF6F7F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: showAddButton
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.add_a_photo_outlined,
                    size: 28,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    countLabel,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            : const SizedBox.expand(),
      ),
    );

    if (!showAddButton) {
      return child;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: child,
      ),
    );
  }
}

class _DashedBorderBox extends StatelessWidget {
  const _DashedBorderBox({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedRoundedRectPainter(),
      child: ClipRRect(borderRadius: BorderRadius.circular(12), child: child),
    );
  }
}

class _DashedRoundedRectPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const radius = Radius.circular(12);
    const dashWidth = 6.0;
    const dashGap = 4.0;

    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect.deflate(0.75), radius);
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..color = AppColors.fieldBorderLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = (distance + dashWidth).clamp(
          0.0,
          metric.length,
        ).toDouble();
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += dashWidth + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
