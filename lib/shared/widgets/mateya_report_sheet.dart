import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../media/image_picker_lost_data.dart';
import '../permissions/mateya_permission_dialogs.dart';
import '../theme/app_tokens.dart';
import 'mateya_button.dart';

const String mateyaReportIconSvg = '''
<svg preserveAspectRatio="none" width="100%" height="100%" overflow="visible" style="display: block;" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<g>
<path d="M12.7707 2.77886C12.7707 2.34871 12.422 2 11.9918 2C11.5617 2 11.213 2.34871 11.213 2.77886V5.39292C11.213 5.82307 11.5617 6.17178 11.9918 6.17178C12.422 6.17178 12.7707 5.82307 12.7707 5.39292V2.77886Z" fill="#33363D"/>
<path d="M4.10491 4.07271C3.78712 3.78282 3.29449 3.80544 3.0046 4.12324C2.71471 4.44103 2.73733 4.93366 3.05513 5.22355L5.21807 7.19656C5.53587 7.48645 6.0285 7.46382 6.31839 7.14603C6.60828 6.82823 6.58565 6.3356 6.26786 6.04571L4.10491 4.07271Z" fill="#33363D"/>
<path d="M20.9283 5.22354C21.2461 4.93364 21.2687 4.44102 20.9788 4.12322C20.6889 3.80543 20.1963 3.78282 19.8785 4.07272L17.7157 6.04572C17.3979 6.33562 17.3753 6.82825 17.6652 7.14604C17.9551 7.46383 18.4477 7.48644 18.7655 7.19655L20.9283 5.22354Z" fill="#33363D"/>
<path d="M17.8666 14.5C18.5372 14.5 19.0173 13.8535 18.8246 13.2112L17.6233 9.2067C17.4962 8.78324 17.1065 8.49324 16.6644 8.49324H7.34197C6.89987 8.49324 6.51011 8.78324 6.38307 9.20669L5.18172 13.2112C4.98902 13.8535 5.46912 14.5 6.13974 14.5H17.8666Z" fill="#33363D"/>
<path d="M20.0205 21.0003H3.98661C3.37856 21.0003 3.07453 21.0003 2.87162 20.8734C2.6939 20.7624 2.56451 20.5885 2.50917 20.3863C2.44598 20.1555 2.53334 19.8643 2.70807 19.2819L3.358 17.1154C3.45152 16.8037 3.49828 16.6478 3.58682 16.5295C3.68375 16.3999 3.81627 16.3013 3.96824 16.2457C4.10706 16.1949 4.26979 16.1949 4.59525 16.1949H19.4119C19.7373 16.1949 19.9001 16.1949 20.0389 16.2457C20.1909 16.3013 20.3234 16.3999 20.4203 16.5295C20.5089 16.6479 20.5556 16.8037 20.6491 17.1154L21.2991 19.2819C21.4738 19.8643 21.5611 20.1555 21.498 20.3863C21.4426 20.5885 21.3132 20.7624 21.1355 20.8734C20.9326 21.0003 20.6286 21.0003 20.0205 21.0003Z" fill="#33363D"/>
</g>
</svg>
''';

class MateyaReportIcon extends StatelessWidget {
  const MateyaReportIcon({
    super.key,
    this.size = 24,
    this.color = AppColors.textPrimary,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      mateyaReportIconSvg,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      semanticsLabel: '신고하기',
    );
  }
}

Future<void> showMateyaReportSheet(
  BuildContext context, {
  required String subjectLabel,
  Future<String?> Function(String body, List<XFile> images)? onSubmit,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) =>
        MateyaReportSheet(subjectLabel: subjectLabel, onSubmit: onSubmit),
  );
}

class MateyaReportSheet extends StatefulWidget {
  const MateyaReportSheet({
    super.key,
    required this.subjectLabel,
    this.onSubmit,
  });

  final String subjectLabel;
  final Future<String?> Function(String body, List<XFile> images)? onSubmit;

  @override
  State<MateyaReportSheet> createState() => _MateyaReportSheetState();
}

class _MateyaReportSheetState extends State<MateyaReportSheet> {
  static const int _maxImageCount = 5;

  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _bodyController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<XFile> _images = <XFile>[];

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

  bool get _canSubmit => _bodyController.text.trim().isNotEmpty;

