# Database Schema Architecture

## 📁 New Structure (Refactored)

```
lib/data/databases/
├── db_helper.dart                      # 80 lines - Database initialization
├── db_base_table.dart                  # Base CRUD operations
├── table_schemas/                      # ✨ NEW: Separate schema files
│   ├── users_schema.dart
│   ├── student_profiles_schema.dart
│   ├── employer_profiles_schema.dart
│   ├── jobs_schema.dart
│   ├── applications_schema.dart
│   ├── reviews_schema.dart
│   ├── notifications_schema.dart
│   ├── saved_jobs_schema.dart
│   ├── education_articles_schema.dart
│   ├── job_required_skills_schema.dart
│   ├── student_skills_schema.dart
│   └── reports_schema.dart
└── tables/                             # Table operation classes
    ├── users_table.dart
    ├── jobs_table.dart
    └── ... (business logic)
```

---

## 🎯 Benefits Achieved

### 1. **Maintainability** ✅

- Each schema is ~30-50 lines (was 450+ lines in one file)
- Easy to find and modify specific tables
- Clear separation between schema definition and business logic

### 2. **Team Collaboration** ✅

- Multiple developers can work on different tables simultaneously
- Fewer merge conflicts (each file is independent)
- Clear ownership: "I'll handle JobsSchema, you handle ApplicationsSchema"

### 3. **Testability** ✅

```dart
// Test individual table creation
test('Jobs schema creates correctly', () async {
  final db = await openDatabase(':memory:');
  await UsersSchema.create(db);  // Create dependency first
  await JobsSchema.create(db);    // Then test jobs

  final result = await db.query('jobs');
  expect(result, isEmpty);
});
```

### 4. **Migration Management** ✅

```dart
// Example: Adding a field to jobs table in version 2
class JobsSchema {
  static Future<void> create(Database db) async {
    // Initial schema
  }

  static Future<void> migrateToV2(Database db) async {
    await db.execute('ALTER TABLE jobs ADD COLUMN remote_work INTEGER DEFAULT 0');
  }

  static Future<void> migrateToV3(Database db) async {
    await db.execute('CREATE INDEX idx_jobs_remote ON jobs(remote_work)');
  }
}
```

### 5. **Scalability** ✅

- Add new tables without touching existing code
- Feature flags for gradual table rollout
- Easy to add/remove tables for A/B testing

---

## 📖 How to Use

### Adding a New Table

**Step 1: Create Schema File**

```dart
// lib/data/databases/table_schemas/messages_schema.dart
import 'package:sqflite/sqflite.dart';

class MessagesSchema {
  static const String tableName = 'messages';

  static Future<void> create(Database db) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id TEXT PRIMARY KEY,
        sender_id TEXT NOT NULL,
        receiver_id TEXT NOT NULL,
        content TEXT NOT NULL,
        is_read INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        FOREIGN KEY (sender_id) REFERENCES users(id),
        FOREIGN KEY (receiver_id) REFERENCES users(id)
      )
    ''');

    await db.execute('CREATE INDEX idx_messages_receiver ON $tableName(receiver_id)');
  }
}
```

**Step 2: Import in db_helper.dart**

```dart
import 'table_schemas/messages_schema.dart';
```

**Step 3: Add to \_onCreate**

```dart
static Future<void> _onCreate(Database db, int version) async {
  // ... existing tables ...
  await MessagesSchema.create(db);
}
```

**Done!** No need to touch any other files.

---

### Modifying an Existing Table

**Scenario:** Add `remote_work` field to jobs table in version 2

**Step 1: Add migration method to jobs_schema.dart**

```dart
class JobsSchema {
  // ... existing create() method ...

  static Future<void> migrateToV2(Database db) async {
    await db.execute('ALTER TABLE jobs ADD COLUMN remote_work INTEGER DEFAULT 0');
    await db.execute('CREATE INDEX idx_jobs_remote ON jobs(remote_work)');
  }
}
```

**Step 2: Update version and migration in db_helper.dart**

```dart
static const int _databaseVersion = 2;  // Increment version

static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
  if (oldVersion < 2) {
    await JobsSchema.migrateToV2(db);
  }
}
```

**Result:** All existing users get the new field automatically on app update.

---

## 🔍 Comparison: Before vs After

### Before (Monolithic)

```dart
// db_helper.dart - 450+ lines
static Future<void> _onCreate(Database db, int version) async {
  await db.execute('''CREATE TABLE users (...) ''');
  await db.execute('''CREATE TABLE student_profiles (...) ''');
  await db.execute('''CREATE TABLE employer_profiles (...) ''');
  await db.execute('''CREATE TABLE jobs (...) ''');
  // ... 300 more lines ...
}
```

**Problems:**

- ❌ Hard to navigate (scroll through 450 lines to find one table)
- ❌ Merge conflicts when multiple developers edit
- ❌ Can't test individual tables in isolation
- ❌ Migrations scattered throughout file

### After (Modular)

