import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../shared/localization/mateya_localizations.dart';
import '../../../../shared/theme/app_responsive.dart';
import '../../../../shared/theme/app_tokens.dart';
import '../../../onboarding/domain/onboarding_flow.dart';
import '../../application/home_controller.dart';
import '../../domain/home_models.dart';
import 'home_activity_cards.dart';
import 'home_feedback_states.dart';
import 'home_search_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.controller,
    required this.onSearchTap,
    required this.onActivityTap,
  });

  final HomeController controller;
  final VoidCallback onSearchTap;
  final ValueChanged<ActivityItem> onActivityTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: AppResponsive.contentMaxWidth(context),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 16),
              HomeSearchBar(
                readOnly: true,
                hintText: l10n.homeSearchHeroHint,
                helperText: l10n.homeSearchHeroHelper,
                onTap: onSearchTap,
                onFilterTap: onSearchTap,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: HomeContent(
                  controller: controller,
                  onActivityTap: onActivityTap,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({
    super.key,
    required this.controller,
    required this.onActivityTap,
  });

  final HomeController controller;
  final ValueChanged<ActivityItem> onActivityTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    switch (controller.homePhase) {
      case AsyncPhase.loading:
      case AsyncPhase.idle:
        return const HomeSkeleton();
      case AsyncPhase.networkError:
      case AsyncPhase.serverError:
        return RetryState(
          message: controller.homeErrorMessage ?? l10n.homeLoadError,
          onRetry: controller.retry,
        );
      case AsyncPhase.success:
      case AsyncPhase.validationError:
        final featured = controller.featuredActivity;
        final popular = controller.homePopularActivities;
        return ListView(
          key: const PageStorageKey<String>('home-content-scroll'),
          padding: const EdgeInsets.only(bottom: 24),
          children: <Widget>[
            Text(
              l10n.homeTrendingTitle,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 16),
            if (featured != null)
              FeaturedActivityCard(
                activity: featured,
                onTap: () => onActivityTap(featured),
              ),
            const SizedBox(height: 24),
            Text(
              l10n.homeSharedExperiencesTitle,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 23),
            for (final activity in popular) ...<Widget>[
              VerticalActivityCard(
                activity: activity,
                onTap: () => onActivityTap(activity),
              ),
              const SizedBox(height: 32),
            ],
          ],
        );
    }
  }
}

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({
    super.key,
    required this.controller,
    required this.searchController,
    required this.searchFocusNode,
    required this.onOpenFilter,
    required this.onActivityTap,
  });

  final HomeController controller;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final VoidCallback onOpenFilter;
  final ValueChanged<ActivityItem> onActivityTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: AppResponsive.contentMaxWidth(context),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 16),
              HomeSearchBar(
                controller: searchController,
                focusNode: searchFocusNode,
                hintText: l10n.homeExploreSearchHint,
                helperText: l10n.homeSearchHeroHelper,
                onChanged: controller.updateSearchQuery,
                onFilterTap: onOpenFilter,
              ),
              const SizedBox(height: 10),
              ExploreCategoryStrip(
                categories: controller.availableCategories,
                selectedCategoryIds: controller.filter.categoryIds,
                onSelectCategory: (categoryId) {
                  final current = Set<String>.from(
                    controller.filter.categoryIds,
                  );
                  if (categoryId == 'all') {
                    controller.applyFilter(
                      controller.filter.copyWith(categoryIds: <String>{'all'}),
                    );
                    return;
                  }
                  current.remove('all');
                  if (!current.add(categoryId)) {
                    current.remove(categoryId);
                  }
                  if (current.isEmpty) {
                    current.add('all');
                  }
                  controller.applyFilter(
                    controller.filter.copyWith(categoryIds: current),
                  );
                },
              ),
              const SizedBox(height: 8),
              Expanded(
                child: switch (controller.explorePhase) {
                  AsyncPhase.loading ||
                  AsyncPhase.idle => const ExploreSkeleton(),
                  AsyncPhase.networkError ||
                  AsyncPhase.serverError => RetryState(
                    message:
                        controller.exploreErrorMessage ?? l10n.homeExploreError,
                    onRetry: controller.retry,
                  ),
                  AsyncPhase.success || AsyncPhase.validationError =>
                    controller.exploreActivities.isEmpty
                        ? const EmptyState()
                        : Column(
                            children: <Widget>[
                              if (controller.explorePhase ==
                                      AsyncPhase.validationError &&
                                  controller.exploreErrorMessage != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: InlineErrorText(
                                    message: controller.exploreErrorMessage!,
                                  ),
                                ),
                              Expanded(
                                child: ListView.separated(
                                  key: const PageStorageKey<String>(
                                    'explore-content-scroll',
                                  ),
                                  padding: const EdgeInsets.only(
                                    top: 6,
                                    bottom: 16,
                                  ),
                                  itemBuilder: (context, index) {
                                    if (index ==
                                        controller.exploreActivities.length) {
                                      return ExploreResultsFooter(
                                        controller: controller,
                                      );
                                    }
                                    if (index >=
                                            controller
                                                    .exploreActivities
                                                    .length -
                                                3 &&
                                        controller.hasMoreExplore &&
                                        !controller.isLoadingMoreExplore) {
                                      unawaited(controller.loadMoreExplore());
                                    }
                                    final activity =
                                        controller.exploreActivities[index];
                                    return CompactActivityRow(
                                      activity: activity,
                                      onTap: () => onActivityTap(activity),
                                    );
                                  },
                                  separatorBuilder: (_, _) => Divider(
                                    height: 32,
                                    color: AppColors.divider,
                                  ),
                                  itemCount:
                                      controller.exploreActivities.length + 1,
                                ),
                              ),
                            ],
                          ),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({
    super.key,
    required this.controller,
    required this.onActivityTap,
  });

  final HomeController controller;
  final ValueChanged<ActivityItem> onActivityTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: AppResponsive.contentMaxWidth(context),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: switch (controller.favoritePhase) {
            AsyncPhase.loading || AsyncPhase.idle => const ExploreSkeleton(),
            AsyncPhase.networkError || AsyncPhase.serverError => RetryState(
              message:
                  controller.favoriteErrorMessage ??
                  l10n.homeFavoritesLoadError,
              onRetry: controller.retry,
            ),
            AsyncPhase.success || AsyncPhase.validationError => Builder(
              builder: (context) {
                final activities = controller.favoriteActivities;
                if (activities.isEmpty) {
                  return ListView(
                    key: const PageStorageKey<String>('favorites-empty-scroll'),
                    padding: const EdgeInsets.only(top: 4, bottom: 24),
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            l10n.homeFavoritesTitle,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.homeFavoritesSubtitle,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 48),
                      Column(
                        children: <Widget>[
                          Icon(
                            Icons.favorite_border_rounded,
                            size: 40,
                            color: AppColors.textSecondary.withValues(
                              alpha: 0.7,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n.homeFavoritesEmptyTitle,
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(fontSize: 18),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.homeFavoritesEmptyDescription,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  );
                }

                return ListView.separated(
                  key: const PageStorageKey<String>('favorites-content-scroll'),
                  padding: const EdgeInsets.only(top: 4, bottom: 24),
                  itemCount: activities.length + 1,
                  separatorBuilder: (_, _) =>
                      Divider(height: 26, color: AppColors.divider),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            l10n.homeFavoritesTitle,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.homeFavoritesSubtitle,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      );
                    }

                    final activity = activities[index - 1];
                    return CompactActivityRow(
                      activity: activity,
                      onTap: () => onActivityTap(activity),
                    );
                  },
                );
              },
            ),
          },
        ),
      ),
    );
  }
}
