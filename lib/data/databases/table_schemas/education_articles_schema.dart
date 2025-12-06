// lib/data/databases/table_schemas/education_articles_schema.dart

import 'package:sqflite/sqflite.dart';

class EducationArticlesSchema {
  static const String tableName = 'education_articles';

  static Future<void> create(Database db) async {
    // Create education_articles table
    await db.execute('''
      CREATE TABLE $tableName (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        category_id TEXT NOT NULL,
        target_audience TEXT NOT NULL DEFAULT 'student',
        image_url TEXT,
        author TEXT,
        read_time INTEGER DEFAULT 5,
        views_count INTEGER DEFAULT 0,
        likes_count INTEGER DEFAULT 0,
        published_at TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        deleted_at TEXT
      )
    ''');

    // Create index
    await db.execute(
        'CREATE INDEX idx_articles_category ON $tableName(category_id)');
  }
}
