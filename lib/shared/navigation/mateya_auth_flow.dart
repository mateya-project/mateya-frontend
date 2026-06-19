import 'package:flutter/material.dart';

import '../../app/app_config.dart';
import '../../features/onboarding/application/onboarding_controller.dart';
import '../../features/onboarding/data/auth_repository.dart';
import '../../features/onboarding/data/location_repository.dart';
import '../../features/onboarding/presentation/screens/onboarding_flow_page.dart';
import '../auth/auth_session.dart';
import '../network/mateya_api_client.dart';

OnboardingFlowPage buildMateyaOnboardingFlowPage() {
  return OnboardingFlowPage(
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
  );
}

Future<void> replaceWithMateyaOnboardingFlow(BuildContext context) {
  return Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute<void>(builder: (_) => buildMateyaOnboardingFlowPage()),
    (_) => false,
  );
}
