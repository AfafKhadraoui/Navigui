import '../models/student_model.dart';
import '../models/employer_model.dart';

/// User data repository
/// Handles user-related data operations
class UserRepository {
  Future<StudentModel> getStudentProfile(int userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return StudentModel(
      userId: userId.toString(),
      university: 'University of Algiers',
      faculty: 'Engineering',
      major: 'Computer Science',
      yearOfStudy: '3rd year',
      bio: 'Computer Science student',
      skills: ['Flutter', 'Dart', 'Python'],
      languages: ['Arabic', 'English', 'French'],
    );
  }

  Future<StudentModel> updateStudentProfile({
    required int userId,
    String? bio,
    String? phone,
    String? university,
    String? major,
    int? graduationYear,
    List<String>? skills,
    List<Map<String, dynamic>>? education,
    List<Map<String, dynamic>>? experience,
    String? resumeUrl,
    String? profilePictureUrl,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return await getStudentProfile(userId);
  }

  Future<EmployerModel> getEmployerProfile(int userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return EmployerModel(
      userId: userId.toString(),
      businessName: 'Tech Company',
      businessType: 'Technology Company',
      industry: 'Technology',
      description: 'A leading tech company',
      websiteUrl: 'https://example.com',
    );
  }

  Future<EmployerModel> updateEmployerProfile({
    required int userId,
    String? companyName,
    String? companyDescription,
    String? industry,
    String? website,
    String? phone,
    String? address,
    String? logoUrl,
    int? companySize,
    int? foundedYear,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return await getEmployerProfile(userId);
  }
}
