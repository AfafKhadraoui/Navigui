import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';

/// Authentication data repository
/// Handles authentication-related data operations
class AuthRepository {
  static const String _userKey = 'current_user';
  static const String _tokenKey = 'auth_token';

  /// Login with email and password
  /// Returns UserModel on success
  Future<UserModel> login(String email, String password) async {
    try {
      // TODO: Replace with actual API call
      // final response = await http.post(
      //   Uri.parse('$baseUrl/auth/login'),
      //   body: {'email': email, 'password': password},
      // );

      // Mock implementation for now
      await Future.delayed(const Duration(seconds: 1));

      // Simulate validation
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email and password are required');
      }

      // Mock user data
      final user = UserModel(
        id: '1',
        email: email,
        name: 'Test User',
        phoneNumber: '+213555123456',
        location: 'Algiers',
        accountType: email.contains('employer') ? 'employer' : 'student',
        createdAt: DateTime.now(),
      );

      // Save user and token
      await _saveUser(user);
      await _saveToken('mock_token_${user.id}');

      return user;
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  /// Sign up new user
  Future<UserModel> signup({
    required String email,
    required String password,
    required String fullName,
    required String role,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock user data
      final user = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        name: fullName,
        phoneNumber: additionalData?['phone'] ?? '',
        location: additionalData?['location'] ?? 'Algiers',
        accountType: role,
        createdAt: DateTime.now(),
      );

      // Save user and token
      await _saveUser(user);
      await _saveToken('mock_token_${user.id}');

      return user;
    } catch (e) {
      throw Exception('Signup failed: ${e.toString()}');
    }
  }

  /// Logout current user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
  }

  /// Get current logged-in user
  Future<UserModel?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);

      if (userJson == null) return null;

      final userMap = json.decode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (e) {
      return null;
    }
  }

  /// Get current auth token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null;
  }

  // Private helper methods
  Future<void> _saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = json.encode(user.toJson());
    await prefs.setString(_userKey, userJson);
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }
}
