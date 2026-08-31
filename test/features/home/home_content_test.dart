import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/ai/data/ai_repository.dart';
import 'package:mateya_app/features/home/application/home_controller.dart';
import 'package:mateya_app/features/home/data/home_repository.dart';
import 'package:mateya_app/features/home/domain/home_models.dart';
import 'package:mateya_app/features/home/presentation/widgets/home_content.dart';
import 'package:mateya_app/features/onboarding/domain/onboarding_flow.dart';
import 'package:mateya_app/shared/activity_categories/activity_category_repository.dart';
import 'package:mateya_app/shared/localization/mateya_localizations.dart';
import 'package:mateya_app/shared/theme/app_theme.dart';

void main() {
  testWidgets('trending title uses an icon instead of an unsupported emoji', (
    tester,
  ) async {
    final controller = HomeController(
      repository: _EmptyHomeRepository(),
      categoryRepository: MockActivityCategoryRepository(),
      flowKind: FlowKind.guest,
    );
    await controller.initialize();

    await tester.pumpWidget(
      MaterialApp(
        theme: buildMateyaTheme(),
        locale: const Locale('ko'),
        localizationsDelegates: MateyaLocalizations.delegates,
        supportedLocales: MateyaLocalizations.supportedLocales,
        home: Scaffold(
          body: HomeContent(
            controller: controller,
            onActivityTap: (_) {},
            aiRepository: MockAiRepository(),
            onAiTap: () {},
            onPlaceTap: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('인기 급상승'), findsOneWidget);
    expect(find.textContaining('🔥'), findsNothing);
    expect(
      find.byKey(const ValueKey<String>('home-trending-icon')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}

class _EmptyHomeRepository implements HomeRepository {
  @override
  Future<List<ActivityItem>> fetchHomeActivities() async =>
      const <ActivityItem>[];

  @override
  Future<ExploreActivitiesPage> fetchExploreActivities({
    required int page,
    required String keyword,
    required ExploreFilter filter,
  }) async => ExploreActivitiesPage(
    items: const <ActivityItem>[],
    page: page,
    size: 20,
    hasNext: false,
    nextPage: null,
  );

  @override
  Future<List<ActivityItem>> fetchFavoriteActivities() async =>
      const <ActivityItem>[];
}