  Future<void> _restoreLostImages() async {
    final recovery = await recoverLostImagePickerData(
      _imagePicker.retrieveLostData,
      fallbackErrorMessage: '이전에 선택하던 신고 이미지를 복구하지 못했어요. 다시 선택해 주세요.',
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
      SnackBar(content: Text('이전에 선택하던 신고 이미지 ${restored.length}장을 복구했어요.')),
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
          '신고 이미지 첨부를 사용하려면 사진 보관함 접근 권한이 필요합니다. 권한이 없어도 신고 사유 텍스트 작성은 계속할 수 있습니다.',
      confirmLabel: '사진 선택하기',
      cancelLabel: '나중에',
      rememberKey: 'permission.notice.photo_library',
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
              '신고 이미지 첨부를 사용하려면 사진 보관함 접근 권한이 필요합니다. 다시 시도하거나 앱 설정에서 권한을 허용할 수 있습니다.',
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

  Future<void> _submit() async {
    if (!_canSubmit || _isSubmitting) {
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final submit =
        widget.onSubmit ??
        (String body, List<XFile> images) async {
          return null;
        };

    setState(() {
      _isSubmitting = true;
    });

    final message = await submit(
      _bodyController.text.trim(),
      List<XFile>.unmodifiable(_images),
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
        SnackBar(content: Text('${widget.subjectLabel} 신고가 접수되었어요.')),
      );
      return;
    }

    messenger.showSnackBar(SnackBar(content: Text(message)));
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
                          '신고하기',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
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
                          decoration: const InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                            hintText:
                                '신고 사유를 구체적으로 작성해주세요.\n'
                                '(예: 욕설, 사기 의심, 부적절한 게시물,\n'
                                '스팸, 괴롭힘 등) 신고 내용은 운영 정책에\n'
                                '따라 검토됩니다.',
                          ),
                          style: Theme.of(context).textTheme.bodyLarge,
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
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 92,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _maxImageCount,
                      separatorBuilder: (_, _) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        if (index < _images.length) {
                          return _ReportImageTile(
                            image: _images[index],
                            onRemove: () =>
                                setState(() => _images.removeAt(index)),
                          );
                        }
                        if (index == _images.length &&
                            _images.length < _maxImageCount) {
                          return _ReportPickerTile(
                            countLabel: '${_images.length}/$_maxImageCount',
                            onTap: _pickImages,
                          );
                        }
                        return const _ReportEmptyTile();
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  MateyaButton(
                    label: _isSubmitting ? '접수 중...' : '신고하기',
                    enabled: _canSubmit && !_isSubmitting,
                    onPressed: _submit,
                  ),
                  const SizedBox(height: 14),
                  Center(
                    child: Text(
                      '접수된 신고는 영업일 기준 최대 7일 이내에 검토되며,\n'
                      '허위 신고 또는 신고 사유가 불명확한 경우 처리되지 않을 수 있습니다.',
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

class _ReportImageTile extends StatelessWidget {
  const _ReportImageTile({required this.image, required this.onRemove});

  final XFile image;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            width: 92,
            height: 92,
            child: FutureBuilder<Uint8List>(
              future: image.readAsBytes(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Image.memory(snapshot.data!, fit: BoxFit.cover);
                }
                return const ColoredBox(color: AppColors.subtleBackground);
              },
            ),
          ),
        ),
        Positioned(
          right: 6,
          top: 6,
          child: InkWell(
            onTap: onRemove,
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.58),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close_rounded,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ReportPickerTile extends StatelessWidget {
  const _ReportPickerTile({required this.countLabel, required this.onTap});

  final String countLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _DashedTile(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.photo_camera_outlined,
            color: AppColors.textMuted,
            size: 30,
          ),
          const SizedBox(height: 4),
          Text(countLabel, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _ReportEmptyTile extends StatelessWidget {
  const _ReportEmptyTile();

  @override
  Widget build(BuildContext context) {
    return const _DashedTile();
  }
}

class _DashedTile extends StatelessWidget {
  const _DashedTile({this.onTap, this.child});

  final VoidCallback? onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final tile = CustomPaint(
      painter: const _DashedRoundedRectPainter(
        color: AppColors.fieldBorderLight,
      ),
      child: Container(
        width: 92,
        height: 92,
        decoration: BoxDecoration(
          color: AppColors.subtleBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: child,
      ),
    );

    if (onTap == null) {
      return tile;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: tile,
    );
  }
}

class _DashedRoundedRectPainter extends CustomPainter {
  const _DashedRoundedRectPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 1.0;
    const dashWidth = 6.0;
    const dashGap = 4.0;
    const radius = 16.0;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance = next + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRoundedRectPainter oldDelegate) {
    return color != oldDelegate.color;
  }
}
