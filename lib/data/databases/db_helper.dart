// lib/data/databases/db_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Import all table schemas
import 'table_schemas/users_schema.dart';
import 'table_schemas/student_profiles_schema.dart';
import 'table_schemas/employer_profiles_schema.dart';
import 'table_schemas/jobs_schema.dart';
import 'table_schemas/applications_schema.dart';
import 'table_schemas/reviews_schema.dart';
import 'table_schemas/notifications_schema.dart';
import 'table_schemas/saved_jobs_schema.dart';
import 'table_schemas/education_articles_schema.dart';
import 'table_schemas/job_required_skills_schema.dart';
import 'table_schemas/student_skills_schema.dart';
import 'table_schemas/reports_schema.dart';
import 'seed_data.dart';

class DBHelper {
  static Database? _database;
  static const String _databaseName = 'navigui.db';
  static const int _databaseVersion = 1;

  // Singleton pattern
  DBHelper._();
  static final DBHelper instance = DBHelper._();

  // Get database instance
  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize database
  static Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Create all tables using separate schema files
  static Future<void> _onCreate(Database db, int version) async {
    // Create tables in order (respecting foreign key dependencies)
    await UsersSchema.create(db);
    await StudentProfilesSchema.create(db);
    await EmployerProfilesSchema.create(db);
    await JobsSchema.create(db);
    await ApplicationsSchema.create(db);
    await ReviewsSchema.create(db);
    await NotificationsSchema.create(db);
    await SavedJobsSchema.create(db);
    await EducationArticlesSchema.create(db);
    await JobRequiredSkillsSchema.create(db);
    await StudentSkillsSchema.create(db);
    await ReportsSchema.create(db);

    print('Database initialized with 12 tables');

    // Seed with dummy data
    await DatabaseSeeder.seedDatabase(db);
  }

  // Handle database upgrades (version-specific migrations)
  static Future<void> _onUpgrade(
      Database db, int oldVersion, int newVersion) async {
    print('Database upgrade from v$oldVersion to v$newVersion');

    // Example migration structure:
    // if (oldVersion < 2) {
    //   await JobsSchema.migrateToV2(db);
    // }
    // if (oldVersion < 3) {
    //   await UsersSchema.migrateToV3(db);
    // }
  }

  // Close database
  static Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  // Delete database (for testing)
  static Future<void> deleteDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);
    await deleteDatabase(path);
    _database = null;
    print('Database deleted');
  }

  // Get database path (for debugging)
  static Future<String> getDatabasePath() async {
    final databasePath = await getDatabasesPath();
    return join(databasePath, _databaseName);
  }
}
