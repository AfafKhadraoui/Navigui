````markdown
# Navigui - Frontend Development Guide

## WHERE TO FIND STYLES & COLORS

### Theme System Location

```
lib/commons/themes/style_simple/
├── colors.dart         # 🎨 ALL YOUR DESIGN COLORS HERE!
├── styles.dart         # 📏 Text styles, spacing, border radius
└── theme.dart          # Material theme configuration
```

###  How to Use Colors

```dart
// 1. Import the colors file
import 'package:navigui/commons/themes/style_simple/colors.dart';

// 2. Use any color from your Figma design
Container(
  color: AppColors.background,          // #1A1A1A - Main background
  child: Text(
    'Hello',
    style: TextStyle(color: AppColors.electricLime),  // #D2FF1F - Primary
  ),
)
```


##  Navigation Structure (5 Bottom Tabs)

The app has **5 bottom navigation tabs**:

| Tab             | Route      | Screen                | Purpose                                                     |
| --------------- | ---------- | --------------------- | ----------------------------------------------------------- |
| 🏠 **Home**     | `/home`    | `HomeScreen`          | Main feed with job recommendations                          |
| 💼 **Browse**   | `/jobs`    | `JobsPage`            | Full job listings with search & filters                     |
| ✅ **My Tasks** | `/tasks`   | `MyTasksScreen`       | Student: Applied jobs<br>Employer: Posted jobs & applicants |
| 📚 **Learn**    | `/learn`   | `EducationListScreen` | Educational content and courses                             |
| 👤 **Profile**  | `/profile` | `MyProfileScreen`     | User settings and profile                                   |

### Screen Locations

```
lib/views/screens/
├── homescreen/
│   └── home_screen.dart           # Home tab
├── jobs/
│   └── jobs_page.dart             # Browse Jobs tab
├── tasks/
│   └── my_tasks_screen.dart       # My Tasks tab (NEW!)
├── education/
│   └── education_list_screen.dart # Learn tab
└── profile/
    └── my_profile_screen.dart     # Profile tab
```

### Navigation Routes

Routes are defined in `lib/routes/app_router.dart`:

```dart
// Public routes (NO bottom bar) - Welcome, Login, Register
AppRouter.welcome       // /
AppRouter.onboarding    // /onboarding
AppRouter.login         // /login
AppRouter.register      // /register

// Protected routes (WITH bottom bar) - Main app
AppRouter.home          // /home
AppRouter.jobs          // /jobs
AppRouter.tasks         // /tasks  ← NEW!
AppRouter.learn         // /learn
AppRouter.profile       // /profile
```

### How to Navigate Between Screens

```dart
import 'package:go_router/go_router.dart';
import 'package:navigui/routes/app_router.dart';

// Navigate to a screen (replaces current)
context.go(AppRouter.home);
context.go(AppRouter.tasks);
context.go(AppRouter.jobs);

// Push (adds to navigation stack - back button works)
context.push('/job-details');

// Go back
context.pop();
```

---

## Quick Start

### Running the App

```bash
flutter pub get
flutter run
```

---

## 📁 Project Structure (Frontend Only)

```
lib/
├── main.dart                    # App entry point with bottom navigation
├── commons/                     # Shared resources
│   ├── config.dart             # App configuration
│   ├── constants.dart          # Constants
│   └── themes/style_simple/    # Theme system
│       ├── colors.dart         # Color palette
│       ├── styles.dart         # Text styles & spacing
│       └── theme.dart          # Material theme
│
├── mock/                        # Mock data loader class
│   └── mock_data.dart          # Data loader implementation
│
├── logic/models/                # Data models
│   ├── job_model.dart
│   ├── student_model.dart
│   ├── employer_model.dart
│   ├── service_model.dart
│   └── ... (all models with JSON support)
│
├── utils/                       # Helper functions & 🎯 MOCK DATA
│   ├── validators.dart
│   ├── date_formatter.dart
│   ├── helpers.dart
│   └── mock_data/              # 🎯 PUT YOUR JSON FILES HERE!
│       ├── jobs.json           # Your job listings
│       ├── students.json       # Student profiles
│       ├── services.json       # Services offered
│       └── ...                 # Add more as needed
│
└── views/                       # UI Components
    ├── screens/                # Pages
    │   ├── homescreen/
    │   ├── jobs/
    │   ├── profile/
    │   └── ... (42 screens total)
    │
    └── widgets/                # Reusable components
        ├── common/             # Common widgets
        ├── navigation/         # Nav components
        ├── home/              # Home sections
        └── ... (39 widgets total)
```

