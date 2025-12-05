// lib/data/databases/table_schemas/reports_schema.dart

import 'package:sqflite/sqflite.dart';

class ReportsSchema {
  static const String tableName = 'reports';

  static Future<void> create(Database db) async {
    // Create reports table (content moderation)
    await db.execute('''
      CREATE TABLE $tableName (
        id TEXT PRIMARY KEY,
        reporter_id TEXT NOT NULL,
        content_type TEXT NOT NULL CHECK(content_type IN ('job', 'user', 'review')),
        content_id TEXT NOT NULL,
        reason TEXT NOT NULL CHECK(reason IN ('spam', 'inappropriate', 'fraud', 'harassment', 'other')),
        description TEXT,
        status TEXT DEFAULT 'pending' CHECK(status IN ('pending', 'reviewing', 'resolved', 'dismissed')),
        reviewed_by TEXT,
        resolved_at TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (reporter_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');

    // Create indexes
    await db.execute('CREATE INDEX idx_reports_status ON $tableName(status)');
    await db.execute(
        'CREATE INDEX idx_reports_content ON $tableName(content_type, content_id)');
  }
}
