// lib/data/repositories/admin/admin_repo_impl.dart

import 'package:sqflite/sqflite.dart';
import '../../databases/db_helper.dart';
import '../../models/user_model.dart';
import '../../models/job_post.dart';
import 'admin_repo_abstract.dart';

/// Implementation of Admin Repository
/// Handles all admin operations with SQLite database
class AdminRepositoryImpl implements AdminRepository {
  Future<Database> get _db async => await DBHelper.getDatabase();

  @override
  Future<Map<String, dynamic>> getDashboardStatistics() async {
    try {
      final db = await _db;

      // Get total users count
      final totalUsersResult = await db.rawQuery('SELECT COUNT(*) as count FROM users WHERE deleted_at IS NULL');
      final totalUsers = totalUsersResult.first['count'] as int;

      // Get users by role
      final studentsResult = await db.rawQuery('SELECT COUNT(*) as count FROM users WHERE account_type = ? AND deleted_at IS NULL', ['student']);
      final employersResult = await db.rawQuery('SELECT COUNT(*) as count FROM users WHERE account_type = ? AND deleted_at IS NULL', ['employer']);
      final totalStudents = studentsResult.first['count'] as int;
      final totalEmployers = employersResult.first['count'] as int;

      // Get total jobs
      final totalJobsResult = await db.rawQuery('SELECT COUNT(*) as count FROM jobs WHERE deleted_at IS NULL');
      final totalJobs = totalJobsResult.first['count'] as int;

      // Get active jobs (not filled, not expired)
      final activeJobsResult = await db.rawQuery('''
        SELECT COUNT(*) as count FROM jobs 
        WHERE is_filled = 0 
        AND deadline >= datetime('now')
        AND deleted_at IS NULL
      ''');
      final activeJobs = activeJobsResult.first['count'] as int;

      // Get total applications
      final totalApplicationsResult = await db.rawQuery('SELECT COUNT(*) as count FROM applications');
      final totalApplications = totalApplicationsResult.first['count'] as int;

      // Get pending applications
      final pendingApplicationsResult = await db.rawQuery('SELECT COUNT(*) as count FROM applications WHERE status = ?', ['pending']);
      final pendingApplications = pendingApplicationsResult.first['count'] as int;

      return {
        'totalUsers': totalUsers,
        'totalStudents': totalStudents,
        'totalEmployers': totalEmployers,
        'totalJobs': totalJobs,
        'activeJobs': activeJobs,
        'totalApplications': totalApplications,
        'pendingApplications': pendingApplications,
        'pendingReports': 0, // TODO: Implement when reports table is ready
      };
    } catch (e) {
      throw Exception('Failed to get dashboard statistics: $e');
    }
  }

  @override
  Future<List<UserModel>> getUsers({
    String? roleFilter,
    String? statusFilter,
  }) async {
    try {
      final db = await _db;
      String query = 'SELECT * FROM users WHERE deleted_at IS NULL';
      List<dynamic> args = [];

      // Apply role filter
      if (roleFilter != null && roleFilter != 'all') {
        query += ' AND account_type = ?';
        args.add(roleFilter);
      }

      // Apply status filter
      if (statusFilter != null && statusFilter != 'all') {
        if (statusFilter == 'active') {
          query += ' AND is_active = 1';
        } else if (statusFilter == 'suspended') {
          query += ' AND is_active = 0';
        }
      }

      query += ' ORDER BY created_at DESC';

      final results = await db.rawQuery(query, args);
      return results.map((map) => UserModel.fromJson(map)).toList();
    } catch (e) {
      throw Exception('Failed to get users: $e');
    }
  }

  @override
  Future<List<JobPost>> getJobs({String? statusFilter}) async {
    try {
      final db = await _db;
      String query = 'SELECT * FROM jobs WHERE deleted_at IS NULL';
      List<dynamic> args = [];

      // Apply status filter
      if (statusFilter != null && statusFilter != 'all') {
        if (statusFilter == 'active') {
          query += ' AND is_filled = 0 AND deadline >= datetime(\'now\')';
        } else if (statusFilter == 'filled') {
          query += ' AND is_filled = 1';
        } else if (statusFilter == 'expired') {
          query += ' AND deadline < datetime(\'now\') AND is_filled = 0';
        }
      }

      query += ' ORDER BY created_at DESC';

      final results = await db.rawQuery(query, args);
      return results.map((map) => JobPost.fromJson(map)).toList();
    } catch (e) {
      throw Exception('Failed to get jobs: $e');
    }
  }

  @override
  Future<UserModel> updateUserStatus(String userId, String status) async {
    try {
      final db = await _db;
      
      // Map status string to is_active value
      int isActive = 1;
      if (status == 'suspended' || status == 'inactive') {
        isActive = 0;
      }

      await db.update(
        'users',
        {
          'is_active': isActive,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [userId],
      );

      // Fetch and return updated user
      final results = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [userId],
      );

      if (results.isEmpty) {
        throw Exception('User not found');
      }

      return UserModel.fromJson(results.first);
    } catch (e) {
      throw Exception('Failed to update user status: $e');
    }
  }

  @override
  Future<void> deleteJob(String jobId) async {
    try {
      final db = await _db;
      
      // Soft delete - set deleted_at timestamp
      await db.update(
        'jobs',
        {
          'deleted_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [jobId],
      );
    } catch (e) {
      throw Exception('Failed to delete job: $e');
    }
  }

  @override
  Future<int> getUserCountByRole(String role) async {
    try {
      final db = await _db;
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM users WHERE account_type = ? AND deleted_at IS NULL',
        [role],
      );
      return result.first['count'] as int;
    } catch (e) {
      throw Exception('Failed to get user count: $e');
    }
  }

  @override
  Future<Map<String, int>> getJobStatistics() async {
    try {
      final db = await _db;

      final totalResult = await db.rawQuery('SELECT COUNT(*) as count FROM jobs WHERE deleted_at IS NULL');
      final activeResult = await db.rawQuery('''
        SELECT COUNT(*) as count FROM jobs 
        WHERE is_filled = 0 
        AND deadline >= datetime('now')
        AND deleted_at IS NULL
      ''');
      final filledResult = await db.rawQuery('SELECT COUNT(*) as count FROM jobs WHERE is_filled = 1 AND deleted_at IS NULL');

      return {
        'total': totalResult.first['count'] as int,
        'active': activeResult.first['count'] as int,
        'filled': filledResult.first['count'] as int,
      };
    } catch (e) {
      throw Exception('Failed to get job statistics: $e');
    }
  }

  @override
  Future<Map<String, int>> getApplicationStatistics() async {
    try {
      final db = await _db;

      final totalResult = await db.rawQuery('SELECT COUNT(*) as count FROM applications');
      final pendingResult = await db.rawQuery('SELECT COUNT(*) as count FROM applications WHERE status = ?', ['pending']);
      final acceptedResult = await db.rawQuery('SELECT COUNT(*) as count FROM applications WHERE status = ?', ['accepted']);
      final rejectedResult = await db.rawQuery('SELECT COUNT(*) as count FROM applications WHERE status = ?', ['rejected']);

      return {
        'total': totalResult.first['count'] as int,
        'pending': pendingResult.first['count'] as int,
        'accepted': acceptedResult.first['count'] as int,
        'rejected': rejectedResult.first['count'] as int,
      };
    } catch (e) {
      throw Exception('Failed to get application statistics: $e');
    }
  }
}
