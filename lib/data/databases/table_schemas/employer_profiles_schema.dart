// lib/data/databases/table_schemas/employer_profiles_schema.dart

import 'package:sqflite/sqflite.dart';

class EmployerProfilesSchema {
  static const String tableName = 'employer_profiles';

  static Future<void> create(Database db) async {
    await db.execute('''
      CREATE TABLE $tableName (
        user_id TEXT PRIMARY KEY,
        business_name TEXT NOT NULL,
        business_type TEXT,
        industry TEXT,
        description TEXT,
        address TEXT,
        location TEXT,
        logo_url TEXT,
        website_url TEXT,
        is_verified INTEGER DEFAULT 0,
        verification_badge TEXT,
        verification_document_url TEXT,
        total_hires INTEGER DEFAULT 0,
        rating REAL DEFAULT 0.0,
        review_count INTEGER DEFAULT 0,
        active_jobs INTEGER DEFAULT 0,
        total_jobs_posted INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');
  }
}
