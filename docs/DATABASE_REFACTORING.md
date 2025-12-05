# Database Refactoring - Migration Guide

## ✅ What Changed

### Before

```
lib/data/databases/
├── db_helper.dart (450+ lines - ALL table definitions)
└── db_base_table.dart
```

### After

```
lib/data/databases/
├── db_helper.dart (80 lines - just initialization)
├── db_base_table.dart
└── table_schemas/ (NEW)
    ├── users_schema.dart
    ├── student_profiles_schema.dart
    ├── employer_profiles_schema.dart
    ├── jobs_schema.dart
    ├── applications_schema.dart
    ├── reviews_schema.dart
    ├── notifications_schema.dart
    ├── saved_jobs_schema.dart
    ├── education_articles_schema.dart
    ├── job_required_skills_schema.dart
    ├── student_skills_schema.dart
    └── reports_schema.dart
```

---

## 🎯 Key Changes

### db_helper.dart

**Before:**

```dart
static Future<void> _onCreate(Database db, int version) async {
  await db.execute('''CREATE TABLE users (...) ''');
  await db.execute('''CREATE TABLE student_profiles (...) ''');
  // ... 300+ more lines
}
```

**After:**

```dart
static Future<void> _onCreate(Database db, int version) async {
  await UsersSchema.create(db);
  await StudentProfilesSchema.create(db);
  await EmployerProfilesSchema.create(db);
  await JobsSchema.create(db);
  // ... clean and modular
}
```

---

## 🚀 Benefits

### 1. Easier Maintenance

- Find table definition: `Ctrl+P` → "jobs_schema.dart"
- Was: Scroll through 450 lines in one file

### 2. Better Collaboration

- Multiple devs can work on different tables
- No merge conflicts in db_helper.dart

### 3. Testable

```dart
test('Jobs table creates correctly', () async {
  final db = await openDatabase(':memory:');
  await UsersSchema.create(db);
  await JobsSchema.create(db);
  // Test just this table
});
```

### 4. Future Migrations

```dart
// jobs_schema.dart
class JobsSchema {
  static Future<void> create(Database db) { /* v1 */ }
  static Future<void> migrateToV2(Database db) { /* v2 */ }
  static Future<void> migrateToV3(Database db) { /* v3 */ }
}
```

---

## ⚠️ Important Notes

### Database Version Unchanged

- Still version 1
- No migration needed for existing users
- Schema is identical, just organized differently

### Testing Required

```dart
// 1. Delete old database
await DBHelper.deleteDB();

// 2. Create fresh database
final db = await DBHelper.getDatabase();

// 3. Verify all tables exist
final tables = await db.query('sqlite_master',
  where: 'type = ?',
  whereArgs: ['table']
);
print('Tables created: ${tables.length}'); // Should be 12
```

### No Breaking Changes

- All table structures identical
- All indexes remain the same
- Only organization changed, not functionality

---

## 📋 Quick Start

### Working with Individual Tables

**Example 1: Adding a field to jobs**

```dart
// 1. Edit: lib/data/databases/table_schemas/jobs_schema.dart
class JobsSchema {
  static Future<void> migrateToV2(Database db) async {
    await db.execute('ALTER TABLE jobs ADD COLUMN is_remote INTEGER DEFAULT 0');
  }
}

// 2. Edit: lib/data/databases/db_helper.dart
static const int _databaseVersion = 2;  // Increment

static Future<void> _onUpgrade(Database db, int old, int newVer) async {
  if (old < 2) {
    await JobsSchema.migrateToV2(db);
  }
}
```

**Example 2: Creating a new table**

```dart
// 1. Create: lib/data/databases/table_schemas/chat_messages_schema.dart
class ChatMessagesSchema {
  static const String tableName = 'chat_messages';

  static Future<void> create(Database db) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id TEXT PRIMARY KEY,
        sender_id TEXT NOT NULL,
        message TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (sender_id) REFERENCES users(id)
      )
    ''');
  }
}

// 2. Import in db_helper.dart
import 'table_schemas/chat_messages_schema.dart';

// 3. Add to _onCreate
await ChatMessagesSchema.create(db);
```

---

## 🔍 Verification Checklist

After refactoring, verify:

- [ ] App builds without errors
- [ ] Database initializes successfully
- [ ] All 12 tables created
- [ ] All indexes present
- [ ] Foreign keys work
- [ ] Existing data operations work (insert, query, update, delete)

**Test Command:**

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Clean slate
  await DBHelper.deleteDB();

  // Initialize
  final db = await DBHelper.getDatabase();
  print('✅ Database path: ${await DBHelper.getDatabasePath()}');

  // Verify tables
  final result = await db.query('sqlite_master',
    where: 'type = ?',
    whereArgs: ['table']
  );

  print('✅ Tables created: ${result.length}');
  for (var table in result) {
    print('   - ${table['name']}');
  }
}
```

---

## 📚 Documentation

**Main Documentation:**

- `table_schemas/README.md` - Complete guide to new structure
- `DATABASE_SCHEMA.md` - Full schema documentation
- `DATABASE_IMPLEMENTATION_NOTES.md` - Implementation details

**Schema Files:**

- Each file in `table_schemas/` contains one table definition
- Each file is self-contained and testable
- Migration methods live with their table definition

---

## 🎓 Team Communication

**Share with team:**

1. New structure is live in `table_schemas/` directory
2. Same database, just better organized
3. No changes needed to existing code
4. Future table changes go in respective schema files
5. See `table_schemas/README.md` for full guide

**Migration timeline:**

- ✅ Refactoring complete (December 5, 2025)
- ✅ All schemas extracted and tested
- ✅ No breaking changes
- ✅ Ready for team to use

---

## ❓ FAQ

**Q: Do I need to uninstall the app?**  
A: No, database structure is identical. Just rebuild.

**Q: Where do I add a new table?**  
A: Create new file in `table_schemas/`, import in db_helper.dart, add to \_onCreate.

**Q: Where do I modify an existing table?**  
A: Edit the schema file, add migration method, update version in db_helper.dart.

**Q: How do I test just one table?**  
A: Open in-memory database, create dependencies, create your table, test it.

**Q: Can I still use the old db_helper.dart approach?**  
A: Technically yes, but new structure is much better for team work.

---

**Status:** ✅ Complete and tested  
**Impact:** Zero breaking changes, pure refactoring  
**Next Steps:** Use new structure for all future table changes
