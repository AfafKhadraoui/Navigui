import 'dart:convert';
import 'package:flutter/services.dart';
import '../data/models/job_model.dart';
import '../data/models/student_model.dart';
import '../data/models/employer_model.dart';
import '../data/models/service_model.dart';
import '../data/models/application_model.dart';
import '../data/models/review_model.dart';
import '../data/models/notification_model.dart';

/// Mock Data Loader for Frontend Development
///
/// This class loads mock data from JSON files in lib/utils/mock_data/ folder
/// Update the methods below to load from YOUR specific JSON files
///
/// Example: Load jobs from lib/utils/mock_data/jobs.json
class MockData {
  // Cached data to avoid reloading
  static List<JobModel>? _jobs;
  static List<StudentModel>? _students;
  static List<EmployerModel>? _employers;
  static List<ServiceModel>? _services;
  static List<ApplicationModel>? _applications;
  static List<ReviewModel>? _reviews;
  static List<NotificationModel>? _notifications;

  /// Load all jobs from JSON file
  /// TODO: Update path to your JSON file in lib/utils/mock_data/
  static Future<List<JobModel>> loadJobs() async {
    if (_jobs != null) return _jobs!;

    try {
      // TODO: Create lib/utils/mock_data/jobs.json and update path
      final jsonString =
          await rootBundle.loadString('lib/utils/mock_data/jobs.json');
      final jsonList = json.decode(jsonString) as List;
      _jobs = jsonList.map((json) => JobModel.fromJson(json)).toList();
      return _jobs!;
    } catch (e) {
      print('Error loading jobs: $e');
      _jobs = [];
      return _jobs!;
    }
  }

  /// Load all students from JSON file
  /// TODO: Update path to your JSON file
  static Future<List<StudentModel>> loadStudents() async {
    if (_students != null) return _students!;

    try {
      final jsonString =
          await rootBundle.loadString('lib/utils/mock_data/students.json');
      final jsonList = json.decode(jsonString) as List;
      _students = jsonList.map((json) => StudentModel.fromJson(json)).toList();
      return _students!;
    } catch (e) {
      print('Error loading students: $e');
      _students = [];
      return _students!;
    }
  }

  /// Load all employers from JSON file
  /// TODO: Update path to your JSON file
  static Future<List<EmployerModel>> loadEmployers() async {
    if (_employers != null) return _employers!;

    try {
      final jsonString =
          await rootBundle.loadString('lib/utils/mock_data/employers.json');
      final jsonList = json.decode(jsonString) as List;
      _employers =
          jsonList.map((json) => EmployerModel.fromJson(json)).toList();
      return _employers!;
    } catch (e) {
      print('Error loading employers: $e');
      _employers = [];
      return _employers!;
    }
  }

  /// Load all services from JSON file
  /// TODO: Update path to your JSON file
  static Future<List<ServiceModel>> loadServices() async {
    if (_services != null) return _services!;

    try {
      final jsonString =
          await rootBundle.loadString('lib/utils/mock_data/services.json');
      final jsonList = json.decode(jsonString) as List;
      _services = jsonList.map((json) => ServiceModel.fromJson(json)).toList();
      return _services!;
    } catch (e) {
      print('Error loading services: $e');
      _services = [];
      return _services!;
    }
  }

  /// Load all applications from JSON file
  /// TODO: Update path to your JSON file
  static Future<List<ApplicationModel>> loadApplications() async {
    if (_applications != null) return _applications!;

    try {
      final jsonString =
          await rootBundle.loadString('lib/utils/mock_data/applications.json');
      final jsonList = json.decode(jsonString) as List;
      _applications =
          jsonList.map((json) => ApplicationModel.fromJson(json)).toList();
      return _applications!;
    } catch (e) {
      print('Error loading applications: $e');
      _applications = [];
      return _applications!;
    }
  }

  /// Load all reviews from JSON file
  /// TODO: Update path to your JSON file
  static Future<List<ReviewModel>> loadReviews() async {
    if (_reviews != null) return _reviews!;

    try {
      final jsonString =
          await rootBundle.loadString('lib/utils/mock_data/reviews.json');
      final jsonList = json.decode(jsonString) as List;
      _reviews = jsonList.map((json) => ReviewModel.fromJson(json)).toList();
      return _reviews!;
    } catch (e) {
      print('Error loading reviews: $e');
      _reviews = [];
      return _reviews!;
    }
  }

  /// Load all notifications from JSON file
  /// TODO: Update path to your JSON file
  static Future<List<NotificationModel>> loadNotifications() async {
    if (_notifications != null) return _notifications!;

    try {
      final jsonString =
          await rootBundle.loadString('lib/utils/mock_data/notifications.json');
      final jsonList = json.decode(jsonString) as List;
      _notifications =
          jsonList.map((json) => NotificationModel.fromJson(json)).toList();
      return _notifications!;
    } catch (e) {
      print('Error loading notifications: $e');
      _notifications = [];
      return _notifications!;
    }
  }

  /// Clear all cached data (useful for refresh)
  static void clearCache() {
    _jobs = null;
    _students = null;
    _employers = null;
    _services = null;
    _applications = null;
    _reviews = null;
    _notifications = null;
  }

  // Helper Methods

  /// Get jobs by category
  static Future<List<JobModel>> getJobsByCategory(String category) async {
    final jobs = await loadJobs();
    return jobs.where((job) => job.category == category).toList();
  }

  /// Get urgent jobs (isUrgent = true)
  static Future<List<JobModel>> getUrgentJobs() async {
    final jobs = await loadJobs();
    return jobs.where((job) => job.isUrgent).toList();
  }

  /// Get active jobs (status = 'active')
  static Future<List<JobModel>> getActiveJobs() async {
    final jobs = await loadJobs();
    return jobs.where((job) => job.status == 'active').toList();
  }

  /// Get student by ID
  static Future<StudentModel?> getStudentById(String userId) async {
    final students = await loadStudents();
    try {
      return students.firstWhere((s) => s.userId == userId);
    } catch (e) {
      return null;
    }
  }

  /// Get employer by ID
  static Future<EmployerModel?> getEmployerById(String userId) async {
    final employers = await loadEmployers();
    try {
      return employers.firstWhere((e) => e.userId == userId);
    } catch (e) {
      return null;
    }
  }
}
