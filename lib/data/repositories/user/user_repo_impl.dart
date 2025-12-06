import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user_repo_abstract.dart';
import '../../models/student_model.dart';
import '../../models/employer_model.dart';
import '../../models/user_model.dart';

/// Implementation of UserRepository with HTTP calls
class UserRepositoryImpl implements UserRepository {
  final String baseUrl;
  final http.Client httpClient;
  final String? Function() getAuthToken;

  UserRepositoryImpl({
    required this.baseUrl,
    required this.getAuthToken,
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client();

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (getAuthToken() != null) 'Authorization': 'Bearer ${getAuthToken()}',
      };

  @override
  Future<StudentModel> getStudentProfile(String userId) async {
    try {
      final response = await httpClient.get(
        Uri.parse('$baseUrl/students/$userId/profile'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return StudentModel.fromJson(data['profile']);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to load student profile');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<EmployerModel> getEmployerProfile(String userId) async {
    try {
      final response = await httpClient.get(
        Uri.parse('$baseUrl/employers/$userId/profile'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return EmployerModel.fromJson(data['profile']);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to load employer profile');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
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
    try {
      final body = <String, dynamic>{};
      if (university != null) body['university'] = university;
      if (faculty != null) body['faculty'] = faculty;
      if (major != null) body['major'] = major;
      if (yearOfStudy != null) body['yearOfStudy'] = yearOfStudy;
      if (bio != null) body['bio'] = bio;
      if (cvUrl != null) body['cvUrl'] = cvUrl;
      if (skills != null) body['skills'] = skills;
      if (languages != null) body['languages'] = languages;
      if (availability != null) body['availability'] = availability;
      if (transportation != null) body['transportation'] = transportation;
      if (previousExperience != null) body['previousExperience'] = previousExperience;
      if (websiteUrl != null) body['websiteUrl'] = websiteUrl;
      if (socialMediaLinks != null) body['socialMediaLinks'] = socialMediaLinks;
      if (portfolio != null) body['portfolio'] = portfolio;
      if (isPhonePublic != null) body['isPhonePublic'] = isPhonePublic;
      if (profileVisibility != null) body['profileVisibility'] = profileVisibility;

      final response = await httpClient.patch(
        Uri.parse('$baseUrl/students/$userId/profile'),
        headers: _headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return StudentModel.fromJson(data['profile']);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
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
    try {
      final body = <String, dynamic>{};
      if (businessName != null) body['businessName'] = businessName;
      if (businessType != null) body['businessType'] = businessType;
      if (industry != null) body['industry'] = industry;
      if (description != null) body['description'] = description;
      if (location != null) body['location'] = location;
      if (address != null) body['address'] = address;
      if (logo != null) body['logo'] = logo;
      if (websiteUrl != null) body['websiteUrl'] = websiteUrl;
      if (verificationDocumentUrl != null) body['verificationDocumentUrl'] = verificationDocumentUrl;
      if (socialMediaLinks != null) body['socialMediaLinks'] = socialMediaLinks;
      if (contactInfo != null) body['contactInfo'] = contactInfo;

      final response = await httpClient.patch(
        Uri.parse('$baseUrl/employers/$userId/profile'),
        headers: _headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return EmployerModel.fromJson(data['profile']);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<UserModel> updateUser({
    required String userId,
    String? name,
    String? phoneNumber,
    String? location,
    String? profilePicture,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (phoneNumber != null) body['phoneNumber'] = phoneNumber;
      if (location != null) body['location'] = location;
      if (profilePicture != null) body['profilePicture'] = profilePicture;

      final response = await httpClient.patch(
        Uri.parse('$baseUrl/users/$userId'),
        headers: _headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserModel.fromJson(data['user']);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to update user');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      final response = await httpClient.delete(
        Uri.parse('$baseUrl/users/$userId'),
        headers: _headers,
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to delete user');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<UserModel> getUser(String userId) async {
    try {
      final response = await httpClient.get(
        Uri.parse('$baseUrl/users/$userId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserModel.fromJson(data['user']);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to load user');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
