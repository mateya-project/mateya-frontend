import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/home/domain/nearby_culture_map_models.dart';
import 'package:mateya_app/features/home/presentation/widgets/nearby_culture_map_widgets.dart';
import 'package:mateya_app/shared/localization/mateya_localizations.dart';
import 'package:mateya_app/shared/theme/app_theme.dart';

void main() {
  testWidgets('nearby culture map carousel does not overflow on compact cards', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: buildMateyaTheme(),
        locale: const Locale('zh'),
        supportedLocales: MateyaLocalizations.supportedLocales,
        localizationsDelegates: MateyaLocalizations.delegates,
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 350,
              child: NearbyCultureMapPlaceCarousel(
                places: const <NearbyCultureMapPlace>[
                  NearbyCultureMapPlace(
                    id: 'place-1',
                    name: '논현동 문화예술 산책 코스',
                    address: '서울 강남구 논현동 123-45 문화예술거리 야외광장 앞',
                    distanceKm: 1.2,
                    categoryDetailName: '문화 · 전통',
                  ),
                ],
                selectedPlaceId: 'place-1',
                onPlaceChanged: _noopOnPlaceChanged,
                onListButtonTap: _noop,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.byType(NearbyCultureMapPlaceCarousel), findsOneWidget);
  });
}

void _noop() {}

void _noopOnPlaceChanged(String _) {}