---

## 🎭 Mock Data System

### Folder Location

Your mock data goes in `lib/utils/mock_data/` folder!

### Recommended Structure

Create JSON files for each data type:

**Recommended: By Feature**

```
lib/utils/mock_data/
├── jobs.json           # All job listings
├── students.json       # Student profiles
├── services.json       # Services marketplace
├── employers.json      # Employer profiles
├── applications.json   # Job applications
└── reviews.json        # Reviews and ratings
```

**Important**: Since these files are in `lib/` folder, you DON'T need to add anything to `pubspec.yaml`!

---

## Adding Mock Data

### Step 1: Create Your JSON Files

Add your JSON files to `lib/utils/mock_data/` folder.

### Step 2: JSON File Format

**Example: `lib/utils/mock_data/jobs.json`**

```json
[
  {
    "id": "job_1",
    "employerId": "emp_1",
    "title": "Waiter Needed - Weekend",
    "description": "Looking for a friendly waiter for weekend shifts...",
    "briefDescription": "Weekend waiter position",
    "category": "Hospitality",
    "jobType": "part_time",
    "requirements": "Good communication, punctual",
    "pay": 1500.0,
    "paymentType": "daily",
    "timeCommitment": "half_day",
    "duration": "ongoing",
    "startDate": "2025-11-15T08:00:00Z",
    "isRecurring": true,
    "numberOfPositions": 2,
    "location": "Algiers",
    "photos": [],
    "tags": ["hospitality", "weekend"],
    "contactPreference": "phone",
    "deadline": "2025-11-10T23:59:59Z",
    "isUrgent": false,
    "requiresCV": false,
    "isDraft": false,
    "languagesRequired": ["Arabic", "French"],
    "status": "active",
    "createdAt": "2025-10-25T10:00:00Z",
    "updatedAt": null,
    "applicantsCount": 5
  }
]
```

**Note**: See `lib/logic/models/` for all model fields and their types.

### Step 3: Update MockData Loader

Update `lib/mock/mock_data.dart` to load from your JSON files:

```dart
import 'dart:convert';
import 'package:flutter/services.dart';

// Example: Load jobs from lib/utils/mock_data/jobs.json
static Future<List<JobModel>> loadJobs() async {
  if (_jobs != null) return _jobs!;

  try {
    // Load from lib/utils/mock_data/ folder
    final jsonString = await rootBundle.loadString('lib/utils/mock_data/jobs.json');
    final jsonList = json.decode(jsonString) as List;
    _jobs = jsonList.map((json) => JobModel.fromJson(json)).toList();
    return _jobs!;
  } catch (e) {
    print('Error loading jobs: $e');
    return [];
  }
}
```

**Important**: The path `lib/utils/mock_data/` is accessed directly since it's in your lib folder!

### Step 4: Use Mock Data in Your Screen

**Check existing files for structure!** All screen and widget files have TODO comments showing what to implement.

**Example: Loading data in a screen**

```dart
import 'package:flutter/material.dart';
import '../../mock/mock_data.dart';
import '../../logic/models/job_model.dart';

class MyJobsScreen extends StatefulWidget {
  const MyJobsScreen({super.key});

  @override
  State<MyJobsScreen> createState() => _MyJobsScreenState();
}

class _MyJobsScreenState extends State<MyJobsScreen> {
  List<JobModel> _jobs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    try {
      final jobs = await MockData.loadJobs();
      setState(() {
        _jobs = jobs;
        _isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: _jobs.length,
      itemBuilder: (context, index) {
        final job = _jobs[index];
        return ListTile(
          title: Text(job.title),
          subtitle: Text('${job.pay} DA - ${job.location}'),
          onTap: () {
            // Navigate to job details
          },
        );
      },
    );
  }
}
```

