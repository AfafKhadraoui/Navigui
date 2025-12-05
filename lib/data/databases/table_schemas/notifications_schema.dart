// lib/data/databases/table_schemas/notifications_schema.dart

import 'package:sqflite/sqflite.dart';

class NotificationsSchema {
  static const String tableName = 'notifications';

  static Future<void> create(Database db) async {
    // Create notifications table
    await db.execute('''
      CREATE TABLE $tableName (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        title TEXT NOT NULL,
        message TEXT NOT NULL,
        type TEXT NOT NULL,
        related_id TEXT,
        related_type TEXT,
        action_url TEXT,
        priority TEXT DEFAULT 'medium' CHECK(priority IN ('low', 'medium', 'high', 'urgent')),
        is_read INTEGER DEFAULT 0,
        is_pushed INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');

    // Create indexes
    await db
        .execute('CREATE INDEX idx_notifications_user ON $tableName(user_id)');
    await db
        .execute('CREATE INDEX idx_notifications_read ON $tableName(is_read)');
  }
}
