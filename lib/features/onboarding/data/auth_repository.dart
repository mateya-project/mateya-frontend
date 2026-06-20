import '../../../shared/auth/auth_session.dart';
import '../../../shared/localization/mateya_localizations.dart';
import '../../../shared/network/mateya_api_client.dart';
import '../domain/onboarding_flow.dart';

class SmsRequestResult {
  const SmsRequestResult({required this.expiresAt, this.debugCode});

  final DateTime expiresAt;
  final String? debugCode;
}

class SmsVerificationResult {
  const SmsVerificationResult({
    required this.verificationToken,
    required this.expiresAt,
  });

  final String verificationToken;
  final DateTime expiresAt;
}

class BusinessVerificationResult {
  const BusinessVerificationResult({
    required this.businessVerificationToken,
    required this.expiresAt,
  });

  final String businessVerificationToken;
  final DateTime expiresAt;
}

abstract interface class OnboardingAuthRepository {
  Future<SmsRequestResult> requestSmsCode({required String phoneNumber});

  Future<SmsVerificationResult> verifySmsCode({
    required String phoneNumber,
    required String code,
  });

  Future<BusinessVerificationResult> verifyBusiness({
    required String businessNumber,
    required String representativeName,
    required String openingDate,
  });

  Future<AuthSession> loginUser({required String verificationToken});

  Future<AuthSession> signupGuest({
    required String verificationToken,
    required String displayName,
    required String primaryLanguage,
    required String primaryCountry,
    required AgreementState agreementState,
    required NeighborhoodSelection neighborhood,
  });

  Future<AuthSession> signupHost({
    required String verificationToken,
    required String businessVerificationToken,
    required String displayName,
    required String businessName,
    required String primaryLanguage,
    required String primaryCountry,
    required AgreementState agreementState,
  });
}

class ApiOnboardingAuthRepository implements OnboardingAuthRepository {
  ApiOnboardingAuthRepository({required this.apiClient});

  final MateyaApiClient apiClient;

  @override
  Future<SmsRequestResult> requestSmsCode({required String phoneNumber}) async {
    final data = await apiClient.postJson(
      '/api/v1/auth/sms/request',
      body: <String, Object?>{'phoneNumber': phoneNumber},
    );
    final json = _asMap(data);
    return SmsRequestResult(
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      debugCode: json['debugCode'] as String?,
    );
  }

