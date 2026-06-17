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
            MateyaSkeleton(
              child: SizedBox(
                height: 360,
                child: Stack(
                  children: <Widget>[
                    const Positioned.fill(
                      child: MateyaSkeletonBlock(height: 360, radius: 0),
                    ),
                    SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                        child: Row(
                          children: const <Widget>[
                            MateyaSkeletonBlock(
                              width: 44,
                              height: 44,
                              radius: 22,
                            ),
                            Spacer(),
                            MateyaSkeletonBlock(
                              width: 88,
                              height: 32,
                              radius: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      bottom: 20,
                      child: Row(
                        children: const <Widget>[
                          MateyaSkeletonBlock(width: 20, height: 8, radius: 8),
                          SizedBox(width: 6),
                          MateyaSkeletonBlock(width: 8, height: 8, radius: 8),
                          SizedBox(width: 6),
                          MateyaSkeletonBlock(width: 8, height: 8, radius: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 132),
              child: MateyaSkeleton(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    MateyaSkeletonBlock(height: 36, width: 240, radius: 18),
                    SizedBox(height: 14),
                    MateyaSkeletonBlock(height: 36, width: 180, radius: 18),
                    SizedBox(height: 24),
                    MateyaSkeletonBlock(height: 18, width: 164, radius: 9),
                    SizedBox(height: 12),
                    MateyaSkeletonBlock(height: 18, width: 212, radius: 9),
                    SizedBox(height: 12),
                    MateyaSkeletonBlock(height: 18, width: 148, radius: 9),
                    SizedBox(height: 12),
                    MateyaSkeletonBlock(height: 18, width: 132, radius: 9),
                    SizedBox(height: 12),
                    MateyaSkeletonBlock(height: 18, width: 224, radius: 9),
                    SizedBox(height: 28),
                    MateyaSkeletonBlock(height: 156, radius: 24),
                    SizedBox(height: 20),
                    MateyaSkeletonBlock(height: 168, radius: 24),
                    SizedBox(height: 20),
                    MateyaSkeletonBlock(height: 320, radius: 24),
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
