import 'package:flutter/material.dart';

import '../../../../shared/localization/mateya_localizations.dart';
import '../../../../shared/theme/app_tokens.dart';
import '../../../../shared/widgets/mateya_header.dart';
import '../../domain/onboarding_terms.dart';

class OnboardingTermsDetailPage extends StatelessWidget {
  const OnboardingTermsDetailPage({super.key, required this.document});

  final OnboardingTermsDocument document;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            MateyaHeader.backArrow(onBack: () => Navigator.of(context).pop()),
            Expanded(child: OnboardingTermsDetailContent(document: document)),
          ],
        ),
      ),
    );
  }
}

class OnboardingTermsDetailContent extends StatelessWidget {
  const OnboardingTermsDetailContent({super.key, required this.document});

  final OnboardingTermsDocument document;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontal,
        20,
        AppSpacing.screenHorizontal,
        40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            document.title,
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            l10n.onboardingTermsEffectiveDate(document.effectiveDateLabel),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.subtleBackground,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  l10n.onboardingTermsContents,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                for (int index = 0; index < document.sections.length; index++)
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: index == document.sections.length - 1 ? 0 : 10,
                    ),
                    child: Text(
                      l10n.onboardingTermsSectionTitle(
                        index + 1,
                        document.sections[index].title,
                      ),
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Text(
            document.summary,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 32),
          for (
            int index = 0;
            index < document.sections.length;
            index++
          ) ...<Widget>[
            _TermsSectionView(
              index: index + 1,
              section: document.sections[index],
            ),
            if (index != document.sections.length - 1)
              const SizedBox(height: 28),
          ],
        ],
      ),
    );
  }
}

class _TermsSectionView extends StatelessWidget {
  const _TermsSectionView({required this.index, required this.section});

  final int index;
  final OnboardingTermsSection section;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          l10n.onboardingTermsSectionTitle(index, section.title),
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          section.body,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            height: 1.75,
          ),
        ),
        if (section.points.isNotEmpty) ...<Widget>[
          const SizedBox(height: 14),
          for (
            int pointIndex = 0;
            pointIndex < section.points.length;
            pointIndex++
          )
            Padding(
              padding: EdgeInsets.only(
                left: 4,
                bottom: pointIndex == section.points.length - 1 ? 0 : 8,
              ),
              child: Text(
                '${pointIndex + 1}. ${section.points[pointIndex]}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.7,
                ),
              ),
            ),
        ],
      ],
    );
  }
}
