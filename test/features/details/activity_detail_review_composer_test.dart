import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/details/presentation/widgets/activity_detail_review_composer.dart';
import 'package:mateya_app/shared/localization/mateya_localizations.dart';
import 'package:mateya_app/shared/theme/app_theme.dart';

void main() {
  testWidgets('review composer animates and updates rating stars', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildMateyaTheme(),
        locale: const Locale('ko'),
        supportedLocales: MateyaLocalizations.supportedLocales,
        localizationsDelegates: MateyaLocalizations.delegates,
        home: Scaffold(
          body: ReviewComposerSheet(
            onSubmit: (rating, body, imageUrls) async => null,
          ),
        ),
      ),
    );
    await tester.pump();

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is IconButton &&
            (widget.key as ValueKey<String>?)?.value.startsWith(
                  'review-star-',
                ) ==
                true,
      ),
      findsNWidgets(5),
    );
    expect(find.byIcon(Icons.star_border_rounded), findsNWidgets(5));

    await tester.tap(find.byKey(const ValueKey<String>('review-star-4')));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.star_rounded), findsNWidgets(4));
    expect(find.byIcon(Icons.star_border_rounded), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
