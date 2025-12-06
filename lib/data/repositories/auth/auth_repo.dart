import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth_repo_abstract.dart';
import '../../models/user_model.dart';
import '../../models/student_model.dart';
import '../../models/employer_model.dart';

/// Implementation of AuthRepository
/// Handles API calls for authentication operations
class AuthRepositoryImpl implements AuthRepository {
  final String baseUrl;
  final http.Client httpClient;
  String? _authToken;

  AuthRepositoryImpl({
    required this.baseUrl,
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client();

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await httpClient.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _authToken = data['token'];
        return UserModel.fromJson(data['user']);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Login failed');
      }
    } catch (e) {
      throw Exception('Network error: $e');
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
      final response = await httpClient.post(
        Uri.parse('$baseUrl/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'name': name,
          'phoneNumber': phoneNumber,
          'location': location,
          'accountType': accountType,
          'profilePicture': profilePicture,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        _authToken = data['token'];
        return UserModel.fromJson(data['user']);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Signup failed');
      }
    } catch (e) {
      throw Exception('Network error: $e');
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
      final response = await httpClient.post(
        Uri.parse('$baseUrl/students/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
        body: jsonEncode({
          'userId': userId,
          'university': university,
          'faculty': faculty,
          'major': major,
          'yearOfStudy': yearOfStudy,
          'bio': bio,
          'skills': skills,
          'availability': availability,
          'websiteUrl': websiteUrl,
          'portfolio': portfolio,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return StudentModel.fromJson(data['profile']);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Profile creation failed');
      }
    } catch (e) {
      throw Exception('Network error: $e');
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
      final response = await httpClient.post(
        Uri.parse('$baseUrl/employers/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
        body: jsonEncode({
          'userId': userId,
          'businessName': businessName,
          'businessType': businessType,
          'industry': industry,
          'description': description,
          'address': address,
          'logo': logo,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return EmployerModel.fromJson(data['profile']);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Profile creation failed');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await httpClient.post(
        Uri.parse('$baseUrl/auth/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
      );
      _authToken = null;
    } catch (e) {
      // Clear token even on error
      _authToken = null;
      throw Exception('Logout error: $e');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    if (_authToken == null) return null;

    try {
      final response = await httpClient.get(
        Uri.parse('$baseUrl/auth/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserModel.fromJson(data['user']);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return _authToken != null;
  }

  @override
  Future<void> refreshToken() async {
    try {
      final response = await httpClient.post(
        Uri.parse('$baseUrl/auth/refresh'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _authToken = data['token'];
      } else {
        throw Exception('Token refresh failed');
      }
    } catch (e) {
      throw Exception('Token refresh error: $e');
    }
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    try {
      final response = await httpClient.post(
        Uri.parse('$baseUrl/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Password reset request failed');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<void> resetPassword(String token, String newPassword) async {
    try {
      final response = await httpClient.post(
        Uri.parse('$baseUrl/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'token': token,
          'password': newPassword,
        }),
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Password reset failed');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<void> verifyEmail(String token) async {
    try {
      final response = await httpClient.post(
        Uri.parse('$baseUrl/auth/verify-email'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token}),
      );

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Email verification failed');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<void> updateLastLogin(String userId) async {
    try {
      await httpClient.patch(
        Uri.parse('$baseUrl/users/$userId/last-login'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
      );
    } catch (e) {
      // Non-critical, can fail silently
    }
  }
}
