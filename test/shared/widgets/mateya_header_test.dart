import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/shared/widgets/mateya_header.dart';

void main() {
  testWidgets('header renders without a Scaffold material ancestor', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Column(children: <Widget>[MateyaHeader.noBackArrow()]),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(MateyaHeader), findsOneWidget);
    expect(find.byIcon(Icons.language_rounded), findsOneWidget);
  });
}
