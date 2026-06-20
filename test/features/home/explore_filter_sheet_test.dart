import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/home/domain/home_models.dart';
import 'package:mateya_app/features/home/presentation/widgets/explore_filter_sheet.dart';
import 'package:mateya_app/shared/localization/mateya_localizations.dart';

void main() {
  testWidgets('explore filter sheet stays stable on compact height', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(375, 667);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ko'),
        supportedLocales: MateyaLocalizations.supportedLocales,
        localizationsDelegates: MateyaLocalizations.delegates,
        home: MediaQuery(
          data: const MediaQueryData(viewInsets: EdgeInsets.only(bottom: 220)),
          child: Material(
            child: ExploreFilterSheet(
              categories: const <ActivityCategory>[
                ActivityCategory(id: 'all', label: '전체', isAll: true),
                ActivityCategory(id: 'culture', label: '문화/전통'),
              ],
              initialFilter: const ExploreFilter(),
              defaultFilter: const ExploreFilter(),
              validator: (_) => null,
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.byType(ExploreFilterSheet), findsOneWidget);
  });
}
