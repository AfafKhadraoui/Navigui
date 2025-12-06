import '../../models/student_model.dart';
import '../../models/employer_model.dart';
import '../../models/user_model.dart';

/// Abstract repository for user profile operations
abstract class UserRepository {
  /// Get student profile by user ID
  Future<StudentModel> getStudentProfile(String userId);

  /// Get employer profile by user ID
  Future<EmployerModel> getEmployerProfile(String userId);

  /// Update student profile
  Future<StudentModel> updateStudentProfile({
    required String userId,
    String? university,
    String? faculty,
    String? major,
    String? yearOfStudy,
    String? bio,
    String? cvUrl,
    List<String>? skills,
    List<String>? languages,
    String? availability,
    String? transportation,
    String? previousExperience,
    String? websiteUrl,
    List<String>? socialMediaLinks,
    List<String>? portfolio,
    bool? isPhonePublic,
    String? profileVisibility,
  });

  /// Update employer profile
  Future<EmployerModel> updateEmployerProfile({
    required String userId,
    String? businessName,
    String? businessType,
    String? industry,
    String? description,
    String? location,
    String? address,
    String? logo,
    String? websiteUrl,
    String? verificationDocumentUrl,
    List<String>? socialMediaLinks,
    Map<String, dynamic>? contactInfo,
  });

  /// Update user basic info
  Future<UserModel> updateUser({
    required String userId,
    String? name,
    String? phoneNumber,
    String? location,
    String? profilePicture,
  });

  /// Delete user account
  Future<void> deleteUser(String userId);

  /// Get user basic info
  Future<UserModel> getUser(String userId);
}
