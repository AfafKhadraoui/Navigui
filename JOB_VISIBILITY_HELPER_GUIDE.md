# Job Visibility Helper - Implementation Guide

## Overview
The `JobVisibilityHelper` class provides a centralized way to determine which job posts should be visible to students based on their application and save status.

**File Location**: `lib/utils/job_visibility_helper.dart`

## Core Concept

### Three Visibility Rules

#### Rule 1: Draft Posts Never Show
```dart
if (post.isDraft) → Hidden
```

#### Rule 2: Active Posts Always Show
```dart
if (post.status == active && !post.isDraft) → Visible
```

#### Rule 3: Closed Posts Show Only to Interested Students
```dart
if (post.status == closed && !post.isDraft) {
  if (student.hasApplied || student.hasSaved) → Visible
  else → Hidden
}
```

## API Reference

### 1. isVisibleToStudent()
Checks if a single job post should be visible to a student.

```dart
bool isVisibleToStudent({
  required JobPost jobPost,
  bool hasApplied = false,
  bool hasSaved = false,
})
```

**Parameters**:
- `jobPost`: The job posting to check
- `hasApplied`: Whether the student has applied to this job (default: false)
- `hasSaved`: Whether the student has saved this job (default: false)

**Returns**: `true` if visible, `false` if hidden

**Example**:
```dart
final job = JobPost(...);
final isVisible = JobVisibilityHelper.isVisibleToStudent(
  jobPost: job,
  hasApplied: true,
  hasSaved: false,
);
```

### 2. getVisibilityStatus()
Returns a human-readable visibility status message.

```dart
String getVisibilityStatus({
  required JobPost jobPost,
  bool hasApplied = false,
  bool hasSaved = false,
})
```

**Returns**: A descriptive string explaining why the post is visible/hidden

**Example Messages**:
- `"Draft - Not visible to students"`
- `"Active - Visible to students"`
- `"Closed - Visible because you applied or saved"`
- `"Closed - Hidden from students"`

**Example Usage**:
```dart
final status = JobVisibilityHelper.getVisibilityStatus(
  jobPost: job,
  hasApplied: false,
  hasSaved: true,
);
print(status); // "Closed - Visible because you applied or saved"
```

### 3. filterVisibleJobs()
Filters a list of jobs based on visibility rules.

```dart
List<JobPost> filterVisibleJobs({
  required List<JobPost> jobs,
  Map<String, bool> appliedJobs = const {},
  Map<String, bool> savedJobs = const {},
})
```

**Parameters**:
- `jobs`: List of all jobs to filter
- `appliedJobs`: Map of job ID → whether student applied (default: {})
- `savedJobs`: Map of job ID → whether student saved (default: {})

**Returns**: Filtered list of visible jobs only

**Example**:
```dart
final allJobs = [job1, job2, job3, job4];
final appliedJobs = {'job1_id': true, 'job3_id': true};
final savedJobs = {'job4_id': true};

final visibleJobs = JobVisibilityHelper.filterVisibleJobs(
  jobs: allJobs,
  appliedJobs: appliedJobs,
  savedJobs: savedJobs,
);
// Returns: [job1, job3, job4] (only applied/saved closed + all active)
```

### 4. getVisibilityBadge()
Returns color and label for a visibility badge.

```dart
({Color color, String label}) getVisibilityBadge({
  required JobPost jobPost,
  bool hasApplied = false,
  bool hasSaved = false,
})
```

**Returns**: Record with:
- `color`: The Color to display
- `label`: The text label to show

**Color Meanings**:
- `0xFF6C6C6C` (Gray) - Draft
- `0xFFABD600` (Green) - Active
- `0xFF9B7FD8` (Purple) - Closed but visible
- `0xFFC63F47` (Red) - Closed and hidden

**Example**:
```dart
final badge = JobVisibilityHelper.getVisibilityBadge(
  jobPost: job,
  hasApplied: true,
  hasSaved: false,
);

Container(
  color: badge.color,
  child: Text(badge.label),
)
// Shows: Purple badge with "Closed" label
```

## Real-World Usage Examples

### Example 1: Student Job Feed Screen
```dart
class StudentJobFeedScreen extends StatefulWidget {
  @override
  State<StudentJobFeedScreen> createState() => _StudentJobFeedScreenState();
}

class _StudentJobFeedScreenState extends State<StudentJobFeedScreen> {
  late List<JobPost> _visibleJobs;
  late Map<String, bool> _appliedJobs;
  late Map<String, bool> _savedJobs;

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  void _loadJobs() {
    // Fetch all jobs
    final allJobs = getAllJobsFromDatabase();
    
    // Fetch student's application/save status
    _appliedJobs = getStudentApplications();
    _savedJobs = getStudentSavedJobs();
    
    // Filter for visibility
    _visibleJobs = JobVisibilityHelper.filterVisibleJobs(
      jobs: allJobs,
      appliedJobs: _appliedJobs,
      savedJobs: _savedJobs,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _visibleJobs.length,
      itemBuilder: (context, index) {
        final job = _visibleJobs[index];
        final badge = JobVisibilityHelper.getVisibilityBadge(
          jobPost: job,
          hasApplied: _appliedJobs[job.id] ?? false,
          hasSaved: _savedJobs[job.id] ?? false,
        );
        
        return JobCard(
          job: job,
          badgeColor: badge.color,
          badgeLabel: badge.label,
        );
      },
    );
  }
}
```

