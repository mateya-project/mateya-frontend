import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/mypage/domain/mypage_models.dart';
import 'package:mateya_app/features/mypage/presentation/widgets/mypage_route_views.dart';

void main() {
  testWidgets('consent history view forwards detail action', (tester) async {
    ConsentHistoryEntry? tappedEntry;
    const entry = ConsentHistoryEntry(
      id: 'service_terms',
      title: '서비스 이용 약관',
      agreed: true,
      agreedAtLabel: '2026.06.19',
      versionLabel: 'v1.0',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ConsentHistoryView(
            entries: const <ConsentHistoryEntry>[entry],
            onBack: () {},
            onOpenDetail: (selected) {
              tappedEntry = selected;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('자세히 보기'));
    await tester.pump();

    expect(tappedEntry?.id, entry.id);
  });

  testWidgets('consent history view shows empty state', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ConsentHistoryView(
            entries: const <ConsentHistoryEntry>[],
            onBack: () {},
            onOpenDetail: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('아직 저장된 동의 내역이 없어요.'), findsOneWidget);
    expect(find.text('자세히 보기'), findsNothing);
  });
}
