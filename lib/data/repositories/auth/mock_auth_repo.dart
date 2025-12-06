import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_repo_abstract.dart';
import '../../models/user_model.dart';
import '../../models/student_model.dart';
import '../../models/employer_model.dart';
import '../../../logic/services/secure_storage_service.dart';

/// Mock implementation of AuthRepository for testing without backend
/// This simulates API responses with delays to mimic real network calls
/// Now integrated with SecureStorageService for token persistence
class MockAuthRepository implements AuthRepository {
  final SecureStorageService _secureStorage;

  MockAuthRepository({SecureStorageService? secureStorage})
      : _secureStorage = secureStorage ?? SecureStorageService();

  // Simulated in-memory database
  final Map<String, Map<String, dynamic>> _users = {
    // Default test accounts for easy access
    'admin@navigui.com': {
      'id': 'admin-001',
      'email': 'admin@navigui.com',
      'password': 'admin123',
      'name': 'Admin User',
      'phoneNumber': '+213555000001',
      'location': 'Alger',
      'accountType': 'admin',
      'profilePicture': null,
      'isEmailVerified': true,
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 90)).toIso8601String(),
    },
    'employer@navigui.com': {
      'id': 'employer-001',
      'email': 'employer@navigui.com',
      'password': 'employer123',
      'name': 'Employer User',
      'phoneNumber': '+213555000002',
      'location': 'Oran',
      'accountType': 'employer',
      'profilePicture': null,
      'isEmailVerified': true,
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 60)).toIso8601String(),
    },
    'student@navigui.com': {
      'id': 'student-001',
      'email': 'student@navigui.com',
      'password': 'student123',
      'name': 'Student User',
      'phoneNumber': '+213555000003',
      'location': 'Alger',
      'accountType': 'student',
      'profilePicture': null,
      'isEmailVerified': true,
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
    },
    // Pre-seeded test users (legacy)
    'student@test.com': {
      'id': 'student-002',
      'email': 'student@test.com',
      'password': 'password123',
      'name': 'Test Student',
      'phoneNumber': '+213555123456',
      'location': 'Alger',
      'accountType': 'student',
      'profilePicture': null,
      'isEmailVerified': true,
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
    },
    'employer@test.com': {
      'id': 'employer-002',
      'email': 'employer@test.com',
      'password': 'password123',
      'name': 'Test Employer',
      'phoneNumber': '+213555654321',
      'location': 'Oran',
      'accountType': 'employer',
      'profilePicture': null,
      'isEmailVerified': true,
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 60)).toIso8601String(),
    },
  };

  String? _currentToken;
  String? _currentUserId;

  @override
  Future<UserModel> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Debug: Print available users
    print('🔍 LOGIN ATTEMPT: $email');
    print('📋 Available users: ${_users.keys.toList()}');
    
    // Check if user exists (case-insensitive)
    final lowerEmail = email.toLowerCase();
    if (!_users.containsKey(lowerEmail)) {
      print('❌ User not found: $email');
      throw Exception('User not found');
    }

    final userData = _users[lowerEmail]!;
    print('✅ User found: ${userData['name']}');

    // Check password
    if (userData['password'] != password) {
      print('❌ Invalid password for: $email');
      throw Exception('Invalid password');
    }

    print('✅ Password correct, logging in...');

    // Generate mock token
    _currentToken = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
    _currentUserId = userData['id'];

    // Update last login
    userData['lastLoginAt'] = DateTime.now().toIso8601String();

    // Save session to secure storage
    await _secureStorage.saveUserSession(
      authToken: _currentToken!,
      userId: userData['id'],
      email: userData['email'],
      userType: userData['accountType'],
      name: userData['name'],
    );

    // Save to SharedPreferences for role-based navigation
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', userData['email']);
    await prefs.setString('user_name', userData['name']);
    await prefs.setString('user_phone', userData['phoneNumber']);
    await prefs.setString('user_location', userData['location']);
    await prefs.setString('user_account_type', userData['accountType']);

    // Return user model (without password)
    return UserModel.fromJson({
      'id': userData['id'],
      'email': userData['email'],
      'name': userData['name'],
      'phoneNumber': userData['phoneNumber'],
      'location': userData['location'],
      'accountType': userData['accountType'],
      'profilePicture': userData['profilePicture'],
      'isEmailVerified': userData['isEmailVerified'],
      'isActive': userData['isActive'],
      'lastLoginAt': userData['lastLoginAt'],
      'createdAt': userData['createdAt'],
    });
  }

  @override
  Future<UserModel> signup({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    required String location,
    required String accountType,
    String? profilePicture,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1500));

    // Check if user already exists
    if (_users.containsKey(email)) {
      throw Exception('Email already registered');
    }

    // Create new user
    final userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
    final now = DateTime.now();

    final userData = {
      'id': userId,
      'email': email,
      'password': password, // In real app, this would be hashed
      'name': name,
      'phoneNumber': phoneNumber,
      'location': location,
      'accountType': accountType,
      'profilePicture': profilePicture,
      'isEmailVerified': false,
      'isActive': true,
      'createdAt': now.toIso8601String(),
    };

    _users[email] = userData;

    // Generate mock token
    _currentToken = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
    _currentUserId = userId;

    // Save session to secure storage
    await _secureStorage.saveUserSession(
      authToken: _currentToken!,
      userId: userId,
      email: email,
      userType: accountType,
      name: name,
    );

    // Save to SharedPreferences for role-based navigation
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', email);
    await prefs.setString('user_name', name);
    await prefs.setString('user_phone', phoneNumber);
    await prefs.setString('user_location', location);
    await prefs.setString('user_account_type', accountType);

    // Return user model
    return UserModel.fromJson({
      'id': userData['id'],
      'email': userData['email'],
      'name': userData['name'],
      'phoneNumber': userData['phoneNumber'],
      'location': userData['location'],
      'accountType': userData['accountType'],
      'profilePicture': userData['profilePicture'],
      'isEmailVerified': userData['isEmailVerified'],
      'isActive': userData['isActive'],
      'createdAt': userData['createdAt'],
    });
  }

  @override
  Future<StudentModel> createStudentProfile({
    required String userId,
    required String university,
    required String faculty,
    required String major,
    required String yearOfStudy,
    String? bio,
    List<String>? skills,
    String? availability,
    String? websiteUrl,
    List<String>? portfolio,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    if (_currentToken == null) {
      throw Exception('Not authenticated');
    }

    // Create student profile
    return StudentModel(
      userId: userId,
      university: university,
      faculty: faculty,
      major: major,
      yearOfStudy: yearOfStudy,
      bio: bio,
      skills: skills ?? [],
      availability: availability,
      websiteUrl: websiteUrl,
      portfolio: portfolio,
    );
  }

  @override
  Future<EmployerModel> createEmployerProfile({
    required String userId,
    required String businessName,
    required String businessType,
    required String industry,
    String? description,
    String? address,
    String? logo,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    if (_currentToken == null) {
      throw Exception('Not authenticated');
    }

    // Create employer profile
    return EmployerModel(
      userId: userId,
      businessName: businessName,
      businessType: businessType,
      industry: industry,
      description: description,
      address: address,
      logo: logo,
    );
  }

  @override
  Future<void> logout() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Clear secure storage
    await _secureStorage.clearAll();

    _currentToken = null;
    _currentUserId = null;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Try to get user from secure storage first
    final storedUserId = await _secureStorage.getUserId();
    final storedToken = await _secureStorage.getAuthToken();

    if (storedToken != null && storedUserId != null) {
      _currentToken = storedToken;
      _currentUserId = storedUserId;
    }

    if (_currentToken == null || _currentUserId == null) {
      return null;
    }

    // Find user by ID
    final userEntry = _users.entries.firstWhere(
      (entry) => entry.value['id'] == _currentUserId,
      orElse: () => MapEntry('', {}),
    );

    if (userEntry.key.isEmpty) {
      return null;
    }

    final userData = userEntry.value;
    return UserModel.fromJson({
      'id': userData['id'],
      'email': userData['email'],
      'name': userData['name'],
      'phoneNumber': userData['phoneNumber'],
      'location': userData['location'],
      'accountType': userData['accountType'],
      'profilePicture': userData['profilePicture'],
      'isEmailVerified': userData['isEmailVerified'],
      'isActive': userData['isActive'],
      'lastLoginAt': userData['lastLoginAt'],
      'createdAt': userData['createdAt'],
    });
  }

  @override
  Future<bool> isAuthenticated() async {
    // Check secure storage first
    final hasToken = await _secureStorage.hasAuthToken();
    if (hasToken) {
      final token = await _secureStorage.getAuthToken();
      final userId = await _secureStorage.getUserId();
      _currentToken = token;
      _currentUserId = userId;
      return true;
    }
    return _currentToken != null;
  }

  @override
  Future<void> refreshToken() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));

    if (_currentToken == null) {
      throw Exception('No token to refresh');
    }

    // Generate new token
    _currentToken = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (!_users.containsKey(email)) {
      throw Exception('Email not found');
    }

    // In real app, would send email with reset link
    print('Password reset email sent to: $email');
  }

  @override
  Future<void> resetPassword(String token, String newPassword) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // In real app, would verify token and update password
    if (_currentUserId == null) {
      throw Exception('Invalid or expired token');
    }

    // Update password for current user
    final userEntry = _users.entries.firstWhere(
      (entry) => entry.value['id'] == _currentUserId,
      orElse: () => MapEntry('', {}),
    );

    if (userEntry.key.isNotEmpty) {
      _users[userEntry.key]!['password'] = newPassword;
    }
  }

  @override
  Future<void> verifyEmail(String token) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    // In real app, would verify token
    if (_currentUserId == null) {
      throw Exception('Invalid or expired token');
    }

    // Mark email as verified
    final userEntry = _users.entries.firstWhere(
      (entry) => entry.value['id'] == _currentUserId,
      orElse: () => MapEntry('', {}),
    );

    if (userEntry.key.isNotEmpty) {
      _users[userEntry.key]!['isEmailVerified'] = true;
    }
  }

  @override
  Future<void> updateLastLogin(String userId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));

    // Update last login timestamp
    final userEntry = _users.entries.firstWhere(
      (entry) => entry.value['id'] == userId,
      orElse: () => MapEntry('', {}),
    );

    if (userEntry.key.isNotEmpty) {
      _users[userEntry.key]!['lastLoginAt'] = DateTime.now().toIso8601String();
    }
  }

  // Helper method to add more test users if needed
  void addTestUser(String email, String password, Map<String, dynamic> userData) {
    _users[email] = {
      'password': password,
      ...userData,
    };
  }
}
