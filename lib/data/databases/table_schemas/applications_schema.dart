// lib/data/databases/table_schemas/applications_schema.dart

import 'package:sqflite/sqflite.dart';

class ApplicationsSchema {
  static const String tableName = 'applications';

  static Future<void> create(Database db) async {
    // Create applications table
    await db.execute('''
      CREATE TABLE $tableName (
        id TEXT PRIMARY KEY,
        job_id TEXT NOT NULL,
        student_id TEXT NOT NULL,
        cover_message TEXT,
        cv_url TEXT,
        portfolio_url TEXT,
        availability_confirmation INTEGER DEFAULT 1,
        status TEXT DEFAULT 'pending' CHECK(status IN ('pending', 'accepted', 'rejected', 'withdrawn', 'interviewing', 'offered')),
        is_withdrawn INTEGER DEFAULT 0,
        is_latest INTEGER DEFAULT 1,
        employer_note TEXT,
        applied_at TEXT NOT NULL,
        responded_at TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE,
        FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');

    // Create indexes
    await db.execute('CREATE INDEX idx_applications_job ON $tableName(job_id)');
    await db.execute(
        'CREATE INDEX idx_applications_student ON $tableName(student_id)');
    await db
        .execute('CREATE INDEX idx_applications_status ON $tableName(status)');
  }
}
