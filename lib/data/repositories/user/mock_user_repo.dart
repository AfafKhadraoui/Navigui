import 'dart:async';
import 'user_repo_abstract.dart';
import '../../models/student_model.dart';
import '../../models/employer_model.dart';
import '../../models/user_model.dart';

/// Mock implementation of UserRepository for testing without backend
/// Pre-seeded with test data for student and employer accounts
class MockUserRepository implements UserRepository {
  // In-memory storage for student profiles
  final Map<String, Map<String, dynamic>> _studentProfiles = {
    'student-001': {
      'userId': 'student-001',
      'university': 'Lebanese International University',
      'faculty': 'Engineering',
      'major': 'Computer Science',
      'yearOfStudy': 'Third Year',
      'bio': 'Passionate about mobile development and UI/UX design',
      'cvUrl': 'https://example.com/cv/student001.pdf',
      'skills': ['Flutter', 'Dart', 'Firebase', 'UI/UX'],
      'languages': ['Arabic', 'English', 'French'],
      'availability': 'Part-time',
      'transportation': 'Public Transport',
      'previousExperience': '6 months internship at Tech Company',
      'websiteUrl': 'https://portfolio.example.com',
      'socialMediaLinks': ['https://linkedin.com/in/student', 'https://github.com/student'],
      'portfolio': ['https://example.com/project1', 'https://example.com/project2'],
      'isPhonePublic': true,
      'profileVisibility': 'public',
      'rating': 4.5,
      'completedJobs': 3,
      'savedJobs': [],
      'appliedJobs': [],
      'applicationHistory': [],
      'createdAt': DateTime.now().subtract(Duration(days: 90)).toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    },
  };

  // In-memory storage for employer profiles
  final Map<String, Map<String, dynamic>> _employerProfiles = {
    'employer-001': {
      'userId': 'employer-001',
      'businessName': 'Tech Solutions Inc.',
      'businessType': 'Technology Company',
      'industry': 'Information Technology',
      'description': 'Leading provider of innovative software solutions',
      'location': 'Beirut, Lebanon',
      'address': '123 Main Street, Beirut',
      'logo': 'https://example.com/logos/techsolutions.png',
      'websiteUrl': 'https://techsolutions.example.com',
      'verificationDocumentUrl': 'https://example.com/verification/employer001.pdf',
      'socialMediaLinks': ['https://linkedin.com/company/techsolutions', 'https://twitter.com/techsolutions'],
      'contactInfo': {
        'email': 'hr@techsolutions.com',
        'phone': '+961 1 234567',
        'whatsapp': '+961 70 123456'
      },
      'verificationStatus': 'verified',
      'isVerified': true,
      'rating': 4.8,
      'totalJobsPosted': 15,
      'activeJobsPosted': 5,
      'postedJobs': [],
      'savedStudents': [],
      'createdAt': DateTime.now().subtract(Duration(days: 180)).toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    },
  };

  // In-memory storage for users
  final Map<String, Map<String, dynamic>> _users = {
    'student-001': {
      'id': 'student-001',
      'email': 'student@test.com',
      'name': 'Test Student',
      'phoneNumber': '+961 70 123456',
      'location': 'Beirut, Lebanon',
      'profilePicture': 'https://example.com/avatars/student.jpg',
      'accountType': 'student',
      'isEmailVerified': true,
      'isActive': true,
      'lastLoginAt': DateTime.now().toIso8601String(),
      'createdAt': DateTime.now().subtract(Duration(days: 90)).toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'deletedAt': null,
    },
    'employer-001': {
      'id': 'employer-001',
      'email': 'employer@test.com',
      'name': 'Test Employer',
      'phoneNumber': '+961 1 234567',
      'location': 'Beirut, Lebanon',
      'profilePicture': 'https://example.com/avatars/employer.jpg',
      'accountType': 'employer',
      'isEmailVerified': true,
      'isActive': true,
      'lastLoginAt': DateTime.now().toIso8601String(),
      'createdAt': DateTime.now().subtract(Duration(days: 180)).toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'deletedAt': null,
    },
  };

  /// Simulates network delay (500ms)
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<StudentModel> getStudentProfile(String userId) async {
    await _simulateNetworkDelay();

    if (!_studentProfiles.containsKey(userId)) {
      throw Exception('Student profile not found');
    }

    final profileData = _studentProfiles[userId]!;
    return StudentModel.fromJson(profileData);
  }

  @override
  Future<EmployerModel> getEmployerProfile(String userId) async {
    await _simulateNetworkDelay();

    if (!_employerProfiles.containsKey(userId)) {
      throw Exception('Employer profile not found');
    }

    final profileData = _employerProfiles[userId]!;
    return EmployerModel.fromJson(profileData);
  }

