// lib/data/databases/table_schemas/jobs_schema.dart

import 'package:sqflite/sqflite.dart';

class JobsSchema {
  static const String tableName = 'jobs';

  static Future<void> create(Database db) async {
    // Create jobs table
    await db.execute('''
      CREATE TABLE $tableName (
        id TEXT PRIMARY KEY,
        employer_id TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        brief_description TEXT,
        category TEXT NOT NULL CHECK(category IN (
          'photography', 'translation', 'graphic_design', 'video_editing',
          'writing', 'social_media', 'web_development', 'mobile_development', 'tutoring',
          'event_planning', 'delivery', 'customer_service', 'data_entry',
          'marketing', 'sales', 'other'
        )),
        job_type TEXT NOT NULL CHECK(job_type IN ('part_time', 'task')),
        requirements TEXT,
        pay REAL NOT NULL,
        payment_type TEXT CHECK(payment_type IN ('hourly', 'daily', 'weekly', 'monthly', 'per_task')),
        time_commitment TEXT,
        duration TEXT,
        start_date TEXT,
        is_recurring INTEGER DEFAULT 0,
        number_of_positions INTEGER DEFAULT 1,
        location TEXT,
        contact_preference TEXT CHECK(contact_preference IN ('phone', 'email', 'whatsapp')),
        deadline TEXT,
        is_urgent INTEGER DEFAULT 0,
        requires_cv INTEGER DEFAULT 0,
        is_draft INTEGER DEFAULT 0,
        status TEXT DEFAULT 'draft' CHECK(status IN ('draft', 'active', 'filled', 'closed', 'expired')),
        applicants_count INTEGER DEFAULT 0,
        views_count INTEGER DEFAULT 0,
        saves_count INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        deleted_at TEXT,
        FOREIGN KEY (employer_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');

    // Create indexes for performance
    await db.execute(
        'CREATE INDEX idx_jobs_status_type ON $tableName(status, job_type)');
    await db
        .execute('CREATE INDEX idx_jobs_is_urgent ON $tableName(is_urgent)');
    await db.execute(
        'CREATE INDEX idx_jobs_location_status ON $tableName(location, status)');
    await db.execute(
        'CREATE INDEX idx_jobs_status_category ON $tableName(status, category)');
    await db
        .execute('CREATE INDEX idx_jobs_employer ON $tableName(employer_id)');
  }
}
