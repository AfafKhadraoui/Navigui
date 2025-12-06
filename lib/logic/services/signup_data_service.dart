import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// SignupDataService - Temporarily stores signup data across multiple steps
/// Uses SharedPreferences to persist data during the signup flow
class SignupDataService {
  static const String _keySignupData = 'temp_signup_data';
  
  // Student signup data keys
  static const String keyEmail = 'email';
  static const String keyPassword = 'password';
  static const String keyName = 'name';
  static const String keyPhoneNumber = 'phoneNumber';
  static const String keyLocation = 'location';
  static const String keyUniversity = 'university';
  static const String keyFaculty = 'faculty';
  static const String keyMajor = 'major';
  static const String keyYearOfStudy = 'yearOfStudy';
  static const String keySkills = 'skills';
  static const String keyLanguages = 'languages';
  static const String keyAvailability = 'availability';
  static const String keyPortfolio = 'portfolio';
  static const String keyBio = 'bio';
  
  // Employer signup data keys
  static const String keyBusinessName = 'businessName';
  static const String keyBusinessType = 'businessType';
  static const String keyIndustry = 'industry';
  static const String keyAddress = 'address';
  static const String keyDescription = 'description';
  static const String keyLogo = 'logo';
  
  // Account type
  static const String keyAccountType = 'accountType';
  
  /// Save signup data for a specific key
  Future<void> saveData(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    final currentData = await getAllData();
    
    if (value is List<String>) {
      currentData[key] = value;
    } else if (value is String || value is int || value is double || value is bool) {
      currentData[key] = value;
    }
    
    await prefs.setString(_keySignupData, json.encode(currentData));
  }
  
  /// Get signup data for a specific key
  Future<dynamic> getData(String key) async {
    final allData = await getAllData();
    return allData[key];
  }
  
  /// Get all signup data
  Future<Map<String, dynamic>> getAllData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keySignupData);
    
    if (jsonString == null) {
      return {};
    }
    
    return Map<String, dynamic>.from(json.decode(jsonString));
  }
  
  /// Clear all signup data (call after successful signup)
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keySignupData);
  }
  
  /// Save multiple data points at once
  Future<void> saveMultipleData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final currentData = await getAllData();
    
    currentData.addAll(data);
    await prefs.setString(_keySignupData, json.encode(currentData));
  }
  
  /// Check if data exists for a key
  Future<bool> hasData(String key) async {
    final allData = await getAllData();
    return allData.containsKey(key);
  }
  
  /// Get student signup data formatted for API
  Future<Map<String, dynamic>> getStudentSignupData() async {
    final data = await getAllData();
    return {
      'email': data[keyEmail] ?? '',
      'password': data[keyPassword] ?? '',
      'name': data[keyName] ?? '',
      'phoneNumber': data[keyPhoneNumber] ?? '',
      'location': data[keyLocation] ?? '',
      'accountType': 'student',
      'university': data[keyUniversity] ?? '',
      'faculty': data[keyFaculty] ?? '',
      'major': data[keyMajor] ?? '',
      'yearOfStudy': data[keyYearOfStudy] ?? '',
      'skills': data[keySkills] ?? [],
      'languages': data[keyLanguages] ?? [],
      'availability': data[keyAvailability] ?? '',
      'portfolio': data[keyPortfolio] ?? [],
      'bio': data[keyBio] ?? '',
    };
  }
  
  /// Get employer signup data formatted for API
  Future<Map<String, dynamic>> getEmployerSignupData() async {
    final data = await getAllData();
    return {
      'email': data[keyEmail] ?? '',
      'password': data[keyPassword] ?? '',
      'name': data[keyName] ?? '',
      'phoneNumber': data[keyPhoneNumber] ?? '',
      'location': data[keyLocation] ?? '',
      'accountType': 'employer',
      'businessName': data[keyBusinessName] ?? '',
      'businessType': data[keyBusinessType] ?? '',
      'industry': data[keyIndustry] ?? '',
      'address': data[keyAddress] ?? '',
      'description': data[keyDescription] ?? '',
      'logo': data[keyLogo] ?? '',
    };
  }
}
