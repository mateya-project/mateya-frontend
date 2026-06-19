import 'package:flutter/material.dart';

import '../shared/auth/auth_session.dart';
import '../shared/logging/app_logger.dart';
import '../shared/network/mateya_api_client.dart';
import '../features/home/presentation/screens/home_flow_page.dart';
import '../features/onboarding/application/onboarding_controller.dart';
import '../features/onboarding/data/auth_repository.dart';
import '../features/onboarding/data/location_repository.dart';
import '../features/onboarding/domain/onboarding_flow.dart';
import '../features/onboarding/presentation/screens/onboarding_flow_page.dart';
import '../shared/theme/app_theme.dart';
import 'app_config.dart';

class MateyaApp extends StatefulWidget {
  const MateyaApp({super.key});

  @override
  State<MateyaApp> createState() => _MateyaAppState();
}

class _MateyaAppState extends State<MateyaApp> with WidgetsBindingObserver {
  final AppLogger _logger = AppLogger.instance;
  late final MateyaApiClient _apiClient;
  FlowKind? _initialFlowKind;
  bool _isResolvingInitialRoute = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _apiClient = MateyaApiClient(
      baseUrl: AppConfig.apiBaseUrl,
      sessionStore: AuthSessionStore.instance,
    );
    _logger.info(
      'Mateya app mounted',
      context: <String, Object?>{
        'hasSession': AuthSessionStore.instance.hasSession,
      },
    );
    _resolveInitialRoute();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _logger.info(
      'App lifecycle changed',
      context: <String, Object?>{'state': state.name},
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _resolveInitialRoute() async {
    final session = AuthSessionStore.instance.session;
    if (session == null) {
      if (!mounted) {
        return;
      }
      setState(() {
        _initialFlowKind = null;
        _isResolvingInitialRoute = false;
      });
      return;
    }

    final flowKind = await _resolveFlowKind(session);
    if (!mounted) {
      return;
    }
    setState(() {
      _initialFlowKind = flowKind;
      _isResolvingInitialRoute = false;
    });
  }

  Future<FlowKind> _resolveFlowKind(AuthSession session) async {
    if (_isHostRole(session.user.role)) {
      return FlowKind.host;
    }

    try {
      await _apiClient.getJson(
        '/api/v1/hosts/me',
        requiresAuth: true,
        logFailure: false,
      );
      final refreshedSession = AuthSessionStore.instance.session;
      if (refreshedSession != null &&
          !_isHostRole(refreshedSession.user.role)) {
        AuthSessionStore.instance.save(
          refreshedSession.copyWith(
            user: refreshedSession.user.copyWith(role: 'BUSINESS'),
          ),
        );
      }
      _logger.info('Resolved host flow during bootstrap');
      return FlowKind.host;
    } on MateyaApiException catch (error) {
      if (error.type == ApiFailureType.network) {
        _logger.warning(
          'Failed to verify host flow during bootstrap',
          error: error,
          context: <String, Object?>{
            'statusCode': error.statusCode,
            'fallbackFlowKind': FlowKind.guest.name,
          },
        );
      } else {
        _logger.info(
          'Host flow probe fell back to guest during bootstrap',
          context: <String, Object?>{
            'statusCode': error.statusCode,
            'path': error.path,
            if (error.code != null) 'code': error.code,
          },
        );
      }
      return FlowKind.guest;
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = AuthSessionStore.instance.session;
    return MaterialApp(
      title: 'MateYa',
      debugShowCheckedModeBanner: false,
      theme: buildMateyaTheme(),
      home: _isResolvingInitialRoute
          ? const _AppBootstrapLoadingView()
          : session != null
          ? HomeFlowPage(flowKind: _initialFlowKind ?? FlowKind.guest)
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

bool _isHostRole(String role) {
  final normalizedRole = role.trim().toUpperCase();
  return normalizedRole == 'BUSINESS' || normalizedRole == 'HOST';
}

class _AppBootstrapLoadingView extends StatelessWidget {
  const _AppBootstrapLoadingView();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
