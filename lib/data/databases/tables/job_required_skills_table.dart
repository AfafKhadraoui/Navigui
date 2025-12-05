import '../db_base_table.dart';

class JobRequiredSkillsTable extends DbBaseTable {
  static const String tableName = 'job_required_skills';

  @override
  String get name => tableName;

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS $tableName (
      id TEXT PRIMARY KEY,
      job_id TEXT NOT NULL,
      skill_id TEXT NOT NULL,
      is_required INTEGER DEFAULT 1,
      proficiency_level TEXT,
      created_at TEXT NOT NULL,
      FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE,
      UNIQUE(job_id, skill_id)
    )
  ''';
}
