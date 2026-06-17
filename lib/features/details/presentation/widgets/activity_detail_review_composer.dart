import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  Future<void> _pickImages() async {
    final available = _maxImageCount - _images.length;
    if (available <= 0) {
      return;
    }
    final picked = await _imagePicker.pickMultiImage(imageQuality: 88);
    if (!mounted || picked.isEmpty) {
      return;
    }
    setState(() {
      _images.addAll(picked.take(available));
    });
  }

  void _moveImage(int fromIndex, int toIndex) {
    if (fromIndex == toIndex) {
      return;
    }
    setState(() {
      final item = _images.removeAt(fromIndex);
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
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '사진 첨부 (${_images.length}/$_maxImageCount)',
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(fontSize: 17),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _images.length >= _maxImageCount
                            ? null
                            : _pickImages,
                        icon: const Icon(Icons.add_photo_alternate_outlined),
                        label: const Text('추가'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_images.isNotEmpty)
                    SizedBox(
                      height: 92,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => DragTarget<int>(
                          onWillAcceptWithDetails: (details) =>
                              details.data != index,
                          onAcceptWithDetails: (details) =>
                              _moveImage(details.data, index),
                          builder: (context, candidateData, rejectedData) {
                            final item = _images[index];
                            final isDragging = _draggingIndex == index;
                            return Opacity(
                              opacity: isDragging ? 0.6 : 1,
                              child: LongPressDraggable<int>(
                                data: index,
                                onDragStarted: () =>
                                    setState(() => _draggingIndex = index),
                                onDragEnd: (_) =>
                                    setState(() => _draggingIndex = null),
                                feedback: Material(
                                  color: Colors.transparent,
                                  child: ReviewImageTile(
                                    imagePath: item.path,
                                    index: index,
                                    onRemove: null,
                                  ),
                                ),
                                child: ReviewImageTile(
                                  imagePath: item.path,
                                  index: index,
                                  onRemove: () =>
                                      setState(() => _images.removeAt(index)),
                                ),
                              ),
                            );
                          },
                        ),
                        separatorBuilder: (_, _) => const SizedBox(width: 10),
                        itemCount: _images.length,
                      ),
                    )
                  else
                    Container(
                      height: 92,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.divider),
                        color: AppColors.subtleBackground,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '첫 번째 사진이 대표 이미지가 됩니다. 길게 눌러 순서를 바꿀 수 있어요.',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
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
