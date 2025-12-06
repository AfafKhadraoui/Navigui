import '../../models/user_model.dart';
import '../../models/student_model.dart';
import '../../models/employer_model.dart';

/// Abstract repository for authentication operations
/// Defines the contract for auth data operations
abstract class AuthRepository {
  /// Login with email and password
  /// Returns UserModel on success
  /// Throws exception on failure
  Future<UserModel> login(String email, String password);

  /// Signup new user with basic info
  /// Creates entry in users table
  Future<UserModel> signup({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    required String location,
    required String accountType, // 'student' or 'employer'
    String? profilePicture,
  });

  /// Create student profile after signup
  /// Adds entry to student_profiles table
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
  });

  /// Create employer profile after signup
  /// Adds entry to employer_profiles table
  Future<EmployerModel> createEmployerProfile({
    required String userId,
    required String businessName,
    required String businessType,
    required String industry,
    String? description,
    String? address,
    String? logo,
  });

  /// Logout current user
  Future<void> logout();

  /// Get currently authenticated user
  /// Returns null if not authenticated
  Future<UserModel?> getCurrentUser();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();

  /// Refresh authentication token
  Future<void> refreshToken();

  /// Request password reset
  Future<void> requestPasswordReset(String email);

  /// Reset password with token
  Future<void> resetPassword(String token, String newPassword);

  /// Verify email address
  Future<void> verifyEmail(String token);

  /// Update last login timestamp
  Future<void> updateLastLogin(String userId);
}
