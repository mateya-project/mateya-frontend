import 'package:flutter/material.dart';

import '../shared/auth/auth_session.dart';
import '../shared/network/mateya_api_client.dart';
import '../features/home/presentation/screens/home_flow_page.dart';
import '../features/onboarding/application/onboarding_controller.dart';
import '../features/onboarding/data/auth_repository.dart';
import '../features/onboarding/data/location_repository.dart';
import '../features/onboarding/domain/onboarding_flow.dart';
import '../features/onboarding/presentation/screens/onboarding_flow_page.dart';
import '../shared/theme/app_theme.dart';
import 'app_config.dart';

class MateyaApp extends StatelessWidget {
  const MateyaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final session = AuthSessionStore.instance.session;
    return MaterialApp(
      title: 'MateYa',
      debugShowCheckedModeBanner: false,
      theme: buildMateyaTheme(),
      home: session != null
          ? HomeFlowPage(
              flowKind: session.user.role == 'BUSINESS'
                  ? FlowKind.host
                  : FlowKind.guest,
              onBack: () {},
            )
          : OnboardingFlowPage(
              controller: OnboardingController(
                locationRepository: DeviceNeighborhoodLocationRepository(),
                authRepository: ApiOnboardingAuthRepository(
                  apiClient: MateyaApiClient(
                    baseUrl: AppConfig.apiBaseUrl,
                    sessionStore: AuthSessionStore.instance,
                  ),
                ),
                authSessionStore: AuthSessionStore.instance,
              ),
            ),
    );
  }
}
