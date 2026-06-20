import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mateya_app/features/home/domain/home_models.dart';
import 'package:mateya_app/features/home/presentation/widgets/home_activity_cards.dart';
import 'package:mateya_app/shared/theme/app_theme.dart';

void main() {
  testWidgets('featured card does not render the unused top-right heart', (
    tester,
  ) async {
    await initializeDateFormatting('ko');

    await tester.pumpWidget(
      MaterialApp(
        theme: buildMateyaTheme(),
        home: Scaffold(
          body: FeaturedActivityCard(activity: _activity(), onTap: () {}),
        ),
      ),
    );

    expect(find.byIcon(Icons.favorite_border_rounded), findsNothing);
  });

  testWidgets('compact row expands without vertical overflow for long copy', (
    tester,
  ) async {
    await initializeDateFormatting('ko');

    await tester.pumpWidget(
      MaterialApp(
        theme: buildMateyaTheme(),
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 350,
              child: CompactActivityRow(
                activity: _activity().copyWith(
                  title: '수원화성의 도시, 수원에서 즐기는 특별한 여행과 로컬 메이트 문화 체험',
                  categoryLabel: '전통문화 체험 코스',
                ),
                onTap: () {},
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}

ActivityItem _activity() {
  return ActivityItem(
    id: 'featured-1',
    categoryId: 'travel',
    categoryLabel: 'Travel course',
    title: '수원화성의 도시, 수원에서 즐기는 특별한 여행',
    place: '수원화성',
    startAt: DateTime(2026, 6, 23, 19),
    endAt: DateTime(2026, 6, 23, 20),
    price: 0,
    rating: 0,
    participantCount: 2,
    participantCapacity: 10,
    distanceKm: 1,
    audiences: const <ActivityAudienceOption>{ActivityAudienceOption.everyone},
    languages: const <String>{'ko'},
    statuses: const <ActivityStatusOption>{ActivityStatusOption.recruiting},
    imageUrl: 'https://example.com/featured.jpg',
  );
}
