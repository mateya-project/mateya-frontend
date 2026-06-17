import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

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
      return;
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Invalid auth session payload');
      }
      _session = AuthSession.fromJson(decoded);
    } catch (_) {
      _session = null;
      await preferences.remove(_storageKey);
    }
  }

  void save(AuthSession session) {
    _session = session;
    _queueStorageWrite((preferences) async {
      await preferences.setString(_storageKey, jsonEncode(session.toJson()));
    });
  }

  void clear() {
    _session = null;
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
}
