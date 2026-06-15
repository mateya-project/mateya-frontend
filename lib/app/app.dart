import 'package:flutter/material.dart';

import '../features/onboarding/application/onboarding_controller.dart';
import '../features/onboarding/data/location_repository.dart';
import '../features/onboarding/presentation/screens/onboarding_flow_page.dart';
import '../shared/theme/app_theme.dart';

class MateyaApp extends StatelessWidget {
  const MateyaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MateYa',
      debugShowCheckedModeBanner: false,
      theme: buildMateyaTheme(),
      home: OnboardingFlowPage(
        controller: OnboardingController(
          locationRepository: DeviceNeighborhoodLocationRepository(),
        ),
      ),
    );
  }
}
