import '../db_base_table.dart';

class SavedJobsTable extends DbBaseTable {
  static const String tableName = 'saved_jobs';

  @override
  String get name => tableName;

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS $tableName (
      id TEXT PRIMARY KEY,
      student_id TEXT NOT NULL,
      job_id TEXT NOT NULL,
      created_at TEXT NOT NULL,
      FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
      FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE,
      UNIQUE(student_id, job_id)
    )
  ''';
}
