import '../db_base_table.dart';
import 'dart:convert';

/// Database table for applications
class ApplicationsTable extends DBBaseTable {
  @override
  String get tableName => 'applications';

  /// Get all applications for a specific job
  Future<List<Map<String, dynamic>>> getJobApplications(
    String jobId, {
    String? statusFilter,
  }) async {
    try {
      final db = await getDatabase();
      String where = 'job_id = ?';
      List<dynamic> whereArgs = [jobId];

      if (statusFilter != null) {
        where += ' AND status = ?';
        whereArgs.add(statusFilter);
      }

      final records = await db.query(
        tableName,
        where: where,
        whereArgs: whereArgs,
        orderBy: 'applied_date DESC',
      );

      return records;
    } catch (e) {
      print('Error fetching job applications: $e');
      return [];
    }
  }

  /// Get all applications for a specific student
  Future<List<Map<String, dynamic>>> getStudentApplications(
    String studentId, {
    String? statusFilter,
  }) async {
    try {
      final db = await getDatabase();
      String where = 'student_id = ?';
      List<dynamic> whereArgs = [studentId];

      if (statusFilter != null) {
        where += ' AND status = ?';
        whereArgs.add(statusFilter);
      }

      final records = await db.query(
        tableName,
        where: where,
        whereArgs: whereArgs,
        orderBy: 'applied_date DESC',
      );

      return records;
    } catch (e) {
      print('Error fetching student applications: $e');
      return [];
    }
  }

  /// Get a single application by ID
  Future<Map<String, dynamic>?> getApplicationById(String id) async {
    try {
      final db = await getDatabase();
      final records = await db.query(
        tableName,
        where: 'id = ?',
        whereArgs: [id],
      );

      return records.isNotEmpty ? records.first : null;
    } catch (e) {
      print('Error fetching application: $e');
      return null;
    }
  }

  /// Insert a new application
  Future<int> insertApplication(Map<String, dynamic> application) async {
    try {
      final db = await getDatabase();
      return await db.insert(tableName, application);
    } catch (e) {
      print('Error inserting application: $e');
      rethrow;
    }
  }

  /// Update application status
  Future<int> updateApplicationStatus(
    String applicationId,
    String status,
  ) async {
    try {
      final db = await getDatabase();
      return await db.update(
        tableName,
        {
          'status': status,
          'responded_date': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [applicationId],
      );
    } catch (e) {
      print('Error updating application status: $e');
      rethrow;
    }
  }

  /// Check if student has applied for a job
  Future<bool> hasApplied(String jobId, String studentId) async {
    try {
      final db = await getDatabase();
      final records = await db.query(
        tableName,
        where: 'job_id = ? AND student_id = ? AND is_withdrawn = 0',
        whereArgs: [jobId, studentId],
      );

      return records.isNotEmpty;
    } catch (e) {
      print('Error checking application: $e');
      return false;
    }
  }

  /// Withdraw an application
  Future<int> withdrawApplication(String applicationId) async {
    try {
      final db = await getDatabase();
      return await db.update(
        tableName,
        {
          'is_withdrawn': 1,
          'status': 'rejected', // Mark as rejected when withdrawn
        },
        where: 'id = ?',
        whereArgs: [applicationId],
      );
    } catch (e) {
      print('Error withdrawing application: $e');
      rethrow;
    }
  }

  /// Delete an application
  Future<int> deleteApplication(String applicationId) async {
    try {
      final db = await getDatabase();
      return await db.delete(
        tableName,
        where: 'id = ?',
        whereArgs: [applicationId],
      );
    } catch (e) {
      print('Error deleting application: $e');
      rethrow;
    }
  }

  /// Get filter options available for a job's applications
  Future<Map<String, int>> getApplicationStatistics(String jobId) async {
    try {
      final db = await getDatabase();
      final records = await db.rawQuery(
        'SELECT status, COUNT(*) as count FROM $tableName WHERE job_id = ? GROUP BY status',
        [jobId],
      );

      final stats = <String, int>{};
      for (final record in records) {
        final status = record['status'] as String;
        final count = record['count'] as int;
        stats[status] = count;
      }

      return stats;
    } catch (e) {
      print('Error fetching application statistics: $e');
      return {};
    }
  }
}
