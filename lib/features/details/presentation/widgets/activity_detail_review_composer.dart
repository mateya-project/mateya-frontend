import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../shared/localization/mateya_localizations.dart';
import '../../../../shared/media/mateya_gallery_picker.dart';
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

  MateyaGalleryPickerMessages _galleryPickerMessages(BuildContext context) {
    final l10n = context.l10n;
    return MateyaGalleryPickerMessages(
      noticeMessage: l10n.detailsReviewGalleryNotice,
      recoveryMessage: l10n.detailsReviewGalleryRecovery,
      failureMessage: l10n.detailsReviewGalleryFailure,
      restoreFallbackErrorMessage: l10n.detailsReviewGalleryRestoreError,
      restoredCountMessage: (restoredCount) =>
          l10n.detailsReviewRestoredCount(restoredCount),
    );
  }

  Future<void> _restoreLostImages() async {
    await restoreLostMateyaGalleryImages(
      context: context,
      readLostData: _imagePicker.retrieveLostData,
      availableSlots: _maxImageCount - _images.length,
      messages: _galleryPickerMessages(context),
      onRestored: (files) async {
        if (!mounted || files.isEmpty) {
          return;
        }
        setState(() {
          _images.addAll(files);
        });
      },
    );
  }

  Future<void> _pickImages() async {
    final available = _maxImageCount - _images.length;
    if (available <= 0) {
      return;
    }

    final picked = await pickMateyaGalleryImages(
      context,
      imagePicker: _imagePicker,
      availableSlots: available,
      messages: _galleryPickerMessages(context),
    );
    if (!mounted || picked.isEmpty) {
      return;
    }
    setState(() {
      _images.addAll(picked);
    });
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

  Future<void> _submit() async {
    if (!_canSubmit || _isSubmitting) {
      return;
    }

    final l10n = context.l10n;
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    setState(() {
      _isSubmitting = true;
    });

    final message = await widget.onSubmit(
      _rating,
      _bodyController.text.trim(),
      _images.map((image) => image.path).toList(growable: false),
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
        SnackBar(content: Text(l10n.detailsReviewSubmitted)),
      );
      return;
    }

    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
                          l10n.detailsReviewComposerTitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List<Widget>.generate(5, (index) {
                      final star = index + 1;
                      final isActive = star <= _rating;
                      return IconButton(
                        onPressed: () => setState(() => _rating = star),
                        visualDensity: VisualDensity.compact,
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
                      color: AppColors.subtleBackground,
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
                          maxLines: 5,
                          maxLength: 500,
                          decoration: InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                            hintText: l10n.detailsReviewComposerHint,
                          ),
                          style: Theme.of(context).textTheme.bodyLarge,
                          onChanged: (_) => setState(() {}),
                        ),
                        Text(
                          l10n.detailsBodyCount(textLength, 500),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    l10n.detailsReviewImageSectionTitle(_maxImageCount),
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(fontSize: 17),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 92,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _maxImageCount,
                      separatorBuilder: (_, _) => const SizedBox(width: 10),
                      itemBuilder: (context, slotIndex) {
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
                                width: 92,
                                height: 92,
                                child: Opacity(
                                  opacity: isDragging ? 0.45 : 1,
                                  child: LongPressDraggable<int>(
                                    data: slotIndex,
                                    onDragStarted: () => setState(
                                      () => _draggingIndex = slotIndex,
                                    ),
                                    onDragEnd: (_) =>
                                        setState(() => _draggingIndex = null),
                                    childWhenDragging: ReviewImageTile(
                                      imagePath: item.path,
                                      index: slotIndex,
                                      onRemove: null,
                                    ),
                                    feedback: Material(
                                      color: Colors.transparent,
                                      child: SizedBox(
                                        width: 92,
                                        height: 92,
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
                              width: 92,
                              height: 92,
                              child: _ReviewImagePlaceholderTile(
                                showAddButton: isPrimaryAddSlot,
                                countLabel: '${_images.length}/$_maxImageCount',
                                onTap: isPrimaryAddSlot ? _pickImages : null,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  MateyaButton(
                    label: _isSubmitting
                        ? l10n.detailsReviewSubmitting
                        : l10n.detailsReviewSubmit,
                    enabled: _canSubmit && !_isSubmitting,
                    onPressed: _canSubmit && !_isSubmitting ? _submit : null,
                  ),
                  const SizedBox(height: 14),
                  Center(
                    child: Text(
                      l10n.detailsReviewImageGuide,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
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
          color: AppColors.subtleBackground,
          borderRadius: BorderRadius.circular(16),
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
        borderRadius: BorderRadius.circular(16),
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
      child: ClipRRect(borderRadius: BorderRadius.circular(16), child: child),
    );
  }
}

class _DashedRoundedRectPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const radius = Radius.circular(16);
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
        final next = (distance + dashWidth)
            .clamp(0.0, metric.length)
            .toDouble();
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += dashWidth + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
