// lib/data/databases/table_schemas/student_profiles_schema.dart

import 'package:sqflite/sqflite.dart';

class StudentProfilesSchema {
  static const String tableName = 'student_profiles';

  static Future<void> create(Database db) async {
    await db.execute('''
      CREATE TABLE $tableName (
        user_id TEXT PRIMARY KEY,
        university TEXT,
        faculty TEXT,
        major TEXT,
        year_of_study INTEGER,
        bio TEXT,
        cv_url TEXT,
        availability TEXT,
        transportation TEXT,
        previous_experience TEXT,
        website_url TEXT,
        is_phone_public INTEGER DEFAULT 0,
        profile_visibility TEXT DEFAULT 'public' CHECK(profile_visibility IN ('public', 'private', 'connections_only')),
        rating REAL DEFAULT 0.0,
        review_count INTEGER DEFAULT 0,
        jobs_completed INTEGER DEFAULT 0,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');
  }
}
