# 🎯 IMMEDIATE ACTION PLAN - Job Model Database Alignment

## 📌 Quick Summary

**Status:** ❌ **Model DOES NOT match database schema**  
**Severity:** 🔴 **CRITICAL** - Must fix before SQLite integration  
**Estimated Fix Time:** 12-15 hours  
**Files Created:**

- ✅ `lib/data/models/job_post_corrected.dart` - Production-ready corrected model
- ✅ `docs/JOB_MODEL_MIGRATION_GUIDE.md` - Detailed migration instructions
- ✅ `docs/JOB_MODEL_COMPARISON.md` - Side-by-side comparison

---

## 🚨 3 CRITICAL ISSUES (Fix Immediately)

### Issue #1: Category Must Be String, Not Enum

**Current:** `final JobCategory category;` (enum with 15 hardcoded values)  
**Required:** `final String category;` (flexible string)  
**Why:** Database flexibility - categories should be configurable without code changes

**One-Line Fix:**

```dart
- final JobCategory category;
+ final String category;
```

**Ripple Effects:**

- Update all `job.category.name` → `job.category`
- Update all `job.category.label` → `job.category`
- Update form dropdowns to use String values
- ~15 files to update

---

### Issue #2: Missing requirements Field

**Current:** Field doesn't exist in model  
**Database:** `requirements TEXT NULL`  
**Impact:** Cannot store/retrieve job requirements

**One-Line Fix:**

```dart
+ final String? requirements;
```

**Also Update:**

- Constructor
- toMap()
- fromMap()
- toJson()
- fromJson()
- copyWith()

---

### Issue #3: Missing toMap/fromMap Methods

**Current:** Only has toJson/fromJson (wrong for SQLite)  
**Required:** toMap/fromMap with snake_case keys and proper type conversions

**Why Critical:**

- SQLite uses snake_case: `employer_id`, not `employerId`
- SQLite booleans are INTEGER (0/1), not bool
- SQLite timestamps are epoch ms, not ISO strings

**Fix:** Add these two methods (see corrected model)

---

## ⚡ FASTEST PATH TO FIX

### Option A: Replace Entire Model (RECOMMENDED)

**Time:** 30 minutes + 2 hours testing  
**Steps:**

1. Backup current `job_post.dart`
2. Copy contents from `job_post_corrected.dart`
3. Paste into `job_post.dart`
4. Run `flutter pub run build_runner build` if using code generation
5. Fix compilation errors (mostly category-related)
6. Test thoroughly

**Pros:**

- All fixes applied at once
- Guaranteed database compatibility
- Production-ready code

**Cons:**

- More initial compilation errors
- Need to update calling code

---

### Option B: Manual Incremental Fixes

**Time:** 4-6 hours  
**Steps:**

1. Add requirements field (30 min)
2. Change category from enum to String (2 hours)
3. Add toMap/fromMap methods (1 hour)
4. Add expired to JobStatus enum (5 min)
5. Test each change incrementally (1 hour)

**Pros:**

- Smaller changes, easier to review
- Can commit after each fix

**Cons:**

- Takes longer
- More chances for errors
- Multiple rounds of testing

---

## 📋 Step-by-Step Migration (Recommended Path)

### Step 1: Prepare (15 min)

```bash
# Create backup branch
git checkout -b feature/fix-job-model-database-alignment

# Backup current model
cp lib/data/models/job_post.dart lib/data/models/job_post_backup.dart

# Open corrected model for reference
code lib/data/models/job_post_corrected.dart
```

### Step 2: Apply Model Changes (30 min)

**Replace these sections in `job_post.dart`:**

```dart
// 1. Change category field
- final JobCategory category;
+ final String category;

// 2. Add requirements field (after description)
+ final String? requirements;

// 3. Add toMap method (after toJson)
+ Map<String, dynamic> toMap() {
+   // See corrected model for full implementation
+ }

// 4. Add fromMap method (after fromJson)
+ static JobPost fromMap(Map<String, dynamic> map) {
+   // See corrected model for full implementation
+ }

// 5. Update JobStatus enum
enum JobStatus {
  draft('Draft', 'draft'),
  active('Active', 'active'),
  filled('Filled', 'filled'),
  closed('Closed', 'closed'),
+ expired('Expired', 'expired'); // ADD THIS
```

### Step 3: Fix Compilation Errors (1-2 hours)

**Use IDE Find & Replace:**

```
Find: job.category.name
Replace: job.category

Find: job.category.label
Replace: job.category

Find: JobCategory\s+category
Replace: String category
```

**Common places to update:**

- `lib/views/screens/jobs/` - Job display screens
- `lib/views/screens/employer/` - Employer job management
- `lib/views/widgets/` - Job card widgets
- `lib/data/repositories/` - Repository CRUD operations
- `lib/mock/mock_data.dart` - Mock data

### Step 4: Update Repository (1 hour)

**In `lib/data/repositories/job_repo.dart`:**

```dart
// Update insert/update operations
- await db.insert('jobs', job.toJson());
+ await db.insert('jobs', job.toMap());

// Update select operations
- return JobPost.fromJson(map);
+ return JobPost.fromMap(map);
```

### Step 5: Update Forms (1 hour)

**Job creation/edit forms:**

