import '../db_base_table.dart';

class StudentSkillsTable extends DbBaseTable {
  static const String tableName = 'student_skills';

  @override
  String get name => tableName;

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS $tableName (
      id TEXT PRIMARY KEY,
      student_id TEXT NOT NULL,
      skill_name TEXT NOT NULL,
      proficiency_level TEXT,
      created_at TEXT NOT NULL,
      FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE
    )
  ''';
}
