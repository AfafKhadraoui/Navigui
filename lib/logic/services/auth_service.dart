import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

/// Auth Service - Manages user authentication state and role
/// This is a simple in-memory service. In production, you'd use:
/// - Firebase Auth
/// - SharedPreferences for persistence
/// - Secure Storage for tokens
class AuthService extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isAuthenticated = false;

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isStudent => _currentUser?.accountType == 'student';
  bool get isEmployer => _currentUser?.accountType == 'employer';
  String? get userRole => _currentUser?.accountType;

  /// Login user (mock implementation)
  Future<bool> login(String email, String password) async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(
          const Duration(seconds: 1)); // Simulate network delay

      // Mock user - In production, get this from your backend
      // For now, determine role from email domain or stored data
      final accountType = email.contains('employer') ? 'employer' : 'student';

      _currentUser = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: 'Test User', // Get from backend
        phoneNumber: '+213XXXXXXXXX',
        location: 'Alger',
        accountType: accountType,
        createdAt: DateTime.now(),
      );

      _isAuthenticated = true;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Signup user and set their role
  Future<bool> signup({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    required String location,
    required String accountType, // 'student' or 'employer'
    String? profilePicture,
  }) async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      _currentUser = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: name,
        phoneNumber: phoneNumber,
        location: location,
        accountType: accountType,
        profilePicture: profilePicture,
        createdAt: DateTime.now(),
      );

      _isAuthenticated = true;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Logout user
  void logout() {
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  /// Update user data
  void updateUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  /// Check if user has access to a specific route based on role
  bool hasAccess(String routePath) {
    if (!_isAuthenticated) return false;

    // Define role-based access rules
    if (routePath.contains('/employer')) {
      return isEmployer;
    } else if (routePath.contains('/student')) {
      return isStudent;
    }

    return true; // Default allow for shared routes
  }
}