### Example 2: Job Detail with Visibility Info
```dart
class JobDetailScreen extends StatelessWidget {
  final JobPost job;
  final bool hasApplied;
  final bool hasSaved;

  const JobDetailScreen({
    required this.job,
    required this.hasApplied,
    required this.hasSaved,
  });

  @override
  Widget build(BuildContext context) {
    final isVisible = JobVisibilityHelper.isVisibleToStudent(
      jobPost: job,
      hasApplied: hasApplied,
      hasSaved: hasSaved,
    );

    if (!isVisible) {
      return Scaffold(
        body: Center(
          child: Text(
            JobVisibilityHelper.getVisibilityStatus(
              jobPost: job,
              hasApplied: hasApplied,
              hasSaved: hasSaved,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          _buildJobHeader(job),
          _buildVisibilityInfo(),
          // ... rest of job details
        ],
      ),
    );
  }

  Widget _buildVisibilityInfo() {
    final status = JobVisibilityHelper.getVisibilityStatus(
      jobPost: job,
      hasApplied: hasApplied,
      hasSaved: hasSaved,
    );
    
    return Container(
      padding: EdgeInsets.all(16),
      child: Text(status),
    );
  }
}
```

### Example 3: Cubit Integration
```dart
class StudentJobsCubit extends Cubit<StudentJobsState> {
  Future<void> loadFeed() async {
    emit(StudentJobsLoading());
    try {
      final allJobs = await _jobRepository.getAllJobs();
      final appliedJobs = await _userRepository.getAppliedJobs();
      final savedJobs = await _userRepository.getSavedJobs();
      
      final visibleJobs = JobVisibilityHelper.filterVisibleJobs(
        jobs: allJobs,
        appliedJobs: appliedJobs,
        savedJobs: savedJobs,
      );
      
      emit(StudentJobsLoaded(jobs: visibleJobs));
    } catch (e) {
      emit(StudentJobsError(e.toString()));
    }
  }
}
```

## Best Practices

### 1. Always Check Visibility Before Displaying
```dart
// ❌ Don't do this
if (job.status == JobStatus.active) {
  showJob(job);
}

// ✅ Do this
if (JobVisibilityHelper.isVisibleToStudent(jobPost: job)) {
  showJob(job);
}
```

### 2. Use filterVisibleJobs() for Lists
```dart
// ❌ Don't filter manually in a loop
final visibleJobs = allJobs.where((job) {
  return job.status == JobStatus.active && !job.isDraft;
}).toList();

// ✅ Do this
final visibleJobs = JobVisibilityHelper.filterVisibleJobs(jobs: allJobs);
```

### 3. Cache Applied/Saved Data
```dart
// ❌ Don't query for each job
for (var job in jobs) {
  final hasApplied = checkIfApplied(job.id);
  final hasSaved = checkIfSaved(job.id);
  // Process...
}

// ✅ Do this
final appliedMap = getAppliedJobsMap();
final savedMap = getSavedJobsMap();
final visibleJobs = JobVisibilityHelper.filterVisibleJobs(
  jobs: jobs,
  appliedJobs: appliedMap,
  savedJobs: savedMap,
);
```

### 4. Use getVisibilityStatus() for Tooltips
```dart
Tooltip(
  message: JobVisibilityHelper.getVisibilityStatus(
    jobPost: job,
    hasApplied: hasApplied,
    hasSaved: hasSaved,
  ),
  child: Icon(Icons.info),
)
```

## Common Scenarios

### Scenario 1: Student Views Active Job
```
Input:  JobPost(isDraft: false, status: active)
Output: isVisibleToStudent() = true
        Reason: Active posts are always visible
```

### Scenario 2: Student Views Closed Job (Not Applied/Saved)
```
Input:  JobPost(isDraft: false, status: closed)
        hasApplied: false, hasSaved: false
Output: isVisibleToStudent() = false
        Reason: Closed job, no interest
```

### Scenario 3: Student Views Closed Job (Applied)
```
Input:  JobPost(isDraft: false, status: closed)
        hasApplied: true, hasSaved: false
Output: isVisibleToStudent() = true
        Reason: Student applied to closed job
```

### Scenario 4: Student Views Draft Job
```
Input:  JobPost(isDraft: true, status: active)
Output: isVisibleToStudent() = false
        Reason: Draft jobs never visible to students
```

## Testing the Helper

```dart
void main() {
  group('JobVisibilityHelper', () {
    test('Active jobs are always visible', () {
      final job = JobPost(
        isDraft: false,
        status: JobStatus.active,
        // ... other fields
      );
      
      expect(
        JobVisibilityHelper.isVisibleToStudent(jobPost: job),
        true,
      );
    });

    test('Draft jobs are never visible', () {
      final job = JobPost(
        isDraft: true,
        status: JobStatus.active,
        // ... other fields
      );
      
      expect(
        JobVisibilityHelper.isVisibleToStudent(jobPost: job),
        false,
      );
    });

    test('Closed jobs visible only if applied or saved', () {
      final job = JobPost(
        isDraft: false,
        status: JobStatus.closed,
        // ... other fields
      );
      
      // Not visible
      expect(
        JobVisibilityHelper.isVisibleToStudent(jobPost: job),
        false,
      );
      
      // Visible if applied
      expect(
        JobVisibilityHelper.isVisibleToStudent(
          jobPost: job,
          hasApplied: true,
        ),
        true,
      );
    });
  });
}
```
