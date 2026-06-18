import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../logging/app_logger.dart';

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

  AuthUserProfile copyWith({
    int? id,
    String? phoneNumber,
    String? displayName,
    String? role,
    String? primaryLanguage,
    String? primaryCountry,
    Object? profileImageUrl = _authSessionSentinel,
    Object? activityRegionName = _authSessionSentinel,
    Object? activityLatitude = _authSessionSentinel,
    Object? activityLongitude = _authSessionSentinel,
    Object? lastLoginAt = _authSessionSentinel,
    DateTime? createdAt,
  }) {
    return AuthUserProfile(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      primaryLanguage: primaryLanguage ?? this.primaryLanguage,
      primaryCountry: primaryCountry ?? this.primaryCountry,
      profileImageUrl: profileImageUrl == _authSessionSentinel
          ? this.profileImageUrl
          : profileImageUrl as String?,
      activityRegionName: activityRegionName == _authSessionSentinel
          ? this.activityRegionName
          : activityRegionName as String?,
      activityLatitude: activityLatitude == _authSessionSentinel
          ? this.activityLatitude
          : activityLatitude as double?,
      activityLongitude: activityLongitude == _authSessionSentinel
          ? this.activityLongitude
          : activityLongitude as double?,
      lastLoginAt: lastLoginAt == _authSessionSentinel
          ? this.lastLoginAt
          : lastLoginAt as DateTime?,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'id': id,
      'phoneNumber': phoneNumber,
      'displayName': displayName,
      'role': role,
      'primaryLanguage': primaryLanguage,
      'primaryCountry': primaryCountry,
      'profileImageUrl': profileImageUrl,
      'activityRegionName': activityRegionName,
      'activityLatitude': activityLatitude,
      'activityLongitude': activityLongitude,
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static AuthUserProfile fromJson(Map<String, dynamic> json) {
    return AuthUserProfile(
      id: json['id'] as int,
      phoneNumber: json['phoneNumber'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      role: json['role'] as String? ?? 'USER',
      primaryLanguage: json['primaryLanguage'] as String? ?? 'ko',
      primaryCountry: json['primaryCountry'] as String? ?? 'KR',
      profileImageUrl: json['profileImageUrl'] as String?,
      activityRegionName: json['activityRegionName'] as String?,
      activityLatitude: (json['activityLatitude'] as num?)?.toDouble(),
      activityLongitude: (json['activityLongitude'] as num?)?.toDouble(),
      lastLoginAt: json['lastLoginAt'] == null
          ? null
          : DateTime.parse(json['lastLoginAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
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

  AuthSession copyWith({
    String? accessToken,
    String? refreshToken,
    String? tokenType,
    int? expiresIn,
    int? refreshExpiresIn,
    DateTime? refreshExpiresAt,
    AuthUserProfile? user,
  }) {
    return AuthSession(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      tokenType: tokenType ?? this.tokenType,
      expiresIn: expiresIn ?? this.expiresIn,
      refreshExpiresIn: refreshExpiresIn ?? this.refreshExpiresIn,
      refreshExpiresAt: refreshExpiresAt ?? this.refreshExpiresAt,
      user: user ?? this.user,
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'tokenType': tokenType,
      'expiresIn': expiresIn,
      'refreshExpiresIn': refreshExpiresIn,
      'refreshExpiresAt': refreshExpiresAt.toIso8601String(),
      'user': user.toJson(),
    };
  }

  static AuthSession fromJson(Map<String, dynamic> json) {
    return AuthSession(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      tokenType: json['tokenType'] as String? ?? 'Bearer',
      expiresIn: json['expiresIn'] as int? ?? 0,
      refreshExpiresIn: json['refreshExpiresIn'] as int? ?? 0,
      refreshExpiresAt: DateTime.parse(json['refreshExpiresAt'] as String),
      user: AuthUserProfile.fromJson(
        json['user'] as Map<String, dynamic>? ?? const <String, dynamic>{},
      ),
    );
  }
}

class AuthSessionStore {
  AuthSessionStore._();

  static final AuthSessionStore instance = AuthSessionStore._();
  static const String _storageKey = 'mateya.auth_session';

  AuthSession? _session;
  Future<void> _storageOperation = Future<void>.value();
  Future<AuthSession?>? _refreshOperation;

  AuthSession? get session => _session;
  bool get hasSession => _session != null;

  Future<void> initialize() async {
    final preferences = await SharedPreferences.getInstance();
    final raw = preferences.getString(_storageKey);
    if (raw == null || raw.isEmpty) {
      _session = null;
      unawaited(_syncLoggingContext());
      return;
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Invalid auth session payload');
      }
      _session = AuthSession.fromJson(decoded);
      AppLogger.instance.info(
        'Auth session restored from local storage',
        context: _sessionLogContext(_session),
      );
    } catch (_) {
      _session = null;
      await preferences.remove(_storageKey);
      AppLogger.instance.warning(
        'Stored auth session was invalid and has been cleared',
      );
    }
    unawaited(_syncLoggingContext());
  }

  void save(AuthSession session) {
    _session = session;
    AppLogger.instance.info(
      'Auth session saved',
      context: _sessionLogContext(session),
    );
    unawaited(_syncLoggingContext());
    _queueStorageWrite((preferences) async {
      await preferences.setString(_storageKey, jsonEncode(session.toJson()));
    });
  }

  void clear() {
    final previousSession = _session;
    _session = null;
    AppLogger.instance.info(
      'Auth session cleared',
      context: _sessionLogContext(previousSession),
    );
    unawaited(_syncLoggingContext());
    _queueStorageWrite((preferences) async {
      await preferences.remove(_storageKey);
    });
  }

  Future<void> flush() => _storageOperation;

  Future<AuthSession?> refreshSession(
    Future<AuthSession> Function(String refreshToken) refresh,
  ) {
    final existing = _refreshOperation;
    if (existing != null) {
      return existing;
    }
    final current = _session;
    if (current == null || current.refreshToken.isEmpty) {
      return Future<AuthSession?>.value(null);
    }

    final future = () async {
      try {
        AppLogger.instance.info(
          'Refreshing auth session',
          context: _sessionLogContext(current),
        );
        final nextSession = await refresh(current.refreshToken);
        save(nextSession);
        await flush();
        return nextSession;
      } finally {
        _refreshOperation = null;
      }
    }();
    _refreshOperation = future;
    return future;
  }

  void _queueStorageWrite(
    Future<void> Function(SharedPreferences preferences) action,
  ) {
    _storageOperation = _storageOperation.then((_) async {
      final preferences = await SharedPreferences.getInstance();
      await action(preferences);
    });
  }

  Future<void> _syncLoggingContext() {
    final session = _session;
    return AppLogger.instance.updateUserContext(
      userId: session?.user.id.toString(),
      context: <String, Object?>{
        'role': session?.user.role,
        'primaryLanguage': session?.user.primaryLanguage,
        'primaryCountry': session?.user.primaryCountry,
      },
    );
  }

  Map<String, Object?> _sessionLogContext(AuthSession? session) {
    return <String, Object?>{
      'hasSession': session != null,
      if (session != null) 'userId': session.user.id,
      if (session != null) 'role': session.user.role,
      if (session != null) 'primaryLanguage': session.user.primaryLanguage,
    };
  }
}

const Object _authSessionSentinel = Object();
