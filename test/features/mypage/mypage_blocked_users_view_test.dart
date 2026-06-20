import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/mypage/domain/mypage_models.dart';
import 'package:mateya_app/features/mypage/presentation/widgets/mypage_route_views.dart';
import 'package:mateya_app/shared/localization/mateya_localizations.dart';
import 'package:mateya_app/shared/theme/app_theme.dart';

void main() {
  testWidgets('blocked users view exposes unblock action', (tester) async {
    String? unblockedUserId;

    await tester.pumpWidget(
      MaterialApp(
        theme: buildMateyaTheme(),
        locale: const Locale('ko'),
        supportedLocales: MateyaLocalizations.supportedLocales,
        localizationsDelegates: MateyaLocalizations.delegates,
        home: Scaffold(
          body: BlockedUsersView(
            users: const <BlockedUserSummary>[
              BlockedUserSummary(
                id: 'blocked-1',
                name: '최성현',
                residence: '마로면',
              ),
            ],
            onBack: _noop,
            onUnblock: (userId) {
              unblockedUserId = userId;
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('차단 해제'), findsOneWidget);

    await tester.tap(find.text('차단 해제'));
    await tester.pump();

    expect(unblockedUserId, 'blocked-1');
  });
}

void _noop() {}
