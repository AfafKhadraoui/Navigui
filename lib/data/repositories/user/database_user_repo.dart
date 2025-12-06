// lib/data/repositories/user/database_user_repo.dart

import '../../databases/db_helper.dart';
import '../../models/student_model.dart';
import '../../models/employer_model.dart';
import '../../models/user_model.dart';
import 'user_repo_abstract.dart';

/// Database implementation of UserRepository
/// Uses SQLite for local data storage
class DatabaseUserRepository implements UserRepository {
  @override
  Future<StudentModel> getStudentProfile(String userId) async {
    final db = await DBHelper.getDatabase();
    
    // Query student profile with user data
    final result = await db.rawQuery('''
      SELECT 
        sp.*,
        u.name, u.email, u.phone_number, u.location, u.profile_picture_url
      FROM student_profiles sp
      JOIN users u ON sp.user_id = u.id
      WHERE sp.user_id = ?
    ''', [userId]);

    // If profile doesn't exist, create a default one
    if (result.isEmpty) {
      print('📝 Student profile not found for user $userId. Creating default profile...');
      
      // Get user data to create default profile
      final userResult = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [userId],
      );
      
      if (userResult.isEmpty) {
        throw Exception('User not found');
      }
      
      // Create default student profile
      await db.insert('student_profiles', {
        'user_id': userId,
        'university': '',
        'faculty': '',
        'major': '',
        'year_of_study': '',
        'bio': null,
        'availability': null,
        'transportation': null,
        'previous_experience': null,
        'website_url': null,
        'is_phone_public': 1,
        'profile_visibility': 'public',
        'rating': 0.0,
        'review_count': 0,
        'jobs_completed': 0,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
      
      print('✅ Default student profile created');
      
      // Recursively call to get the newly created profile
      return await getStudentProfile(userId);
    }

    final data = result.first;
    
    // Get skills
    final skillsResult = await db.query(
      'student_skills',
      where: 'student_id = ?',
      whereArgs: [userId],
    );
    final skills = skillsResult.map((s) => s['skill_name'] as String).toList();

    return StudentModel(
      userId: userId,
      university: data['university'] as String? ?? '',
      faculty: data['faculty'] as String? ?? '',
      major: data['major'] as String? ?? '',
      yearOfStudy: data['year_of_study']?.toString() ?? '',
      bio: data['bio'] as String?,
      cvUrl: data['cv_url'] as String?,
      skills: skills,
      languages: [], // TODO: Add languages table support
      availability: data['availability'] as String?,
      transportation: data['transportation'] as String?,
      previousExperience: data['previous_experience'] as String?,
      websiteUrl: data['website_url'] as String?,
      socialMediaLinks: null, // TODO: Add social media support
      portfolio: null, // TODO: Add portfolio support
      isPhonePublic: (data['is_phone_public'] as int?) == 1,
      profileVisibility: data['profile_visibility'] as String? ?? 'public',
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: data['review_count'] as int? ?? 0,
      jobsCompleted: data['jobs_completed'] as int? ?? 0,
    );
  }

  @override
  Future<EmployerModel> getEmployerProfile(String userId) async {
    final db = await DBHelper.getDatabase();
    
    // Query employer profile with user data
    final result = await db.rawQuery('''
      SELECT 
        ep.*,
        u.name, u.email, u.phone_number, u.location, u.profile_picture_url
      FROM employer_profiles ep
      JOIN users u ON ep.user_id = u.id
      WHERE ep.user_id = ?
    ''', [userId]);

    // If profile doesn't exist, create a default one
    if (result.isEmpty) {
      print('📝 Employer profile not found for user $userId. Creating default profile...');
      
      // Get user data to create default profile
      final userResult = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [userId],
      );
      
      if (userResult.isEmpty) {
        throw Exception('User not found');
      }
      
      // Create default employer profile
      await db.insert('employer_profiles', {
        'user_id': userId,
        'business_name': '',
        'business_type': '',
        'industry': '',
        'description': null,
        'location': null,
        'address': null,
        'logo_url': null,
        'website_url': null,
        'verification_document_url': null,
        'is_verified': 0,
        'verification_badge': null,
        'rating': 0.0,
        'review_count': 0,
        'active_jobs': 0,
        'total_jobs_posted': 0,
        'total_hires': 0,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
      
      print('✅ Default employer profile created');
      
      // Recursively call to get the newly created profile
      return await getEmployerProfile(userId);
    }

    final data = result.first;

    return EmployerModel(
      userId: userId,
      businessName: data['business_name'] as String? ?? '',
      businessType: data['business_type'] as String? ?? '',
      industry: data['industry'] as String? ?? '',
      description: data['description'] as String?,
      location: data['location'] as String?,
      address: data['address'] as String?,
      logo: data['logo_url'] as String?,
      websiteUrl: data['website_url'] as String?,
      verificationDocumentUrl: data['verification_document_url'] as String?,
      socialMediaLinks: null, // TODO: Add social media support
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: data['review_count'] as int? ?? 0,
      activeJobs: data['active_jobs'] as int? ?? 0,
      totalJobsPosted: data['total_jobs_posted'] as int? ?? 0,
      totalHires: data['total_hires'] as int? ?? 0,
      isVerified: (data['is_verified'] as int?) == 1,
      verificationBadge: data['verification_badge'] as String?,
      contactInfo: null, // TODO: Add contact info support
    );
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
    final db = await DBHelper.getDatabase();

    // Build update map
    final Map<String, dynamic> updates = {
      'updated_at': DateTime.now().toIso8601String(),
    };
    
    if (university != null) updates['university'] = university;
    if (faculty != null) updates['faculty'] = faculty;
    if (major != null) updates['major'] = major;
    if (yearOfStudy != null) updates['year_of_study'] = yearOfStudy;
    if (bio != null) updates['bio'] = bio;
    if (cvUrl != null) updates['cv_url'] = cvUrl;
    if (availability != null) updates['availability'] = availability;
    if (transportation != null) updates['transportation'] = transportation;
    if (previousExperience != null) updates['previous_experience'] = previousExperience;
    if (websiteUrl != null) updates['website_url'] = websiteUrl;
    if (isPhonePublic != null) updates['is_phone_public'] = isPhonePublic ? 1 : 0;
    if (profileVisibility != null) updates['profile_visibility'] = profileVisibility;

    // Update profile
    await db.update(
      'student_profiles',
      updates,
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    // Update skills if provided
    if (skills != null) {
      // Delete existing skills
      await db.delete(
        'student_skills',
        where: 'student_id = ?',
        whereArgs: [userId],
      );
      
      // Insert new skills
      for (final skill in skills) {
        final skillId = 'skill_${userId}_${skill.replaceAll(' ', '_').toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}';
        await db.insert('student_skills', {
          'id': skillId,
          'student_id': userId,
          'skill_name': skill,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
      }
    }

    // Return updated profile
    return await getStudentProfile(userId);
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
    final db = await DBHelper.getDatabase();

    // Build update map
    final Map<String, dynamic> updates = {};
    
    if (businessName != null) updates['business_name'] = businessName;
    if (businessType != null) updates['business_type'] = businessType;
    if (industry != null) updates['industry'] = industry;
    if (description != null) updates['description'] = description;
    if (location != null) updates['location'] = location;
    if (address != null) updates['address'] = address;
    if (logo != null) updates['logo_url'] = logo;
    if (websiteUrl != null) updates['website_url'] = websiteUrl;
    if (verificationDocumentUrl != null) updates['verification_document_url'] = verificationDocumentUrl;

    // Update profile
    await db.update(
      'employer_profiles',
      updates,
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    // TODO: Handle socialMediaLinks and contactInfo when tables are added

    // Return updated profile
    return await getEmployerProfile(userId);
  }

  @override
  Future<UserModel> getUser(String userId) async {
    final db = await DBHelper.getDatabase();
    
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (result.isEmpty) {
      throw Exception('User not found');
    }

    final data = result.first;
    return UserModel(
      id: data['id'] as String,
      name: data['name'] as String,
      email: data['email'] as String,
      phoneNumber: data['phone_number'] as String? ?? '',
      accountType: data['user_type'] as String,
      location: data['location'] as String? ?? '',
      profilePicture: data['profile_picture_url'] as String?,
      isEmailVerified: (data['is_email_verified'] as int?) == 1,
      isActive: (data['is_active'] as int?) != 0,
      createdAt: DateTime.parse(data['created_at'] as String),
      updatedAt: data['updated_at'] != null ? DateTime.parse(data['updated_at'] as String) : null,
      lastLoginAt: data['last_login_at'] != null ? DateTime.parse(data['last_login_at'] as String) : null,
      deletedAt: data['deleted_at'] != null ? DateTime.parse(data['deleted_at'] as String) : null,
    );
  }

  @override
  Future<UserModel> updateUser({
    required String userId,
    String? name,
    String? phoneNumber,
    String? location,
    String? profilePicture,
  }) async {
    final db = await DBHelper.getDatabase();

    final Map<String, dynamic> updates = {};
    
    if (name != null) updates['name'] = name;
    if (phoneNumber != null) updates['phone_number'] = phoneNumber;
    if (location != null) updates['location'] = location;
    if (profilePicture != null) updates['profile_picture_url'] = profilePicture;

    if (updates.isNotEmpty) {
      await db.update(
        'users',
        updates,
        where: 'id = ?',
        whereArgs: [userId],
      );
    }

    return await getUser(userId);
  }

  @override
  Future<void> deleteUser(String userId) async {
    final db = await DBHelper.getDatabase();
    
    // Soft delete by updating deleted_at timestamp
    await db.update(
      'users',
      {'deleted_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
}
