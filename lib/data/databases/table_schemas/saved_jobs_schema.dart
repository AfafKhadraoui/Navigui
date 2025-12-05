// lib/data/databases/table_schemas/saved_jobs_schema.dart

import 'package:sqflite/sqflite.dart';

class SavedJobsSchema {
  static const String tableName = 'saved_jobs';

  static Future<void> create(Database db) async {
    // Create saved_jobs table
    await db.execute('''
      CREATE TABLE $tableName (
        id TEXT PRIMARY KEY,
        student_id TEXT NOT NULL,
        job_id TEXT NOT NULL,
        created_at TEXT NOT NULL,
        UNIQUE(student_id, job_id),
        FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE
      )
    ''');

    // Create index
    await db.execute(
        'CREATE INDEX idx_saved_jobs_student ON $tableName(student_id)');
  }
}