  @override
  Future<SmsVerificationResult> verifySmsCode({
    required String phoneNumber,
    required String code,
  }) async {
    final data = await apiClient.postJson(
      '/api/v1/auth/sms/verify',
      body: <String, Object?>{'phoneNumber': phoneNumber, 'code': code},
    );
    final json = _asMap(data);
    return SmsVerificationResult(
      verificationToken: json['verificationToken'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );
  }

  @override
  Future<BusinessVerificationResult> verifyBusiness({
    required String businessNumber,
    required String representativeName,
    required String openingDate,
  }) async {
    final data = await apiClient.postJson(
      '/api/v1/business-verifications',
      body: <String, Object?>{
        'businessNumber': businessNumber,
        'representativeName': representativeName,
        'openingDate': openingDate,
      },
    );
    final json = _asMap(data);
    return BusinessVerificationResult(
      businessVerificationToken: json['businessVerificationToken'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );
  }

  @override
  Future<AuthSession> loginUser({required String verificationToken}) async {
    final data = await apiClient.postJson(
      '/api/v1/auth/login',
      body: <String, Object?>{'verificationToken': verificationToken},
    );
    return _parseAuthSession(_asMap(data));
  }

  @override
  Future<AuthSession> signupGuest({
    required String verificationToken,
    required String displayName,
    required String primaryLanguage,
    required String primaryCountry,
    required AgreementState agreementState,
    required NeighborhoodSelection neighborhood,
  }) async {
    final data = await apiClient.postJson(
      '/api/v1/auth/signup',
      body: <String, Object?>{
        'verificationToken': verificationToken,
        'displayName': displayName,
        'primaryLanguage': primaryLanguage,
        'primaryCountry': primaryCountry,
        'activityRegionName': neighborhood.displayName,
        'activityLatitude': neighborhood.latitude,
        'activityLongitude': neighborhood.longitude,
        'termsAgreements': <Map<String, Object?>>[
          _agreement(type: 'SERVICE_TERMS', agreed: agreementState.service),
          _agreement(
            type: 'PRIVACY_THIRD_PARTY',
            agreed: agreementState.privacy,
          ),
          _agreement(
            type: 'LOCATION_BASED_SERVICE',
            agreed: agreementState.location,
          ),
          _agreement(type: 'AGE_OVER_14', agreed: agreementState.age),
        ],
      },
    );
    return _parseAuthSession(_asMap(data));
  }

  @override
  Future<AuthSession> signupHost({
    required String verificationToken,
    required String businessVerificationToken,
    required String displayName,
    required String businessName,
    required String primaryLanguage,
    required String primaryCountry,
    required AgreementState agreementState,
  }) async {
    final data = await apiClient.postJson(
      '/api/v1/auth/signup',
      body: <String, Object?>{
        'verificationToken': verificationToken,
        'displayName': displayName,
        'primaryLanguage': primaryLanguage,
        'primaryCountry': primaryCountry,
        'businessVerificationToken': businessVerificationToken,
        'businessName': businessName,
        'termsAgreements': <Map<String, Object?>>[
          _agreement(type: 'SERVICE_TERMS', agreed: agreementState.service),
          _agreement(
            type: 'PRIVACY_THIRD_PARTY',
            agreed: agreementState.privacy,
          ),
          _agreement(
            type: 'LOCATION_BASED_SERVICE',
            agreed: agreementState.location,
          ),
          _agreement(type: 'AGE_OVER_14', agreed: agreementState.age),
        ],
      },
    );
    return _parseAuthSession(_asMap(data));
  }

  Map<String, Object?> _agreement({
    required String type,
    required bool agreed,
  }) {
    return <String, Object?>{'type': type, 'version': 'v1', 'agreed': agreed};
  }

  AuthSession _parseAuthSession(Map<String, dynamic> json) {
    final userJson = _asMap(json['user']);
    return AuthSession(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      tokenType: json['tokenType'] as String? ?? 'Bearer',
      expiresIn: json['expiresIn'] as int? ?? 0,
      refreshExpiresIn: json['refreshExpiresIn'] as int? ?? 0,
      refreshExpiresAt: DateTime.parse(json['refreshExpiresAt'] as String),
      user: AuthUserProfile(
        id: userJson['id'] as int,
        phoneNumber: userJson['phoneNumber'] as String? ?? '',
        displayName: userJson['displayName'] as String? ?? '',
        englishName: userJson['englishName'] as String?,
        role: userJson['role'] as String? ?? 'USER',
        primaryLanguage: userJson['primaryLanguage'] as String? ?? 'ko',
        primaryCountry: userJson['primaryCountry'] as String? ?? 'KR',
        profileImageUrl: userJson['profileImageUrl'] as String?,
        activityCountry: userJson['activityCountry'] as String?,
        activityRegionName: userJson['activityRegionName'] as String?,
        activityLatitude: (userJson['activityLatitude'] as num?)?.toDouble(),
        activityLongitude: (userJson['activityLongitude'] as num?)?.toDouble(),
        lastLoginAt: userJson['lastLoginAt'] == null
            ? null
            : DateTime.parse(userJson['lastLoginAt'] as String),
        createdAt: DateTime.parse(userJson['createdAt'] as String),
      ),
    );
  }

  Map<String, dynamic> _asMap(Object? value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    throw MateyaApiException(
      type: ApiFailureType.server,
      message: MateyaLocalizations.current.commonInvalidServerResponse,
    );
  }
}