---

## Using Common Widgets

### CustomAppBar

```dart
import '../../widgets/common/custom_app_bar.dart';

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: CustomAppBar(
      title: 'My Page',
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            // Search action
          },
        ),
      ],
    ),
    body: // Your content
  );
}
```

### Bottom Navigation (5 Tabs - Already Set Up!)

The app has bottom navigation configured in `lib/routes/app_router.dart`. Your screens are automatically part of it!

The **5 tabs** are:

1. **🏠 Home** → `HomeScreen()` - Main job feed
2. **💼 Browse** → `JobsPage()` - Search all jobs
3. **✅ My Tasks** → `MyTasksScreen()` - Your jobs (student/employer view)
4. **📚 Learn** → `EducationListScreen()` - Educational content
5. **👤 Profile** → `MyProfileScreen()` - Your profile

The bottom bar shows on all 5 screens above, but NOT on welcome/login/register screens.

---

## Using Theme Colors & Styles

### Import Theme Files

```dart
import 'package:navigui/commons/themes/style_simple/colors.dart';
import 'package:navigui/commons/themes/style_simple/styles.dart';
```

### Example: Styled Container

```dart
Container(
  padding: EdgeInsets.all(AppStyles.spacingMD),        // 16px padding
  decoration: BoxDecoration(
    color: AppColors.surface,                           // #2C2C2C dark surface
    borderRadius: BorderRadius.circular(AppStyles.radiusMD),  // 12px rounded
    border: Border.all(color: AppColors.electricLime, width: 2),
  ),
  child: Text(
    'Hello World',
    style: TextStyle(
      color: AppColors.textPrimary,                     // White text
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  ),
)
```

### Example: Card with Theme

```dart
Card(
  color: AppColors.surface,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppStyles.radiusMD),
  ),
  child: Padding(
    padding: EdgeInsets.all(AppStyles.spacingMD),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Job Title',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: AppStyles.spacingSM),
        Text(
          'Description here',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
      ],
    ),
  ),
)
```

---

## MockData Methods (To Implement)

The `lib/mock/mock_data.dart` file has methods ready. You need to implement them to load from `lib/utils/mock_data/`:

```dart
// Jobs
final jobs = await MockData.loadJobs();
final urgentJobs = await MockData.getUrgentJobs();  // Filters jobs where isUrgent = true
final activeJobs = await MockData.getActiveJobs();  // Filters jobs where status = 'active'
final categoryJobs = await MockData.getJobsByCategory('Hospitality');

// Students
final students = await MockData.loadStudents();
final student = await MockData.getStudentById('student_1');

// Employers
final employers = await MockData.loadEmployers();
final employer = await MockData.getEmployerById('emp_1');

// Services (Fiverr-like)
final services = await MockData.loadServices();

// Applications
final applications = await MockData.loadApplications();

// Reviews
final reviews = await MockData.loadReviews();

// Notifications
final notifications = await MockData.loadNotifications();

// Clear cache (useful for refresh)
MockData.clearCache();
```

**Important**: Each method should load from `lib/utils/mock_data/<filename>.json`!

---

## Replacing Mock Data with Real Backend (Later)

When backend is ready, you'll only need to change the data loading:

**Before (Mock):**

```dart
final jobs = await MockData.loadJobs();
```

**After (Real Backend):**

```dart
final jobRepo = JobRepository();
final jobs = await jobRepo.fetchJobs();
```

That's it! Your UI stays the same.

---

## 📝 Common Patterns

### Loading State

