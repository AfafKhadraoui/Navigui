import 'dart:async';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'auth_repo_abstract.dart';
import '../../models/user_model.dart';
import '../../models/student_model.dart';
import '../../models/employer_model.dart';
import '../../../logic/services/secure_storage_service.dart';
import '../../databases/db_helper.dart';

/// Database implementation of AuthRepository using SQLite
/// Reads from the actual database seeded by DatabaseSeeder
class DatabaseAuthRepository implements AuthRepository {
  final SecureStorageService _secureStorage;

  DatabaseAuthRepository({SecureStorageService? secureStorage})
      : _secureStorage = secureStorage ?? SecureStorageService();

  String? _currentToken;
  String? _currentUserId;

  /// Hash password using SHA256 (in production, use bcrypt)
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      print('🔍 DATABASE LOGIN ATTEMPT: $email');
      
      final db = await DBHelper.getDatabase();
      
      // Query user from database (case-insensitive email)
      final result = await db.query(
        'users',
        where: 'LOWER(email) = ?',
        whereArgs: [email.toLowerCase()],
        limit: 1,
      );

      if (result.isEmpty) {
        print('❌ User not found in database: $email');
        throw Exception('User not found');
      }

      final userData = result.first;
      print('✅ User found: ${userData['name']}');

      // Check password hash
      final hashedPassword = _hashPassword(password);
      if (userData['password_hash'] != hashedPassword) {
        print('❌ Invalid password for: $email');
        throw Exception('Invalid password');
      }

      print('✅ Password correct, logging in...');

      // Check if account is active
      if (userData['is_active'] == 0) {
        throw Exception('Account is deactivated');
      }

      // Generate mock token
      _currentToken = 'db_token_${DateTime.now().millisecondsSinceEpoch}';
      _currentUserId = userData['id'].toString();

