import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/details/domain/activity_detail_models.dart';
import 'package:mateya_app/features/details/presentation/widgets/activity_detail_review_widgets.dart';
import 'package:mateya_app/shared/localization/mateya_localizations.dart';
import 'package:mateya_app/shared/theme/app_theme.dart';

void main() {
  testWidgets('ReviewCard shows translation toggle labels', (tester) async {
    Widget buildSubject(ActivityReview review) {
      return MaterialApp(
        theme: buildMateyaTheme(),
        locale: const Locale('ko'),
        supportedLocales: MateyaLocalizations.supportedLocales,
        localizationsDelegates: MateyaLocalizations.delegates,
        home: Scaffold(
          body: ReviewCard(
            review: review,
            onHelpfulTap: () {},
            onTranslationTap: () {},
            onAuthorTap: () {},
          ),
        ),
      );
    }

    await tester.pumpWidget(
      buildSubject(
        ActivityReview(
          id: 'review-1',
          authorName: '김민우',
          submittedAt: DateTime(2026, 1, 23),
          rating: 4,
          originalText: '원문 후기입니다.',
          translatedText: 'Translated review body.',
          isTranslationVisible: true,
        ),
      ),
    );

    expect(find.text('원문 보기'), findsOneWidget);
    expect(find.text('Translated review body.'), findsOneWidget);

    await tester.pumpWidget(
      buildSubject(
        ActivityReview(
          id: 'review-2',
          authorName: '김민우',
          submittedAt: DateTime(2026, 1, 23),
          rating: 4,
          originalText: '원문 후기입니다.',
          translatedText: 'Translated review body.',
        ),
      ),
    );

    expect(find.text('번역 보기'), findsOneWidget);
    expect(find.text('원문 후기입니다.'), findsOneWidget);
  });

  testWidgets('ReviewCard triggers author tap from profile area', (
    tester,
  ) async {
    var tapCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        theme: buildMateyaTheme(),
        locale: const Locale('ko'),
        supportedLocales: MateyaLocalizations.supportedLocales,
        localizationsDelegates: MateyaLocalizations.delegates,
        home: Scaffold(
          body: ReviewCard(
            review: ActivityReview(
              id: 'review-3',
              authorUserId: 'user-123',
              authorName: '최성현',
              submittedAt: DateTime(2026, 6, 20),
              rating: 5,
              originalText: 'gd',
            ),
            onAuthorTap: () {
              tapCount += 1;
            },
            onHelpfulTap: () {},
            onTranslationTap: null,
          ),
        ),
      ),
    );

    await tester.tap(find.text('최성현'));
    await tester.pump();

    expect(tapCount, 1);
  });

  testWidgets('ReviewCard shows filled heart when review is helpful by me', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildMateyaTheme(),
        locale: const Locale('ko'),
        supportedLocales: MateyaLocalizations.supportedLocales,
        localizationsDelegates: MateyaLocalizations.delegates,
        home: Scaffold(
          body: ReviewCard(
            review: ActivityReview(
              id: 'review-4',
              authorName: '김민우',
              submittedAt: DateTime(2026, 6, 20),
              rating: 5,
              originalText: '좋았어요.',
              isHelpfulByMe: true,
            ),
            onAuthorTap: () {},
            onHelpfulTap: () {},
            onTranslationTap: null,
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border_rounded), findsNothing);
  });

  testWidgets('ReviewCard exposes owner menu actions when provided', (
    tester,
  ) async {
    var didEdit = false;
    var didDelete = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: buildMateyaTheme(),
        locale: const Locale('en'),
        supportedLocales: MateyaLocalizations.supportedLocales,
        localizationsDelegates: MateyaLocalizations.delegates,
        home: Scaffold(
          body: ReviewCard(
            review: ActivityReview(
              id: 'review-5',
              authorName: 'Mateya',
              submittedAt: DateTime(2026, 6, 20),
              rating: 4,
              originalText: 'Helpful review.',
            ),
            onAuthorTap: () {},
            onHelpfulTap: () {},
            onTranslationTap: null,
            onEditTap: () => didEdit = true,
            onDeleteTap: () => didDelete = true,
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.more_horiz_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Edit'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);

    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    expect(didEdit, isTrue);
    expect(didDelete, isFalse);
  });
}
