class AuthUserProfile {
  const AuthUserProfile({
    required this.id,
    required this.phoneNumber,
    required this.displayName,
    required this.role,
    required this.primaryLanguage,
    required this.primaryCountry,
    required this.createdAt,
    this.profileImageUrl,
    this.activityRegionName,
    this.activityLatitude,
    this.activityLongitude,
    this.lastLoginAt,
  });

  final int id;
  final String phoneNumber;
  final String displayName;
  final String role;
  final String primaryLanguage;
  final String primaryCountry;
  final String? profileImageUrl;
  final String? activityRegionName;
  final double? activityLatitude;
  final double? activityLongitude;
  final DateTime? lastLoginAt;
  final DateTime createdAt;
}

class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
    required this.refreshExpiresIn,
    required this.refreshExpiresAt,
    required this.user,
  });

  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;
  final int refreshExpiresIn;
  final DateTime refreshExpiresAt;
  final AuthUserProfile user;
}

class AuthSessionStore {
  AuthSessionStore._();

  static final AuthSessionStore instance = AuthSessionStore._();

  AuthSession? _session;

  AuthSession? get session => _session;
  bool get hasSession => _session != null;

  void save(AuthSession session) {
    _session = session;
  }

  void clear() {
    _session = null;
  }
}