      // Update last login timestamp
      await db.update(
        'users',
        {'last_login_at': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [userData['id']],
      );

      // Save session to secure storage (encrypted)
      await _secureStorage.saveUserSession(
        authToken: _currentToken!,
        userId: _currentUserId!,
        email: userData['email'] as String,
        userType: userData['account_type'] as String,
        name: userData['name'] as String,
      );

      // Also save additional user data to secure storage
      await _secureStorage.saveUserPhone(userData['phone_number'] as String);
      await _secureStorage.saveUserLocation(userData['location'] as String);

      print('✅ Login successful! Role: ${userData['account_type']}');

      // Return user model
      return UserModel(
        id: userData['id'].toString(),
        email: userData['email'] as String,
        name: userData['name'] as String,
        phoneNumber: userData['phone_number'] as String,
        location: userData['location'] as String,
        accountType: userData['account_type'] as String,
        profilePicture: userData['profile_picture_url'] as String?,
        isEmailVerified: userData['is_email_verified'] == 1,
        isActive: userData['is_active'] == 1,
        createdAt: DateTime.parse(userData['created_at'] as String),
        lastLoginAt: userData['last_login_at'] != null 
            ? DateTime.parse(userData['last_login_at'] as String)
            : null,
      );
    } catch (e) {
      print('❌ Login error: $e');
      rethrow;
    }
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
    try {
      print('📝 DATABASE SIGNUP: $email as $accountType');
      
      final db = await DBHelper.getDatabase();

      // Check if email already exists
      final existingUser = await db.query(
        'users',
        where: 'LOWER(email) = ?',
        whereArgs: [email.toLowerCase()],
      );

      if (existingUser.isNotEmpty) {
        throw Exception('Email already registered');
      }

      // Hash password
      final hashedPassword = _hashPassword(password);

      // Insert new user
      final userId = await db.insert('users', {
        'email': email,
        'password_hash': hashedPassword,
        'account_type': accountType,
        'name': name,
        'phone_number': phoneNumber,
        'location': location,
        'profile_picture_url': profilePicture,
        'is_email_verified': 0, // Default false
        'is_active': 1, // Default true
        'created_at': DateTime.now().toIso8601String(),
      });

      print('✅ User created with ID: $userId');

      // Generate token
      _currentToken = 'db_token_${DateTime.now().millisecondsSinceEpoch}';
      _currentUserId = userId.toString();

      // Save session to secure storage (encrypted)
      await _secureStorage.saveUserSession(
        authToken: _currentToken!,
        userId: _currentUserId!,
        email: email,
        userType: accountType,
        name: name,
      );

      // Save additional user data to secure storage
      await _secureStorage.saveUserPhone(phoneNumber);
      await _secureStorage.saveUserLocation(location);

      return UserModel(
        id: userId.toString(),
        email: email,
        name: name,
        phoneNumber: phoneNumber,
        location: location,
        accountType: accountType,
        profilePicture: profilePicture,
        isEmailVerified: false,
        isActive: true,
        createdAt: DateTime.now(),
        lastLoginAt: null,
      );
    } catch (e) {
      print('❌ Signup error: $e');
      rethrow;
    }
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
    try {
      final db = await DBHelper.getDatabase();

      // Insert student profile
      await db.insert('student_profiles', {
        'user_id': int.parse(userId),
        'university': university,
        'faculty': faculty,
        'major': major,
        'year_of_study': yearOfStudy,
        'bio': bio,
        'availability': availability,
        'website_url': websiteUrl,
        'portfolio': portfolio?.join(','), // Store as comma-separated
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      // Insert skills if provided
      if (skills != null && skills.isNotEmpty) {
        for (final skill in skills) {
          await db.insert('student_skills', {
            'user_id': int.parse(userId),
            'skill_name': skill,
          });
        }
      }

      // Fetch the created profile
      final result = await db.rawQuery('''
        SELECT 
          sp.*,
          u.name, u.email, u.phone_number, u.location, u.profile_picture_url
        FROM student_profiles sp
        JOIN users u ON sp.user_id = u.id
        WHERE sp.user_id = ?
      ''', [int.parse(userId)]);

      if (result.isEmpty) {
        throw Exception('Failed to create student profile');
      }

      final data = result.first;
      return StudentModel(
        id: userId,
        email: data['email'] as String,
        name: data['name'] as String,
        phoneNumber: data['phone_number'] as String,
        location: data['location'] as String,
        accountType: 'student',
        profilePicture: data['profile_picture_url'] as String?,
        university: data['university'] as String,
        faculty: data['faculty'] as String,
        major: data['major'] as String,
        yearOfStudy: data['year_of_study'] as String,
        bio: data['bio'] as String?,
        skills: skills ?? [],
        availability: data['availability'] as String?,
        websiteUrl: data['website_url'] as String?,
        portfolio: data['portfolio'] != null 
            ? (data['portfolio'] as String).split(',')
            : [],
        isEmailVerified: true,
        isActive: true,
        createdAt: DateTime.parse(data['created_at'] as String),
      );
    } catch (e) {
      print('❌ Create student profile error: $e');
      rethrow;
    }
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
    try {
      final db = await DBHelper.getDatabase();

      // Insert employer profile
      await db.insert('employer_profiles', {
        'user_id': int.parse(userId),
        'business_name': businessName,
        'business_type': businessType,
        'industry': industry,
        'description': description,
        'address': address,
        'logo': logo,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      // Fetch the created profile
      final result = await db.rawQuery('''
        SELECT 
          ep.*,
          u.name, u.email, u.phone_number, u.location, u.profile_picture_url
        FROM employer_profiles ep
        JOIN users u ON ep.user_id = u.id
        WHERE ep.user_id = ?
      ''', [int.parse(userId)]);

      if (result.isEmpty) {
        throw Exception('Failed to create employer profile');
      }

      final data = result.first;
      return EmployerModel(
        id: userId,
        email: data['email'] as String,
        name: data['name'] as String,
        phoneNumber: data['phone_number'] as String,
        location: data['location'] as String,
        accountType: 'employer',
        profilePicture: data['profile_picture_url'] as String?,
        businessName: data['business_name'] as String,
        businessType: data['business_type'] as String,
        industry: data['industry'] as String,
        description: data['description'] as String?,
        address: data['address'] as String?,
        logo: data['logo'] as String?,
        isEmailVerified: true,
        isActive: true,
        createdAt: DateTime.parse(data['created_at'] as String),
      );
    } catch (e) {
      print('❌ Create employer profile error: $e');
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    await _secureStorage.clearUserSession();
    _currentToken = null;
    _currentUserId = null;
  }

  @override
  Future<void> updateLastLogin(String userId) async {
    final db = await DBHelper.getDatabase();
    await db.update(
      'users',
      {'last_login_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [int.parse(userId)],
    );
  }

  @override
  Future<bool> isAuthenticated() async {
    final session = await _secureStorage.getUserSession();
    return session != null;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    if (_currentUserId == null) {
      final session = await _secureStorage.getUserSession();
      if (session == null) return null;
      _currentUserId = session['userId'];
      _currentToken = session['authToken'];
    }

    final db = await DBHelper.getDatabase();
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [int.parse(_currentUserId!)],
    );

    if (result.isEmpty) return null;

    final data = result.first;
    return UserModel(
      id: data['id'].toString(),
      email: data['email'] as String,
      name: data['name'] as String,
      phoneNumber: data['phone_number'] as String,
      location: data['location'] as String,
      accountType: data['account_type'] as String,
      profilePicture: data['profile_picture_url'] as String?,
      isEmailVerified: data['is_email_verified'] == 1,
      isActive: data['is_active'] == 1,
      createdAt: DateTime.parse(data['created_at'] as String),
      lastLoginAt: data['last_login_at'] != null 
          ? DateTime.parse(data['last_login_at'] as String)
          : null,
    );
  }
}