```dart
// Before - category dropdown
DropdownButton<JobCategory>(
  value: _selectedCategory,
  items: JobCategory.values.map((cat) =>
    DropdownMenuItem(value: cat, child: Text(cat.label))
  ).toList(),
  onChanged: (val) => setState(() => _selectedCategory = val),
)

// After - category dropdown
DropdownButton<String>(
  value: _selectedCategory,
  items: ['Photography', 'Translation', 'Graphic Design', ...].map((cat) =>
    DropdownMenuItem(value: cat, child: Text(cat))
  ).toList(),
  onChanged: (val) => setState(() => _selectedCategory = val),
)
```

### Step 6: Test Everything (2 hours)

```dart
// Test script
void testJobModel() async {
  // 1. Create job
  final job = JobPost(
    id: 'test-1',
    employerId: 'emp-1',
    title: 'Test Job',
    description: 'Description',
    category: 'Photography', // String now!
    requirements: 'Must have camera', // New field!
    pay: 5000.0,
    jobType: JobType.partTime,
    createdDate: DateTime.now(),
  );

  // 2. Test toMap
  final map = job.toMap();
  assert(map['category'] == 'Photography');
  assert(map['employer_id'] == 'emp-1'); // snake_case
  assert(map['is_urgent'] == 0); // INTEGER

  // 3. Test fromMap
  final job2 = JobPost.fromMap(map);
  assert(job2.category == 'Photography');
  assert(job2.employerId == 'emp-1');

  // 4. Test SQLite insert
  await db.insert('jobs', job.toMap());

  // 5. Test SQLite select
  final result = await db.query('jobs', where: 'id = ?', whereArgs: ['test-1']);
  final job3 = JobPost.fromMap(result.first);
  assert(job3.title == 'Test Job');

  print('✅ All tests passed!');
}
```

### Step 7: Deploy (30 min)

```bash
# Commit changes
git add .
git commit -m "Fix: Align Job model with database schema

- Changed category from enum to String for flexibility
- Added missing requirements field
- Added toMap/fromMap methods for SQLite compatibility
- Added expired status to JobStatus enum
- Updated all usages of category field
- Updated repository to use toMap/fromMap

Fixes critical database compatibility issues."

# Create PR
git push origin feature/fix-job-model-database-alignment

# After review and approval
git checkout main
git merge feature/fix-job-model-database-alignment
git push origin main
```

---

## 🧪 Validation Checklist

Before considering the migration complete:

### Database Operations

- [ ] Can insert new job using `job.toMap()`
- [ ] Can read job using `JobPost.fromMap()`
- [ ] Can update existing job
- [ ] Can delete job (soft delete sets deleted_at)
- [ ] All columns save correctly
- [ ] All columns read correctly

### Category Field

- [ ] Category saves as String
- [ ] Category displays in UI
- [ ] Can add new categories without code changes
- [ ] Dropdown works with String values
- [ ] Search/filter by category works

### Requirements Field

- [ ] Requirements text saves to database
- [ ] Requirements displays in job details
- [ ] Form has requirements input field
- [ ] Nullable requirements handled (can be empty)

### Type Conversions

- [ ] Booleans convert to 0/1
- [ ] DateTime converts to epoch ms
- [ ] Enums convert to db_value strings
- [ ] Null values handled properly

### UI & Forms

- [ ] Job list displays correctly
- [ ] Job details show all fields
- [ ] Create job form works
- [ ] Edit job form works
- [ ] Category dropdown works
- [ ] No compilation errors

---

## 🎬 Quick Start Command

**To apply the fix right now:**

```bash
# 1. Copy corrected model
cp lib/data/models/job_post_corrected.dart lib/data/models/job_post.dart

# 2. Fix category references (semi-automated)
# Use your IDE's "Find in Files" feature:
# Find: "job.category.name" → Replace: "job.category"
# Find: "job.category.label" → Replace: "job.category"

# 3. Run to see remaining errors
flutter analyze

# 4. Fix remaining compilation errors manually
# (Mostly in form dropdowns and mock data)

# 5. Test
flutter test
flutter run
```

---

## 📞 Questions to Consider

Before you start, decide:

1. **Keep toJson/fromJson?**

   - YES - Keep both, use toMap for SQLite, toJson for API
   - NO - Replace with toMap/fromMap only

2. **Remove extra fields?**

   - company (not in database)
   - salary (display string)
   - payment (redundant object)

3. **Category values?**

   - Hardcode list in UI?
   - Load from database?
   - Use constants file?

4. **Supporting tables now?**
   - Implement photo/language helpers?
   - Or defer until later?

---

## 📚 Reference Documents

- **Full corrected model:** `lib/data/models/job_post_corrected.dart`
- **Detailed migration guide:** `docs/JOB_MODEL_MIGRATION_GUIDE.md`
- **Side-by-side comparison:** `docs/JOB_MODEL_COMPARISON.md`
- **Database schema:** `docs/DATABASE_SCHEMA.md`

---

## ✅ Success Indicators

Migration is successful when:

1. ✅ Zero compilation errors
2. ✅ All tests pass
3. ✅ Can insert job to SQLite
4. ✅ Can read job from SQLite
5. ✅ Category is String type
6. ✅ Requirements field populated
7. ✅ UI displays jobs correctly
8. ✅ Forms create/edit jobs correctly

---

## 🎉 Final Notes

**The corrected model is production-ready!**  
All you need to do is:

1. Replace your current model with the corrected one
2. Update code that uses `job.category.name` → `job.category`
3. Test thoroughly

**Estimated time from start to finish:** 4-6 hours with testing

Good luck! 🚀
