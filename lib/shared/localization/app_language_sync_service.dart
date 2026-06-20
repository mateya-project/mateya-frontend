import '../../app/app_config.dart';
import '../auth/auth_session.dart';
import '../logging/app_logger.dart';
import '../network/mateya_api_client.dart';
import '../preferences/mateya_language_preferences.dart';

abstract interface class AppLanguageSyncService {
  Future<void> syncSelectedLanguage(String code);
}

class NetworkAppLanguageSyncService implements AppLanguageSyncService {
  NetworkAppLanguageSyncService({
    AuthSessionStore? sessionStore,
    MateyaApiClient? apiClient,
    AppLogger? logger,
  }) : _sessionStore = sessionStore ?? AuthSessionStore.instance,
       _apiClient =
           apiClient ??
           MateyaApiClient(
             baseUrl: AppConfig.apiBaseUrl,
             sessionStore: sessionStore ?? AuthSessionStore.instance,
           ),
       _logger = logger ?? AppLogger.instance;

  static final NetworkAppLanguageSyncService instance =
      NetworkAppLanguageSyncService();

  final AuthSessionStore _sessionStore;
  final MateyaApiClient _apiClient;
  final AppLogger _logger;

  @override
  Future<void> syncSelectedLanguage(String code) async {
    final currentSession = _sessionStore.session;
    if (currentSession == null) {
      return;
    }

    final primaryLanguage =
        MateyaLanguagePreferences.primaryLanguageCodeFromCode(code);
    final primaryCountry = MateyaLanguagePreferences.primaryCountryCodeFromCode(
      code,
    );

    _sessionStore.save(
      currentSession.copyWith(
        user: currentSession.user.copyWith(
          primaryLanguage: primaryLanguage,
          primaryCountry: primaryCountry,
        ),
      ),
    );

    try {
      final data = await _apiClient.patchJson(
        '/api/v1/users/me/profile',
        requiresAuth: true,
        body: <String, Object?>{
          'displayName': currentSession.user.displayName,
          'englishName': currentSession.user.englishName,
          'primaryLanguage': primaryLanguage,
          'primaryCountry': primaryCountry,
        },
      );
      if (data is Map<String, dynamic>) {
        _syncSessionUserProfile(data);
      }
    } on MateyaApiException catch (error, stackTrace) {
      _logger.warning(
        'Failed to sync selected language with user profile',
        error: error,
        stackTrace: stackTrace,
        context: <String, Object?>{
          'path': error.path,
          'statusCode': error.statusCode,
          'languageCode': primaryLanguage,
          'countryCode': primaryCountry,
          if (error.code != null) 'code': error.code,
        },
      );
    } catch (error, stackTrace) {
      _logger.warning(
        'Failed to sync selected language with user profile',
        error: error,
        stackTrace: stackTrace,
        context: <String, Object?>{
          'languageCode': primaryLanguage,
          'countryCode': primaryCountry,
        },
      );
    }
  }

  void _syncSessionUserProfile(Map<String, dynamic> profileJson) {
    final current = _sessionStore.session;
    if (current == null) {
      return;
    }

    final updatedUser = current.user.copyWith(
      displayName:
          profileJson['displayName'] as String? ?? current.user.displayName,
      englishName: profileJson['englishName'] as String?,
      primaryLanguage:
          profileJson['primaryLanguage'] as String? ??
          current.user.primaryLanguage,
      primaryCountry:
          profileJson['primaryCountry'] as String? ??
          current.user.primaryCountry,
      profileImageUrl:
          profileJson['profileImageUrl'] as String? ??
          current.user.profileImageUrl,
      activityCountry:
          profileJson['activityCountry'] as String? ??
          current.user.activityCountry,
      activityRegionName:
          profileJson['activityRegionName'] as String? ??
          current.user.activityRegionName,
      activityLatitude:
          (profileJson['activityLatitude'] as num?)?.toDouble() ??
          current.user.activityLatitude,
      activityLongitude:
          (profileJson['activityLongitude'] as num?)?.toDouble() ??
          current.user.activityLongitude,
      lastLoginAt: profileJson['lastLoginAt'] == null
          ? current.user.lastLoginAt
          : DateTime.tryParse(profileJson['lastLoginAt'] as String),
      createdAt: profileJson['createdAt'] == null
          ? current.user.createdAt
          : DateTime.tryParse(profileJson['createdAt'] as String) ??
                current.user.createdAt,
    );
    _sessionStore.save(current.copyWith(user: updatedUser));
  }
}
