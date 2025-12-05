// lib/data/databases/table_schemas/student_skills_schema.dart

import 'package:sqflite/sqflite.dart';

class StudentSkillsSchema {
  static const String tableName = 'student_skills';

  static Future<void> create(Database db) async {
    // Create student_skills table
    await db.execute('''
      CREATE TABLE $tableName (
        id TEXT PRIMARY KEY,
        student_id TEXT NOT NULL,
        skill_name TEXT NOT NULL,
        proficiency_level TEXT CHECK(proficiency_level IN ('beginner', 'intermediate', 'advanced', 'expert')),
        years_of_experience INTEGER DEFAULT 0,
        is_certified INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');

    // Create index
    await db
        .execute('CREATE INDEX idx_student_skills ON $tableName(student_id)');
  }
}