```dart
// db_helper.dart - 80 lines
static Future<void> _onCreate(Database db, int version) async {
  await UsersSchema.create(db);
  await StudentProfilesSchema.create(db);
  await EmployerProfilesSchema.create(db);
  await JobsSchema.create(db);
  // ... clean and readable
}

// jobs_schema.dart - 50 lines
class JobsSchema {
  static Future<void> create(Database db) async { /* ... */ }
  static Future<void> migrateToV2(Database db) async { /* ... */ }
}
```

**Benefits:**

- ✅ Easy to find (Ctrl+P → "jobs_schema")
- ✅ No merge conflicts (each file independent)
- ✅ Test each schema separately
- ✅ Migrations colocated with table definition

---

## 🚀 Migration Patterns

### Pattern 1: Add Column

```dart
static Future<void> migrateToV2(Database db) async {
  await db.execute('ALTER TABLE users ADD COLUMN two_factor_enabled INTEGER DEFAULT 0');
}
```

### Pattern 2: Create Index

```dart
static Future<void> migrateToV3(Database db) async {
  await db.execute('CREATE INDEX idx_users_email ON users(email)');
}
```

### Pattern 3: Modify Data

```dart
static Future<void> migrateToV4(Database db) async {
  // Update existing data
  await db.execute("UPDATE jobs SET status = 'active' WHERE status = 'open'");
}
```

### Pattern 4: Create Related Table

```dart
static Future<void> migrateToV5(Database db) async {
  await db.execute('''
    CREATE TABLE job_photos (
      id TEXT PRIMARY KEY,
      job_id TEXT NOT NULL,
      photo_url TEXT NOT NULL,
      FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE
    )
  ''');
}
```

---

## 📊 Testing Strategy

### Unit Test Individual Schemas

```dart
// test/databases/schemas/jobs_schema_test.dart
import 'package:test/test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late Database db;

  setUp(() async {
    sqfliteFfiInit();
    db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    await UsersSchema.create(db);  // Dependency
  });

  tearDown(() async {
    await db.close();
  });

  test('JobsSchema creates table correctly', () async {
    await JobsSchema.create(db);

    final tables = await db.query('sqlite_master', where: 'type = ?', whereArgs: ['table']);
    expect(tables.any((t) => t['name'] == 'jobs'), isTrue);
  });

  test('JobsSchema creates all indexes', () async {
    await JobsSchema.create(db);

    final indexes = await db.query('sqlite_master', where: 'type = ?', whereArgs: ['index']);
    expect(indexes.any((i) => i['name'] == 'idx_jobs_status_type'), isTrue);
    expect(indexes.any((i) => i['name'] == 'idx_jobs_is_urgent'), isTrue);
  });

  test('JobsSchema migration works', () async {
    await JobsSchema.create(db);
    await JobsSchema.migrateToV2(db);

    final columns = await db.rawQuery('PRAGMA table_info(jobs)');
    expect(columns.any((c) => c['name'] == 'remote_work'), isTrue);
  });
}
```

### Integration Test Full Database

```dart
test('Database initializes with all tables', () async {
  final db = await DBHelper.getDatabase();

  final tables = await db.query('sqlite_master', where: 'type = ?', whereArgs: ['table']);
  expect(tables.length, equals(12));  // All 12 tables
});
```

---

## 🎓 Best Practices

### ✅ DO

- Keep schema files small and focused (one table per file)
- Add migration methods to schema files (`migrateToV2`, `migrateToV3`)
- Document breaking changes in migration comments
- Test migrations on a copy of production data

### ❌ DON'T

- Don't put business logic in schema files (only CREATE/ALTER statements)
- Don't delete old migration methods (users might be on old versions)
- Don't modify existing migrations (create new ones instead)
- Don't forget to update version number when adding migrations

---

## 📝 Version History

**Version 1 (Current)**

- 12 tables: users, profiles, jobs, applications, reviews, etc.
- All indexes implemented
- Production-ready

**Version 2 (Future Example)**

- Add `remote_work` field to jobs
- Add `job_photos` table
- Add `two_factor_enabled` to users

---

## 🔧 Troubleshooting

### "Table already exists" error

**Cause:** Database wasn't deleted between runs  
**Solution:**

```dart
await DBHelper.deleteDB();  // Delete old database
await DBHelper.getDatabase();  // Create new one
```

### Migration not running

**Cause:** Version number not incremented  
**Solution:**

```dart
static const int _databaseVersion = 2;  // Increment this
```

### Foreign key constraint failed

**Cause:** Creating tables in wrong order  
**Solution:** Ensure parent tables are created first in `_onCreate`

```dart
await UsersSchema.create(db);      // Parent
await JobsSchema.create(db);        // Child (references users)
```

---

## 📞 Support

**Questions?** Check these files:

- `DATABASE_SCHEMA.md` - Full schema documentation
- `DATABASE_IMPLEMENTATION_NOTES.md` - Implementation details
- `db_helper.dart` - Database initialization code

**Need help with migrations?** See the migration patterns section above.

---

**Status:** ✅ Refactored and production-ready  
**Maintainer:** NavigUI Team  
**Last Updated:** December 5, 2025
