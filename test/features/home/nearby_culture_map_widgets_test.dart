import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/home/domain/nearby_culture_map_models.dart';
import 'package:mateya_app/features/home/presentation/widgets/nearby_culture_map_widgets.dart';

void main() {
  testWidgets('carousel exposes list button and swipe changes place', (
    tester,
  ) async {
    final changedIds = <String>[];
    var listTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NearbyCultureMapPlaceCarousel(
            places: const <NearbyCultureMapPlace>[
              NearbyCultureMapPlace(
                id: 'place-1',
                name: '경복궁',
                address: '서울 종로구 사직로 161',
                distanceKm: 1.2,
              ),
              NearbyCultureMapPlace(
                id: 'place-2',
                name: '창덕궁',
                address: '서울 종로구 율곡로 99',
                distanceKm: 1.9,
              ),
            ],
            selectedPlaceId: 'place-1',
            onPlaceChanged: changedIds.add,
            onListButtonTap: () {
              listTapped = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('목록보기'), findsOneWidget);
    expect(find.text('1 / 2'), findsOneWidget);

    await tester.tap(find.text('목록보기'));
    await tester.pump();

    expect(listTapped, isTrue);

    await tester.fling(find.byType(PageView), const Offset(-500, 0), 1200);
    await tester.pumpAndSettle();

    expect(changedIds, contains('place-2'));
    expect(find.text('2 / 2'), findsOneWidget);
  });
}