```dart
bool _isLoading = true;

Future<void> _loadData() async {
  setState(() => _isLoading = true);
  try {
    final data = await MockData.loadJobs();
    setState(() {
      _jobs = data;
      _isLoading = false;
    });
  } catch (e) {
    setState(() => _isLoading = false);
  }
}

// In build:
if (_isLoading) {
  return const Center(child: CircularProgressIndicator());
}
```

### Empty State

```dart
if (_jobs.isEmpty) {
  return Center(
    child: Text(
      'No jobs available',
      style: AppStyles.bodyMedium.copyWith(
        color: AppColors.grey500,
      ),
    ),
  );
}
```

### Navigation

```dart
// Push to new screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const JobDetailScreen(),
  ),
);

// Pop back
Navigator.pop(context);
```

---

## Common Issues & Solutions

### Issue: "Cannot find mock data file"

**Solution:** Make sure your JSON files are in `lib/utils/mock_data/` folder. Since they're in `lib/`, you don't need `pubspec.yaml` changes!

### Issue: "JSON decode error"

**Solution:** Check your JSON syntax in `lib/utils/mock_data/*.json`. Use a JSON validator online (like jsonlint.com).

### Issue: "Widget not updating"

**Solution:** Make sure you're calling `setState(() { ... })` when changing data.

### Issue: "Theme colors not working"

**Solution:** Import the theme files:

```dart
import '../../commons/themes/style_simple/colors.dart';
import '../../commons/themes/style_simple/styles.dart';
```

---

## ✅ Checklist for Each Screen

- [ ] Import necessary models and mock_data.dart
- [ ] Use StatefulWidget for screens that load data
- [ ] Show loading indicator while data loads
- [ ] Handle empty states
- [ ] Use theme colors (AppColors) and styles (AppStyles)
- [ ] Add proper navigation
- [ ] Test on emulator/device

---

## Team Workflow

1. **Each member** adds their mock data to `lib/utils/mock_data/` folder
2. **Create separate files** by feature (jobs.json, students.json) OR by team member
3. **Update `lib/mock/mock_data.dart`** to load from your JSON files
4. **No pubspec.yaml changes needed** - files are in lib/ folder!
5. **Focus on UI** - data structure is already defined in models

---

## Need Help?

- **All files have TODO comments!** Check any screen or widget file for guidance
- Check `lib/views/screens/homescreen/home_screen.dart` for screen structure
- Check `lib/views/widgets/home/` widgets for implementation patterns
- All models are in `lib/logic/models/` with field documentation
- Theme system: `lib/commons/themes/style_simple/`

---

## Files Structure Reference

### Screen Files (Structure Ready with TODOs)

- **`lib/views/screens/homescreen/home_screen.dart`** - Main home with sections
- **`lib/views/widgets/home/part_time_jobs_section.dart`** - Job cards with horizontal scroll
- **`lib/views/widgets/home/urgent_jobs_section.dart`** - Urgent jobs list
- **`lib/views/widgets/home/services_section.dart`** - Services marketplace
- **`lib/views/widgets/home/quick_tasks_section.dart`** - Quick tasks display
- **`lib/views/widgets/home/educational_content_section.dart`** - Learning articles

### Ready-to-Use Components

- **`lib/views/widgets/common/custom_app_bar.dart`** - Reusable app bar
- **`lib/views/widgets/navigation/bottom_nav_bar.dart`** - Bottom navigation
- **`lib/main.dart`** - App entry with navigation structure
- **`lib/mock/mock_data.dart`** - Data loader (update with your JSON paths)

---

## Implementation Priority

1. **Setup Mock Data**
   - Create JSON files in `lib/utils/mock_data/`
   - Update `lib/mock/mock_data.dart` to load from your files
2. **Implement Home Sections** (Follow TODOs in `lib/views/widgets/home/`)

3. **Implement Jobs Page** (Create list/grid view)

4. **Implement Profile Page** (User info and stats)

5. **Add Navigation** (Connect all pages)

---

Good luck FATAYAT ! The structure is ready - just follow the TODO comments in each file!

Good luck! You have 2 days - let's build something amazing!
````
