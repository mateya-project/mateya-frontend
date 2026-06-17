import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mateya_app/features/create/presentation/widgets/create_place_widgets.dart';
import 'package:mateya_app/shared/widgets/mateya_skeleton.dart';

void main() {
  testWidgets('LoadingPlaceList uses MateyaSkeleton placeholders', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: LoadingPlaceList())),
    );

    expect(find.byType(LoadingPlaceList), findsOneWidget);
    expect(find.byType(MateyaSkeleton), findsOneWidget);
    expect(find.byType(MateyaSkeletonBlock), findsNWidgets(15));
  });
}
