// lib/data/databases/table_schemas/job_required_skills_schema.dart

import 'package:sqflite/sqflite.dart';

class JobRequiredSkillsSchema {
  static const String tableName = 'job_required_skills';

  static Future<void> create(Database db) async {
    // Create job_required_skills table
    await db.execute('''
      CREATE TABLE $tableName (
        id TEXT PRIMARY KEY,
        job_id TEXT NOT NULL,
        skill_id TEXT NOT NULL,
        is_required INTEGER DEFAULT 1,
        proficiency_level TEXT CHECK(proficiency_level IN ('beginner', 'intermediate', 'advanced', 'expert')),
        created_at TEXT NOT NULL,
        UNIQUE(job_id, skill_id),
        FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE
      )
    ''');
  }
}
