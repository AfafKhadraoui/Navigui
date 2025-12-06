// lib/data/repositories/admin/admin_repo_abstract.dart

import '../../models/user_model.dart';
import '../../models/job_post.dart';

/// Abstract Admin Repository
/// Defines interface for admin operations
abstract class AdminRepository {
  /// Get dashboard statistics
  Future<Map<String, dynamic>> getDashboardStatistics();

  /// Get all users with optional filters
  Future<List<UserModel>> getUsers({
    String? roleFilter,
    String? statusFilter,
  });

  /// Get all jobs with optional filters
  Future<List<JobPost>> getJobs({String? statusFilter});

  /// Update user status (active, suspended, etc.)
  Future<UserModel> updateUserStatus(String userId, String status);

  /// Delete a job posting
  Future<void> deleteJob(String jobId);

  /// Get user count by role
  Future<int> getUserCountByRole(String role);

  /// Get job statistics
  Future<Map<String, int>> getJobStatistics();

  /// Get application statistics
  Future<Map<String, int>> getApplicationStatistics();
}
