import '../db_base_table.dart';

class ReportsTable extends DbBaseTable {
  static const String tableName = 'reports';

  @override
  String get name => tableName;

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS $tableName (
      id TEXT PRIMARY KEY,
      reporter_id TEXT NOT NULL,
      content_type TEXT NOT NULL,
      content_id TEXT NOT NULL,
      reason TEXT NOT NULL,
      description TEXT,
      status TEXT DEFAULT 'pending',
      reviewed_by TEXT,
      resolved_at TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (reporter_id) REFERENCES users(id) ON DELETE CASCADE
    )
  ''';
}
