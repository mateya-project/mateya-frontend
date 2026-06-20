import 'package:flutter/material.dart';

import '../../../../shared/theme/app_tokens.dart';
import '../../../../shared/widgets/mateya_skeleton.dart';

class DetailLoadingState extends StatelessWidget {
  const DetailLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ListView(
          children: <Widget>[
            const SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: <Widget>[
                    MateyaSkeleton(
                      child: MateyaSkeletonBlock(
                        width: 32,
                        height: 32,
                        radius: 16,
                      ),
                    ),
                    Spacer(),
                    MateyaSkeleton(
                      child: MateyaSkeletonBlock(
                        width: 40,
                        height: 40,
                        radius: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: MateyaSkeleton(
                child: SizedBox(
                  height: 324,
                  child: Stack(
                    children: <Widget>[
                      const Positioned.fill(
                        child: MateyaSkeletonBlock(height: 324, radius: 20),
                      ),
                      const Positioned(
                        left: 12,
                        top: 12,
                        child: MateyaSkeletonBlock(
                          width: 86,
                          height: 28,
                          radius: 14,
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 14,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            MateyaSkeletonBlock(
                              width: 16,
                              height: 6,
                              radius: 6,
                            ),
                            SizedBox(width: 6),
                            MateyaSkeletonBlock(width: 6, height: 6, radius: 6),
                            SizedBox(width: 6),
                            MateyaSkeletonBlock(width: 6, height: 6, radius: 6),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 132),
              child: MateyaSkeleton(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    MateyaSkeletonBlock(height: 30, width: 248, radius: 15),
                    SizedBox(height: 10),
                    MateyaSkeletonBlock(height: 30, width: 188, radius: 15),
                    SizedBox(height: 20),
                    _DetailInfoLineSkeleton(width: 176),
                    SizedBox(height: 10),
                    _DetailInfoLineSkeleton(width: 168),
                    SizedBox(height: 10),
                    _DetailInfoLineSkeleton(width: 152),
                    SizedBox(height: 10),
                    _DetailInfoLineSkeleton(width: 142),
                    SizedBox(height: 10),
                    _DetailInfoLineSkeleton(width: 216),
                    SizedBox(height: 28),
                    _DetailSectionCardSkeleton(
                      height: 154,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              MateyaSkeletonBlock(
                                height: 22,
                                width: 116,
                                radius: 11,
                              ),
                              Spacer(),
                              MateyaSkeletonBlock(
                                height: 18,
                                width: 88,
                                radius: 9,
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          MateyaSkeletonBlock(
                            height: 10,
                            width: double.infinity,
                            radius: 999,
                          ),
                          SizedBox(height: 18),
                          MateyaSkeletonBlock(
                            height: 40,
                            width: 214,
                            radius: 20,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    _DetailSectionCardSkeleton(
                      height: 90,
                      child: Row(
                        children: <Widget>[
                          MateyaSkeletonBlock(
                            width: 54,
                            height: 54,
                            radius: 27,
                          ),
                          SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                MateyaSkeletonBlock(
                                  height: 20,
                                  width: 142,
                                  radius: 10,
                                ),
                                SizedBox(height: 8),
                                MateyaSkeletonBlock(
                                  height: 16,
                                  width: 96,
                                  radius: 8,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    MateyaSkeletonBlock(height: 28, width: 108, radius: 14),
                    SizedBox(height: 10),
                    MateyaSkeletonBlock(
                      height: 18,
                      width: double.infinity,
                      radius: 9,
                    ),
                    SizedBox(height: 10),
                    MateyaSkeletonBlock(
                      height: 18,
                      width: double.infinity,
                      radius: 9,
                    ),
                    SizedBox(height: 10),
                    MateyaSkeletonBlock(height: 18, width: 264, radius: 9),
                    SizedBox(height: 28),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: MateyaSkeletonBlock(
                            height: 28,
                            width: 126,
                            radius: 14,
                          ),
                        ),
                        SizedBox(width: 20),
                        MateyaSkeletonBlock(height: 18, width: 56, radius: 9),
                      ],
                    ),
                    SizedBox(height: 12),
                    _DetailSectionCardSkeleton(height: 168),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 24,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
                child: MateyaSkeleton(
                  child: Row(
                    children: const <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            MateyaSkeletonBlock(
                              width: 52,
                              height: 12,
                              radius: 6,
                            ),
                            SizedBox(height: 8),
                            MateyaSkeletonBlock(
                              width: 96,
                              height: 20,
                              radius: 10,
                            ),
                          ],
                        ),
                      ),
                      MateyaSkeletonBlock(width: 44, height: 44, radius: 22),
                      SizedBox(width: 10),
                      MateyaSkeletonBlock(width: 44, height: 44, radius: 22),
                      SizedBox(width: 12),
                      MateyaSkeletonBlock(width: 146, height: 54, radius: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailInfoLineSkeleton extends StatelessWidget {
  const _DetailInfoLineSkeleton({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const MateyaSkeletonBlock(width: 18, height: 18, radius: 9),
        const SizedBox(width: 10),
        MateyaSkeletonBlock(height: 18, width: width, radius: 9),
      ],
    );
  }
}

class _DetailSectionCardSkeleton extends StatelessWidget {
  const _DetailSectionCardSkeleton({required this.height, this.child});

  final double height;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: child,
    );
  }
}

class DetailErrorState extends StatelessWidget {
  const DetailErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.travel_explore_rounded, size: 40),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.brandGreen,
              ),
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }
}
