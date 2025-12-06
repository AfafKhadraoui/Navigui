import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/user_model.dart';

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
      // Default test accounts
      const testAccounts = {
        'admin@navigui.com': {'password': 'admin123', 'type': 'admin', 'name': 'Admin User'},
        'employer@navigui.com': {'password': 'employer123', 'type': 'employer', 'name': 'Employer User'},
        'student@navigui.com': {'password': 'student123', 'type': 'student', 'name': 'Student User'},
      };

      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

      String accountType;
      String userName;
      
      // Check if it's a test account
      if (testAccounts.containsKey(email.toLowerCase())) {
        final account = testAccounts[email.toLowerCase()]!;
        // Validate password for test accounts
        if (account['password'] != password) {
          return false; // Wrong password
        }
        accountType = account['type']!;
        userName = account['name']!;
      } else {
        // For other emails, determine role from email pattern (backward compatibility)
        if (email.toLowerCase().contains('admin')) {
          accountType = 'admin';
        } else if (email.contains('employer')) {
          accountType = 'employer';
        } else {
          accountType = 'student';
        }
        userName = 'Test User';
      }

      _currentUser = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: userName,
        phoneNumber: '+213XXXXXXXXX',
        location: 'Alger',
        accountType: accountType,
        createdAt: DateTime.now(),
      );

      _isAuthenticated = true;
      
      // Save to SharedPreferences for role-based navigation
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', email);
      await prefs.setString('user_name', userName);
      await prefs.setString('user_account_type', accountType);
      
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
      
      // Save to SharedPreferences for role-based navigation
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', email);
      await prefs.setString('user_name', name);
      await prefs.setString('user_phone', phoneNumber);
      await prefs.setString('user_location', location);
      await prefs.setString('user_account_type', accountType);
      
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Logout user
  void logout() async {
    _currentUser = null;
    _isAuthenticated = false;
    
    // Clear SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_email');
    await prefs.remove('user_name');
    await prefs.remove('user_phone');
    await prefs.remove('user_location');
    await prefs.remove('user_account_type');
    
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
