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
    student_name TEXT NOT NULL,
    job_title TEXT,
    applied_date INTEGER NOT NULL,       -- store as millisecondsSinceEpoch
    responded_date INTEGER,               -- store as millisecondsSinceEpoch
    status TEXT DEFAULT 'pending' CHECK(status IN ('pending', 'accepted', 'rejected')),
    email TEXT,
    phone TEXT,
    experience TEXT,
    cover_letter TEXT,
    skills TEXT,                          -- store as JSON string
    avatar TEXT,
    university TEXT,
    major TEXT,
    cv_attached INTEGER DEFAULT 0,        -- 0 = false, 1 = true
    cv_url TEXT,
    is_withdrawn INTEGER DEFAULT 0,       -- 0 = false, 1 = true
    FOREIGN KEY (job_id) REFERENCES job_posts(id) ON DELETE CASCADE,
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
