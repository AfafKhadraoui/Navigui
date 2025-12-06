import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for securely storing sensitive data like authentication tokens
/// Uses platform-specific secure storage (Keychain on iOS, KeyStore on Android)
class SecureStorageService {
  final FlutterSecureStorage _storage;

  // Storage keys
  static const String _keyAuthToken = 'auth_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserType = 'user_type'; // student, employer, admin
  static const String _keyUserName = 'user_name';
  static const String _keyUserPhone = 'user_phone';
  static const String _keyUserLocation = 'user_location';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyIsAuthenticated = 'is_authenticated';
  static const String _keyLastActivityTime = 'last_activity_time';
  static const String _keySessionTimeout = 'session_timeout'; // in minutes

  // Session timeout duration (30 minutes by default)
  static const int defaultSessionTimeoutMinutes = 30;

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(
                encryptedSharedPreferences: true,
              ),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock,
              ),
            );

  // ========== AUTH TOKEN METHODS ==========

  /// Save authentication token
  Future<void> saveAuthToken(String token) async {
    await _storage.write(key: _keyAuthToken, value: token);
    await _storage.write(key: _keyIsAuthenticated, value: 'true');
  }

  /// Get authentication token
  Future<String?> getAuthToken() async {
    return await _storage.read(key: _keyAuthToken);
  }

  /// Delete authentication token
  Future<void> deleteAuthToken() async {
    await _storage.delete(key: _keyAuthToken);
  }

  /// Check if auth token exists
  Future<bool> hasAuthToken() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }

  // ========== REFRESH TOKEN METHODS ==========

  /// Save refresh token
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _keyRefreshToken, value: token);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  /// Delete refresh token
  Future<void> deleteRefreshToken() async {
    await _storage.delete(key: _keyRefreshToken);
  }

  // ========== USER DATA METHODS ==========

  /// Save user ID
  Future<void> saveUserId(String userId) async {
    await _storage.write(key: _keyUserId, value: userId);
  }

  /// Get user ID
  Future<String?> getUserId() async {
    return await _storage.read(key: _keyUserId);
  }

  /// Delete user ID
  Future<void> deleteUserId() async {
    await _storage.delete(key: _keyUserId);
  }

  /// Save user email
  Future<void> saveUserEmail(String email) async {
    await _storage.write(key: _keyUserEmail, value: email);
  }

  /// Get user email
  Future<String?> getUserEmail() async {
    return await _storage.read(key: _keyUserEmail);
  }

  /// Delete user email
  Future<void> deleteUserEmail() async {
    await _storage.delete(key: _keyUserEmail);
  }

  /// Save user type (student, employer, admin)
  Future<void> saveUserType(String userType) async {
    await _storage.write(key: _keyUserType, value: userType);
  }

  /// Get user type
  Future<String?> getUserType() async {
    return await _storage.read(key: _keyUserType);
  }

  /// Delete user type
  Future<void> deleteUserType() async {
    await _storage.delete(key: _keyUserType);
  }

  /// Save user name
  Future<void> saveUserName(String name) async {
    await _storage.write(key: _keyUserName, value: name);
  }

  /// Get user name
  Future<String?> getUserName() async {
    return await _storage.read(key: _keyUserName);
  }

  /// Delete user name
  Future<void> deleteUserName() async {
    await _storage.delete(key: _keyUserName);
  }

  /// Save user phone
  Future<void> saveUserPhone(String phone) async {
    await _storage.write(key: _keyUserPhone, value: phone);
  }

  /// Get user phone
  Future<String?> getUserPhone() async {
    return await _storage.read(key: _keyUserPhone);
  }

  /// Delete user phone
  Future<void> deleteUserPhone() async {
    await _storage.delete(key: _keyUserPhone);
  }

  /// Save user location
  Future<void> saveUserLocation(String location) async {
    await _storage.write(key: _keyUserLocation, value: location);
  }

  /// Get user location
  Future<String?> getUserLocation() async {
    return await _storage.read(key: _keyUserLocation);
  }

  /// Delete user location
  Future<void> deleteUserLocation() async {
    await _storage.delete(key: _keyUserLocation);
  }

  // ========== AUTHENTICATION STATUS ==========

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final value = await _storage.read(key: _keyIsAuthenticated);
    return value == 'true';
  }

  /// Set authentication status
  Future<void> setAuthenticated(bool isAuth) async {
    await _storage.write(
      key: _keyIsAuthenticated,
      value: isAuth ? 'true' : 'false',
    );
  }

  // ========== SESSION TIMEOUT METHODS ==========

  /// Update last activity time (call this on user interaction)
  Future<void> updateLastActivity() async {
    final now = DateTime.now().millisecondsSinceEpoch.toString();
    await _storage.write(key: _keyLastActivityTime, value: now);
  }

  /// Get last activity time
  Future<DateTime?> getLastActivity() async {
    final value = await _storage.read(key: _keyLastActivityTime);
    if (value == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(int.parse(value));
  }

  /// Check if session has expired
  Future<bool> isSessionExpired() async {
    final lastActivity = await getLastActivity();
    if (lastActivity == null) return true;

    final now = DateTime.now();
    final difference = now.difference(lastActivity);
    
    return difference.inMinutes >= defaultSessionTimeoutMinutes;
  }

  /// Set custom session timeout (in minutes)
  Future<void> setSessionTimeout(int minutes) async {
    await _storage.write(key: _keySessionTimeout, value: minutes.toString());
  }

  /// Get session timeout duration
  Future<int> getSessionTimeout() async {
    final value = await _storage.read(key: _keySessionTimeout);
    return value != null ? int.parse(value) : defaultSessionTimeoutMinutes;
  }

  /// Clear expired session
  Future<void> clearUserSession() async {
    await clearAll();
  }

  // ========== BULK OPERATIONS ==========

  /// Save complete user session
  Future<void> saveUserSession({
    required String authToken,
    required String userId,
    required String email,
    required String userType,
    required String name,
    String? refreshToken,
  }) async {
    await Future.wait([
      saveAuthToken(authToken),
      saveUserId(userId),
      saveUserEmail(email),
      saveUserType(userType),
      saveUserName(name),
      if (refreshToken != null) saveRefreshToken(refreshToken),
      setAuthenticated(true),
      updateLastActivity(), // Track session start time
    ]);
  }

  /// Get complete user session data
  Future<Map<String, String?>> getUserSession() async {
    return {
      'authToken': await getAuthToken(),
      'userId': await getUserId(),
      'email': await getUserEmail(),
      'userType': await getUserType(),
      'name': await getUserName(),
      'phone': await getUserPhone(),
      'location': await getUserLocation(),
      'refreshToken': await getRefreshToken(),
    };
  }

  /// Clear all stored data (logout)
  Future<void> clearAll() async {
    await Future.wait([
      deleteAuthToken(),
      deleteUserId(),
      deleteUserEmail(),
      deleteUserType(),
      deleteUserName(),
      deleteUserPhone(),
      deleteUserLocation(),
      deleteRefreshToken(),
      setAuthenticated(false),
    ]);
  }

  /// Clear only tokens (useful for token refresh scenarios)
  Future<void> clearTokens() async {
    await Future.wait([
      deleteAuthToken(),
      deleteRefreshToken(),
    ]);
  }

  // ========== DEBUG METHODS ==========

  /// Get all stored keys (for debugging)
  Future<Map<String, String>> getAllValues() async {
    return await _storage.readAll();
  }

  /// Delete everything (for testing/debugging)
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
