import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/shared/widgets/mateya_skeleton.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'MateyaSkeleton keeps placeholder geometry while mounting shimmer',
    (tester) async {
      const primaryKey = ValueKey<String>('primary-skeleton-block');

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MateyaSkeleton(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MateyaSkeletonBlock(
                    key: primaryKey,
                    width: 120,
                    height: 24,
                    radius: 12,
                  ),
                  SizedBox(height: 12),
                  MateyaSkeletonBlock(height: 64, radius: 18),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(MateyaSkeleton), findsOneWidget);
      expect(find.byType(ShaderMask), findsOneWidget);
      expect(tester.getSize(find.byKey(primaryKey)), const Size(120, 24));

      await tester.pump(const Duration(milliseconds: 250));

      expect(tester.takeException(), isNull);
    },
  );
}
