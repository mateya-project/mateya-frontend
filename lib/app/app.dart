import 'package:flutter/material.dart';

import 'flow_kind_resolver.dart';
import '../shared/auth/auth_session.dart';
import '../shared/localization/app_locale_controller.dart';
import '../shared/localization/mateya_localizations.dart';
import '../shared/logging/app_logger.dart';
import '../shared/navigation/mateya_route_observer.dart';
import '../shared/network/mateya_api_client.dart';
import '../shared/widgets/mateya_web_viewport_shell.dart';
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
  final AppLocaleController _localeController = AppLocaleController.instance;
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
    final resolution = await resolveFlowKind(
      currentRole: session.user.role,
      probeHostAccess: () => _apiClient.getJson(
        '/api/v1/hosts/me',
        requiresAuth: true,
        logFailure: false,
      ),
    );

    final refreshedSession = AuthSessionStore.instance.session;
    if (resolution.updatedRole != null &&
        refreshedSession != null &&
        refreshedSession.user.role != resolution.updatedRole) {
      AuthSessionStore.instance.save(
        refreshedSession.copyWith(
          user: refreshedSession.user.copyWith(role: resolution.updatedRole),
        ),
      );
    }

    if (resolution.flowKind == FlowKind.host) {
      _logger.info('Resolved host flow during bootstrap');
      return FlowKind.host;
    }

    if (resolution.probeFailedWithNetwork) {
      _logger.warning(
        'Failed to verify host flow during bootstrap',
        context: <String, Object?>{
          'fallbackFlowKind': resolution.flowKind.name,
          'preservedRole': session.user.role,
        },
      );
      return resolution.flowKind;
    }

    _logger.info(
      'Host flow probe fell back to guest during bootstrap',
      context: <String, Object?>{
        'previousRole': session.user.role,
        if (resolution.updatedRole != null)
          'updatedRole': resolution.updatedRole,
      },
    );
    return FlowKind.guest;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _localeController,
      builder: (context, _) {
        final session = AuthSessionStore.instance.session;
        return MaterialApp(
          key: ValueKey<String>('mateya-app-${_localeController.languageCode}'),
          onGenerateTitle: (context) => context.l10n.appTitle,
          debugShowCheckedModeBanner: false,
          theme: buildMateyaTheme(),
          builder: (context, child) =>
              MateyaWebViewportShell(child: child ?? const SizedBox.shrink()),
          navigatorObservers: <NavigatorObserver>[mateyaRouteObserver],
          locale: _localeController.locale,
          supportedLocales: MateyaLocalizations.supportedLocales,
          localizationsDelegates: MateyaLocalizations.delegates,
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
      },
    );
  }
}

class _AppBootstrapLoadingView extends StatelessWidget {
  const _AppBootstrapLoadingView();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
