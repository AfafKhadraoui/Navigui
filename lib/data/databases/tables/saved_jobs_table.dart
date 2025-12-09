import '../db_base_table.dart';
import 'package:sqflite/sqflite.dart';

class SavedJobsTable extends DBBaseTable {
  @override
  String get tableName => 'saved_jobs';

  /// Save a job for a student
  Future<void> saveJob(String studentId, String jobId) async {
    final db = await getDatabase();
    await db.insert(
      tableName,
      {
        'id': '${studentId}_$jobId',
        'student_id': studentId,
        'job_id': jobId,
        'created_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Remove a saved job
  Future<void> unsaveJob(String studentId, String jobId) async {
    final db = await getDatabase();
    await db.delete(
      tableName,
      where: 'student_id = ? AND job_id = ?',
      whereArgs: [studentId, jobId],
    );
  }

  /// Check if a job is saved by a student
  Future<bool> isJobSaved(String studentId, String jobId) async {
    final db = await getDatabase();
    final result = await db.query(
      tableName,
      where: 'student_id = ? AND job_id = ?',
      whereArgs: [studentId, jobId],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  /// Get all saved jobs for a student (with job details)
  Future<List<Map<String, dynamic>>> getSavedJobs(String studentId) async {
    final db = await getDatabase();
    return await db.rawQuery('''
      SELECT j.* FROM jobs j
      INNER JOIN saved_jobs sj ON j.id = sj.job_id
      WHERE sj.student_id = ?
      ORDER BY sj.created_at DESC
    ''', [studentId]);
  }
}
