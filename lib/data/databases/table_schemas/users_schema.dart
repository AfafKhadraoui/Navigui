// lib/data/databases/table_schemas/users_schema.dart

import 'package:sqflite/sqflite.dart';

class UsersSchema {
  static const String tableName = 'users';

  static Future<void> create(Database db) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id TEXT PRIMARY KEY,
        email TEXT UNIQUE NOT NULL,
        password_hash TEXT NOT NULL,
        account_type TEXT NOT NULL CHECK(account_type IN ('student', 'employer', 'admin')),
        name TEXT NOT NULL,
        phone_number TEXT,
        location TEXT,
        profile_picture_url TEXT,
        is_email_verified INTEGER DEFAULT 0,
        is_active INTEGER DEFAULT 1,
        last_login_at TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        deleted_at TEXT
      )
    ''');
  }

  static Future<void> migrateToV2(Database db) async {
    // Example migration for future versions
    // await db.execute('ALTER TABLE $tableName ADD COLUMN new_field TEXT');
  }
}