  @override
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
  }) async {
    await _simulateNetworkDelay();

    if (!_studentProfiles.containsKey(userId)) {
      throw Exception('Student profile not found');
    }

    final profile = _studentProfiles[userId]!;

    // Update only provided fields
    if (university != null) profile['university'] = university;
    if (faculty != null) profile['faculty'] = faculty;
    if (major != null) profile['major'] = major;
    if (yearOfStudy != null) profile['yearOfStudy'] = yearOfStudy;
    if (bio != null) profile['bio'] = bio;
    if (cvUrl != null) profile['cvUrl'] = cvUrl;
    if (skills != null) profile['skills'] = skills;
    if (languages != null) profile['languages'] = languages;
    if (availability != null) profile['availability'] = availability;
    if (transportation != null) profile['transportation'] = transportation;
    if (previousExperience != null) profile['previousExperience'] = previousExperience;
    if (websiteUrl != null) profile['websiteUrl'] = websiteUrl;
    if (socialMediaLinks != null) profile['socialMediaLinks'] = socialMediaLinks;
    if (portfolio != null) profile['portfolio'] = portfolio;
    if (isPhonePublic != null) profile['isPhonePublic'] = isPhonePublic;
    if (profileVisibility != null) profile['profileVisibility'] = profileVisibility;

    profile['updatedAt'] = DateTime.now().toIso8601String();

    return StudentModel.fromJson(profile);
  }

  @override
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
  }) async {
    await _simulateNetworkDelay();

    if (!_employerProfiles.containsKey(userId)) {
      throw Exception('Employer profile not found');
    }

    final profile = _employerProfiles[userId]!;

    // Update only provided fields
    if (businessName != null) profile['businessName'] = businessName;
    if (businessType != null) profile['businessType'] = businessType;
    if (industry != null) profile['industry'] = industry;
    if (description != null) profile['description'] = description;
    if (location != null) profile['location'] = location;
    if (address != null) profile['address'] = address;
    if (logo != null) profile['logo'] = logo;
    if (websiteUrl != null) profile['websiteUrl'] = websiteUrl;
    if (verificationDocumentUrl != null) profile['verificationDocumentUrl'] = verificationDocumentUrl;
    if (socialMediaLinks != null) profile['socialMediaLinks'] = socialMediaLinks;
    if (contactInfo != null) profile['contactInfo'] = contactInfo;

    profile['updatedAt'] = DateTime.now().toIso8601String();

    return EmployerModel.fromJson(profile);
  }

  @override
  Future<UserModel> updateUser({
    required String userId,
    String? name,
    String? phoneNumber,
    String? location,
    String? profilePicture,
  }) async {
    await _simulateNetworkDelay();

    if (!_users.containsKey(userId)) {
      throw Exception('User not found');
    }

    final user = _users[userId]!;

    // Update only provided fields
    if (name != null) user['name'] = name;
    if (phoneNumber != null) user['phoneNumber'] = phoneNumber;
    if (location != null) user['location'] = location;
    if (profilePicture != null) user['profilePicture'] = profilePicture;

    user['updatedAt'] = DateTime.now().toIso8601String();

    return UserModel.fromJson(user);
  }

  @override
  Future<void> deleteUser(String userId) async {
    await _simulateNetworkDelay();

    if (!_users.containsKey(userId)) {
      throw Exception('User not found');
    }

    // Soft delete
    _users[userId]!['deletedAt'] = DateTime.now().toIso8601String();
    _users[userId]!['isActive'] = false;
  }

  @override
  Future<UserModel> getUser(String userId) async {
    await _simulateNetworkDelay();

    if (!_users.containsKey(userId)) {
      throw Exception('User not found');
    }

    final userData = _users[userId]!;
    return UserModel.fromJson(userData);
  }

  /// Helper method to add a new student profile for testing
  void addStudentProfile(String userId, Map<String, dynamic> profileData) {
    _studentProfiles[userId] = profileData;
  }

  /// Helper method to add a new employer profile for testing
  void addEmployerProfile(String userId, Map<String, dynamic> profileData) {
    _employerProfiles[userId] = profileData;
  }

  /// Helper method to add a new user for testing
  void addUser(String userId, Map<String, dynamic> userData) {
    _users[userId] = userData;
  }

  /// Clear all data (useful for testing)
  void clearAll() {
    _studentProfiles.clear();
    _employerProfiles.clear();
    _users.clear();
  }
}
