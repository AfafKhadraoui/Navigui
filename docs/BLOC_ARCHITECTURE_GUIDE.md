# NAVIGUI - BLoC/Cubit Architecture Documentation

## 📋 Table of Contents

1. [Overview](#overview)
2. [All Implemented Cubits](#all-implemented-cubits)
3. [Cubit Details & Responsibilities](#cubit-details--responsibilities)
4. [Implementation Roadmap](#implementation-roadmap)
5. [Folder Structure](#folder-structure)
6. [How to Use Cubits](#how-to-use-cubits)

---

## 🎯 Overview

This project now uses **Flutter BLoC** architecture with **Cubits** for state management. All 13 Cubits have been implemented with proper state classes, methods, and repository dependencies.

### Architecture Layers:

```
┌─────────────────────────────────────┐
│  PRESENTATION LAYER (Views/Screens) │
│  - Widgets, Screens, UI Components  │
└──────────────┬──────────────────────┘
               │ uses BlocBuilder/BlocConsumer
┌──────────────▼──────────────────────┐
│  BUSINESS LOGIC LAYER (Cubits)     │
│  - State Management, Business Rules │
└──────────────┬──────────────────────┘
               │ calls repository methods
┌──────────────▼──────────────────────┐
│  DATA LAYER (Repositories)          │
│  - API calls, Local storage, Models │
└─────────────────────────────────────┘
```

### Dependencies Added:

```yaml
flutter_bloc: ^8.1.3 # State management
equatable: ^2.0.5 # Value equality for states
get_it: ^7.6.4 # Dependency injection
dartz: ^0.10.1 # Functional programming
http: ^1.1.0 # Network requests
shared_preferences: ^2.2.2 # Local storage
```

---

## 📦 All Implemented Cubits

| #   | Cubit Name                   | Priority | Status         | Location                                 |
| --- | ---------------------------- | -------- | -------------- | ---------------------------------------- |
| 1   | **AuthCubit**                | P1       | ✅ Implemented | `lib/logic/cubits/auth/`                 |
| 2   | **JobCubit**                 | P1       | ✅ Implemented | `lib/logic/cubits/job/`                  |
| 3   | **ApplicationCubit**         | P1       | ✅ Implemented | `lib/logic/cubits/application/`          |
| 4   | **StudentProfileCubit**      | P2       | ✅ Implemented | `lib/logic/cubits/student_profile/`      |
| 5   | **EmployerProfileCubit**     | P2       | ✅ Implemented | `lib/logic/cubits/employer_profile/`     |
| 6   | **EmployerJobCubit**         | P2       | ✅ Implemented | `lib/logic/cubits/employer_job/`         |
| 7   | **EmployerApplicationCubit** | P2       | ✅ Implemented | `lib/logic/cubits/employer_application/` |
| 8   | **NotificationCubit**        | P3       | ✅ Implemented | `lib/logic/cubits/notification/`         |
| 9   | **SearchCubit**              | P3       | ✅ Implemented | `lib/logic/cubits/search/`               |
| 10  | **SavedJobsCubit**           | P3       | ✅ Implemented | `lib/logic/cubits/saved_jobs/`           |
| 11  | **ReviewCubit**              | P3       | ✅ Implemented | `lib/logic/cubits/review/`               |
| 12  | **EducationCubit**           | P4       | ✅ Implemented | `lib/logic/cubits/education/`            |
| 13  | **AdminCubit**               | P4       | ✅ Implemented | `lib/logic/cubits/admin/`                |

---

## 🔍 Cubit Details & Responsibilities

### 1. AuthCubit

**📁 Location:** `lib/logic/cubits/auth/`  
**🎯 Responsibility:** Handle user authentication (login, signup, logout)  
**🔗 Repository:** `AuthRepository`

#### State Classes:

```dart
AuthInitial          // Initial state when app starts
AuthLoading          // While authenticating
AuthAuthenticated    // User is logged in (contains UserModel)
AuthUnauthenticated  // User is logged out
AuthError            // Authentication failed (contains error message)
```

#### State Properties:

- `AuthAuthenticated`: `UserModel user`
- `AuthError`: `String message`

#### Methods:

```dart
Future<void> login({required String email, required String password})
Future<void> signup({required String email, required String password, required String fullName, required String role, Map<String, dynamic>? additionalData})
Future<void> logout()
Future<void> checkAuthStatus()  // Check if user is already logged in
```

#### Used By Screens:

- `LoginScreen`
- `SignupScreen` (Student & Employer)
- `SplashScreen`
- Protected routes in `AppRouter`

---

### 2. JobCubit

**📁 Location:** `lib/logic/cubits/job/`  
**🎯 Responsibility:** Manage job listings, search, filter, and job details  
**🔗 Repository:** `JobRepository`

#### State Classes:

```dart
JobInitial        // Initial state
JobLoading        // Loading jobs
JobLoaded         // Jobs loaded successfully (with filters)
JobDetailLoaded   // Single job details loaded
JobError          // Error occurred
```

#### State Properties:

- `JobLoaded`: `List<JobPost> jobs`, `String? searchQuery`, `String? categoryFilter`, `String? sortBy`
- `JobDetailLoaded`: `JobPost job`
- `JobError`: `String message`

#### Methods:

```dart
Future<void> loadJobs({String? searchQuery, String? categoryFilter, String? sortBy})
Future<void> loadJobDetails(int jobId)
Future<void> searchJobs(String query)
Future<void> filterByCategory(String category)
Future<void> sortJobs(String sortBy)  // 'salary_high', 'salary_low', 'recent'
Future<void> refreshJobs()
```

#### Used By Screens:

- `HomeScreen` - Featured jobs
- `JobsPage` - All jobs list
- `JobDetailScreen` - Single job view
- `SearchPage` - Search results
- `CategoryJobsScreen` - Jobs by category

---

### 3. ApplicationCubit

**📁 Location:** `lib/logic/cubits/application/`  
**🎯 Responsibility:** Handle student job applications  
**🔗 Repository:** `ApplicationRepository`

#### State Classes:

```dart
ApplicationInitial      // Initial state
ApplicationLoading      // Processing application action
ApplicationsLoaded      // User's applications loaded
ApplicationSubmitted    // Application submitted successfully
ApplicationUpdated      // Application status updated
ApplicationWithdrawn    // Application withdrawn
ApplicationError        // Error occurred
```

#### State Properties:

- `ApplicationsLoaded`: `List<ApplicationModel> applications`, `String? statusFilter`
- `ApplicationSubmitted`: `ApplicationModel application`
- `ApplicationUpdated`: `ApplicationModel application`
- `ApplicationWithdrawn`: `int applicationId`
- `ApplicationError`: `String message`

#### Methods:

```dart
Future<void> loadMyApplications({String? statusFilter})
Future<void> submitApplication({required int jobId, required String coverLetter, String? resumeUrl, Map<String, dynamic>? additionalInfo})
Future<void> withdrawApplication(int applicationId)
Future<void> filterByStatus(String status)  // 'pending', 'accepted', 'rejected'
Future<void> refreshApplications()
```

#### Used By Screens:

- `MyApplicationsScreen` - View all applications
- `ApplyJobScreen` - Submit application
- `ApplicationDetailScreen` - View single application

---

### 4. StudentProfileCubit

**📁 Location:** `lib/logic/cubits/student_profile/`  
**🎯 Responsibility:** Manage student profile data  
**🔗 Repository:** `UserRepository`

#### State Classes:

```dart
StudentProfileInitial   // Initial state
StudentProfileLoading   // Loading/updating profile
StudentProfileLoaded    // Profile data loaded
StudentProfileUpdated   // Profile updated successfully
StudentProfileError     // Error occurred
```

#### State Properties:

- `StudentProfileLoaded`: `StudentModel profile`
- `StudentProfileUpdated`: `StudentModel profile`
- `StudentProfileError`: `String message`

#### Methods:

```dart
Future<void> loadProfile(int userId)
Future<void> updateProfile({required int userId, String? bio, String? phone, String? university, String? major, int? graduationYear, List<String>? skills, List<Map<String, dynamic>>? education, List<Map<String, dynamic>>? experience, String? resumeUrl, String? profilePictureUrl})
Future<void> refreshProfile(int userId)
```

#### Used By Screens:

- `ProfileScreen` - View profile
- `EditProfileScreen` - Edit profile
- `ProfileSettingsScreen` - Settings

---

### 5. EmployerProfileCubit

**📁 Location:** `lib/logic/cubits/employer_profile/`  
**🎯 Responsibility:** Manage employer/company profile  
**🔗 Repository:** `UserRepository`

#### State Classes:

```dart
EmployerProfileInitial   // Initial state
EmployerProfileLoading   // Loading/updating profile
EmployerProfileLoaded    // Profile loaded
EmployerProfileUpdated   // Profile updated
EmployerProfileError     // Error occurred
```

#### State Properties:

- `EmployerProfileLoaded`: `EmployerModel profile`
- `EmployerProfileUpdated`: `EmployerModel profile`
- `EmployerProfileError`: `String message`

#### Methods:

```dart
Future<void> loadProfile(int userId)
Future<void> updateProfile({required int userId, String? companyName, String? companyDescription, String? industry, String? website, String? phone, String? address, String? logoUrl, int? companySize, int? foundedYear})
Future<void> refreshProfile(int userId)
```

#### Used By Screens:

- `EmployerProfileScreen`
- `EditCompanyProfileScreen`
- `CompanySettingsScreen`

---

### 6. EmployerJobCubit

**📁 Location:** `lib/logic/cubits/employer_job/`  
**🎯 Responsibility:** Employer's job post management (CRUD operations)  
**🔗 Repository:** `JobRepository`

#### State Classes:

```dart
EmployerJobInitial    // Initial state
EmployerJobLoading    // Processing action
EmployerJobsLoaded    // Employer's jobs loaded
EmployerJobCreated    // Job created successfully
EmployerJobUpdated    // Job updated
EmployerJobDeleted    // Job deleted
EmployerJobError      // Error occurred
```

#### State Properties:

- `EmployerJobsLoaded`: `List<JobPost> jobs`, `String? statusFilter`
- `EmployerJobCreated`: `JobPost job`
- `EmployerJobUpdated`: `JobPost job`
- `EmployerJobDeleted`: `int jobId`
- `EmployerJobError`: `String message`

#### Methods:

```dart
Future<void> loadMyJobs({String? statusFilter})
Future<void> createJob({required String title, required String description, required String category, required String location, required String employmentType, required double salary, required String salaryType, List<String>? requirements, List<String>? benefits, DateTime? deadline, int? positionsAvailable})
Future<void> updateJob({required int jobId, String? title, ...})
Future<void> deleteJob(int jobId)
Future<void> closeJob(int jobId)  // Set status to 'closed'
Future<void> filterByStatus(String status)
Future<void> refreshJobs()
```

#### Used By Screens:

- `EmployerDashboardScreen` - Job statistics
- `EmployerJobsListScreen` - All employer jobs
- `CreateJobScreen` - Create new job
- `EditJobScreen` - Edit existing job
- `ManageJobScreen` - Job management

---

### 7. EmployerApplicationCubit

**📁 Location:** `lib/logic/cubits/employer_application/`  
**🎯 Responsibility:** Employer's view of applications (accept/reject/shortlist)  
**🔗 Repository:** `ApplicationRepository`

#### State Classes:

```dart
EmployerApplicationInitial   // Initial state
EmployerApplicationLoading   // Processing action
EmployerApplicationsLoaded   // Applications loaded
EmployerApplicationUpdated   // Application status updated
EmployerApplicationError     // Error occurred
```

#### State Properties:

- `EmployerApplicationsLoaded`: `List<ApplicationModel> applications`, `int? jobId`, `String? statusFilter`
- `EmployerApplicationUpdated`: `ApplicationModel application`
- `EmployerApplicationError`: `String message`

#### Methods:

```dart
Future<void> loadJobApplications({int? jobId, String? statusFilter})
Future<void> updateApplicationStatus({required int applicationId, required String status, String? employerNotes})
Future<void> acceptApplication(int applicationId, {String? notes})
Future<void> rejectApplication(int applicationId, {String? notes})
Future<void> shortlistApplication(int applicationId)
Future<void> filterByStatus(String status)
Future<void> refreshApplications()
```

#### Used By Screens:

- `EmployerApplicationsScreen` - All applications for employer
- `JobApplicationsScreen` - Applications for specific job
- `ReviewApplicationScreen` - Review single application
- `ApplicationDetailScreen` - View application details

---

### 8. NotificationCubit

**📁 Location:** `lib/logic/cubits/notification/`  
**🎯 Responsibility:** Manage user notifications  
**🔗 Repository:** `NotificationRepository`

#### State Classes:

```dart
NotificationInitial              // Initial state
NotificationLoading              // Loading notifications
NotificationsLoaded              // Notifications loaded with unread count
NotificationMarkedAsRead         // Single notification marked as read
AllNotificationsMarkedAsRead     // All marked as read
NotificationDeleted              // Notification deleted
NotificationError                // Error occurred
```

#### State Properties:

- `NotificationsLoaded`: `List<NotificationModel> notifications`, `int unreadCount`
- `NotificationMarkedAsRead`: `int notificationId`
- `NotificationDeleted`: `int notificationId`
- `NotificationError`: `String message`

#### Methods:

```dart
Future<void> loadNotifications()
Future<void> markAsRead(int notificationId)
Future<void> markAllAsRead()
Future<void> deleteNotification(int notificationId)
Future<void> refreshNotifications()
```

#### Used By Screens:

- `NotificationsScreen` - All notifications
- `AppBar` - Unread count badge
- `HomeScreen` - Recent notifications

---

### 9. SearchCubit

**📁 Location:** `lib/logic/cubits/search/`  
**🎯 Responsibility:** Advanced job search with filters  
**🔗 Repository:** `JobRepository`

#### State Classes:

```dart
SearchInitial           // Initial state (no search performed)
SearchLoading           // Searching
SearchResultsLoaded     // Results found
SearchEmpty             // No results found
SearchError             // Search failed
```

#### State Properties:

- `SearchResultsLoaded`: `List<JobPost> results`, `String query`, `Map<String, dynamic> filters`, `List<String> recentSearches`
- `SearchEmpty`: `String query`
- `SearchError`: `String message`

#### Methods:

```dart
Future<void> search({required String query, Map<String, dynamic>? filters})
Future<void> applyFilters({required String query, required Map<String, dynamic> filters})
void clearSearch()
void clearRecentSearches()
List<String> getRecentSearches()
```

#### Used By Screens:

- `SearchPage` - Main search interface
- `AdvancedSearchScreen` - Advanced filters
- `SearchResultsScreen` - Display results

---

### 10. SavedJobsCubit

**📁 Location:** `lib/logic/cubits/saved_jobs/`  
**🎯 Responsibility:** Manage user's saved/bookmarked jobs  
**🔗 Repository:** `JobRepository`

#### State Classes:

```dart
SavedJobsInitial    // Initial state
SavedJobsLoading    // Loading saved jobs
SavedJobsLoaded     // Saved jobs loaded
JobSaved            // Job bookmarked
JobUnsaved          // Job unbookmarked
SavedJobsError      // Error occurred
```

#### State Properties:

- `SavedJobsLoaded`: `List<JobPost> savedJobs`, `List<int> savedJobIds`
- `JobSaved`: `int jobId`
- `JobUnsaved`: `int jobId`
- `SavedJobsError`: `String message`

#### Methods:

```dart
Future<void> loadSavedJobs()
Future<void> saveJob(int jobId)
Future<void> unsaveJob(int jobId)
Future<void> toggleSaveJob(int jobId)
bool isJobSaved(int jobId)
Future<void> refreshSavedJobs()
```

#### Used By Screens:

- `SavedJobsScreen` - View all saved jobs
- `JobDetailScreen` - Save/unsave button
- `JobsPage` - Bookmark icon on job cards

---

### 11. ReviewCubit

**📁 Location:** `lib/logic/cubits/review/`  
**🎯 Responsibility:** Manage reviews/ratings for employers and students  
**🔗 Repository:** `ReviewRepository`

#### State Classes:

```dart
ReviewInitial      // Initial state
ReviewLoading      // Loading reviews
ReviewsLoaded      // Reviews loaded with statistics
ReviewSubmitted    // Review submitted
ReviewUpdated      // Review updated
ReviewDeleted      // Review deleted
ReviewError        // Error occurred
```

#### State Properties:

- `ReviewsLoaded`: `List<ReviewModel> reviews`, `double averageRating`, `Map<int, int> ratingDistribution`
- `ReviewSubmitted`: `ReviewModel review`
- `ReviewUpdated`: `ReviewModel review`
- `ReviewDeleted`: `int reviewId`
- `ReviewError`: `String message`

#### Methods:

```dart
Future<void> loadReviews({int? employerId, int? studentId})
Future<void> submitReview({required int revieweeId, required String revieweeType, required double rating, required String comment, int? jobId})
Future<void> updateReview({required int reviewId, double? rating, String? comment})
Future<void> deleteReview(int reviewId)
Future<void> refreshReviews({int? employerId, int? studentId})
```

#### Used By Screens:

- `EmployerProfileScreen` - Show employer reviews
- `StudentProfileScreen` - Show student reviews
- `SubmitReviewScreen` - Write review
- `ReviewsListScreen` - All reviews

---

### 12. EducationCubit

**📁 Location:** `lib/logic/cubits/education/`  
**🎯 Responsibility:** Manage educational articles and resources  
**🔗 Repository:** `EducationRepository` (to be created)

#### State Classes:

```dart
EducationInitial              // Initial state
EducationLoading              // Loading articles
EducationArticlesLoaded       // Articles loaded
EducationArticleDetailLoaded  // Single article loaded
EducationError                // Error occurred
```

#### State Properties:

- `EducationArticlesLoaded`: `List<EducationArticleModel> articles`, `String? categoryFilter`, `String? searchQuery`
- `EducationArticleDetailLoaded`: `EducationArticleModel article`
- `EducationError`: `String message`

#### Methods:

```dart
Future<void> loadArticles({String? categoryFilter, String? searchQuery})
Future<void> loadArticleDetail(int articleId)
Future<void> searchArticles(String query)
Future<void> filterByCategory(String category)
Future<void> refreshArticles()
```

#### Used By Screens:

- `EducationHomeScreen` - Articles overview
- `ArticleListScreen` - Category articles
- `ArticleDetailScreen` - Read article
- `SearchArticlesScreen` - Search articles

**⚠️ Note:** Requires `EducationRepository` implementation

---

### 13. AdminCubit

**📁 Location:** `lib/logic/cubits/admin/`  
**🎯 Responsibility:** Admin panel operations (user management, job moderation)  
**🔗 Repository:** `AdminRepository` (to be created)

#### State Classes:

```dart
AdminInitial          // Initial state
AdminLoading          // Loading data
AdminDashboardLoaded  // Dashboard statistics loaded
AdminUsersLoaded      // Users list loaded
AdminJobsLoaded       // Jobs list loaded
AdminUserUpdated      // User status updated
AdminJobUpdated       // Job status updated
AdminError            // Error occurred
```

#### State Properties:

- `AdminDashboardLoaded`: `Map<String, dynamic> statistics`
- `AdminUsersLoaded`: `List<UserModel> users`, `String? roleFilter`, `String? statusFilter`
- `AdminJobsLoaded`: `List<JobPost> jobs`, `String? statusFilter`
- `AdminUserUpdated`: `UserModel user`
- `AdminJobUpdated`: `JobPost job`
- `AdminError`: `String message`

#### Methods:

```dart
Future<void> loadDashboard()
Future<void> loadUsers({String? roleFilter, String? statusFilter})
Future<void> loadJobs({String? statusFilter})
Future<void> updateUserStatus({required int userId, required String status})
Future<void> verifyEmployer(int userId)
Future<void> suspendUser(int userId)
Future<void> deleteJob(int jobId)
Future<void> filterUsersByRole(String role)
Future<void> filterJobsByStatus(String status)
```

#### Used By Screens:

- `AdminDashboardScreen` - Overview & statistics
- `ManageUsersScreen` - User management
- `ManageJobsScreen` - Job moderation
- `VerifyEmployersScreen` - Employer verification
- `ReportsScreen` - Handle reports

**⚠️ Note:** Requires `AdminRepository` implementation

---

## 🗺️ Implementation Roadmap

### ✅ COMPLETED

- All 13 Cubits implemented with state classes
- All repository files created with mock implementations
- Dependency injection setup with GetIt
- `main.dart` updated to use MultiBlocProvider
- `pubspec.yaml` updated with all dependencies

### 📅 5-WEEK IMPLEMENTATION PLAN

---

### **WEEK 1: Foundation & Authentication** ⭐ START HERE

**Goal:** Get authentication working with BLoC pattern

#### Day 1-2: Setup & Auth Flow

- ✅ Run `flutter pub get` to install dependencies
- ✅ Test app runs without errors
- 🔧 Update `LoginScreen` to use `BlocConsumer<AuthCubit, AuthState>`
- 🔧 Replace `setState` with `context.read<AuthCubit>().login(...)`
- 🔧 Handle `AuthLoading`, `AuthAuthenticated`, `AuthError` states

#### Day 3-4: Complete Auth Screens

- 🔧 Update `SignupScreen` (Student & Employer variants)
- 🔧 Implement proper loading indicators during `AuthLoading`
- 🔧 Show error snackbars/dialogs for `AuthError` state
- 🔧 Navigate to appropriate home screen on `AuthAuthenticated`

#### Day 5: Testing & Bug Fixes

- 🧪 Test login flow end-to-end
- 🧪 Test signup flow for both roles
- 🧪 Test logout functionality
- 🧪 Test app restart (check auth persistence)

**Deliverables:**

- ✅ Working login/signup/logout with BLoC
- ✅ No more `ChangeNotifierProvider` for auth
- ✅ Proper state handling and error messages

---

### **WEEK 2: Core Job Features** 🎯

**Goal:** Implement job browsing, search, and applications

#### Day 1-2: Job Listing & Details

- 🔧 Update `HomeScreen` to use `BlocBuilder<JobCubit, JobState>`
- 🔧 Update `JobsPage` to display jobs from `JobLoaded` state
- 🔧 Replace hardcoded mock data with `context.read<JobCubit>().loadJobs()`
- 🔧 Update `JobDetailScreen` to load single job
- 🔧 Add pull-to-refresh using `refreshJobs()`

#### Day 3-4: Search & Filters

- 🔧 Update `SearchPage` to use `SearchCubit`
- 🔧 Implement search bar with real-time search
- 🔧 Add category filters
- 🔧 Add sort options (salary, date)
- 🔧 Show recent searches

#### Day 5: Applications

- 🔧 Update `ApplyJobScreen` to use `ApplicationCubit.submitApplication()`
- 🔧 Update `MyApplicationsScreen` to show `ApplicationsLoaded` state
- 🔧 Add status filter (pending, accepted, rejected)
- 🔧 Implement withdraw application

**Deliverables:**

- ✅ Dynamic job listings (no hardcoded data)
- ✅ Working search and filters
- ✅ Functional application submission
- ✅ Application status tracking

---

### **WEEK 3: User Profiles & Saved Jobs** 👤

**Goal:** Profile management and job bookmarking

#### Day 1-2: Student Profile

- 🔧 Update `ProfileScreen` to use `StudentProfileCubit`
- 🔧 Load profile data on screen open
- 🔧 Update `EditProfileScreen` with BLoC
- 🔧 Handle profile update success/error states
- 🔧 Show loading indicators

#### Day 3: Employer Profile

- 🔧 Update `EmployerProfileScreen` with `EmployerProfileCubit`
- 🔧 Update `EditCompanyProfileScreen`
- 🔧 Handle company info updates

#### Day 4-5: Saved Jobs

- 🔧 Update `SavedJobsScreen` with `SavedJobsCubit`
- 🔧 Add bookmark icon to job cards
- 🔧 Implement toggle save/unsave
- 🔧 Show saved status across app
- 🔧 Add empty state for no saved jobs

**Deliverables:**

- ✅ Complete profile view/edit for students
- ✅ Complete profile view/edit for employers
- ✅ Working bookmark system
- ✅ Profile updates persist

---

### **WEEK 4: Employer Features & Notifications** 💼

**Goal:** Employer dashboard, job management, and notifications

#### Day 1-2: Employer Job Management

- 🔧 Update `EmployerDashboardScreen` with `EmployerJobCubit`
- 🔧 Update `CreateJobScreen` to use `createJob()`
- 🔧 Update `EditJobScreen` with `updateJob()`
- 🔧 Implement delete job functionality
- 🔧 Add job status filters

#### Day 3: Employer Application Management

- 🔧 Update `EmployerApplicationsScreen` with `EmployerApplicationCubit`
- 🔧 Update `ReviewApplicationScreen`
- 🔧 Implement accept/reject/shortlist actions
- 🔧 Add status filters for applications

#### Day 4-5: Notifications

- 🔧 Update `NotificationsScreen` with `NotificationCubit`
- 🔧 Add unread count badge in AppBar
- 🔧 Implement mark as read
- 🔧 Implement mark all as read
- 🔧 Add delete notification
- 🔧 Show notifications in real-time

**Deliverables:**

- ✅ Full employer job CRUD operations
- ✅ Application review system working
- ✅ Notification system functional
- ✅ Unread notification indicators

---

### **WEEK 5: Reviews, Education & Admin** 🌟

**Goal:** Complete remaining features and polish

#### Day 1-2: Review System

- 🔧 Update `SubmitReviewScreen` with `ReviewCubit`
- 🔧 Update `ReviewsListScreen`
- 🔧 Show average ratings on profiles
- 🔧 Show rating distribution
- 🔧 Implement edit/delete own reviews

#### Day 3: Education Section

- 🔧 Create `EducationRepository` (if not done)
- 🔧 Update education screens with `EducationCubit`
- 🔧 Implement article browsing
- 🔧 Add search functionality

#### Day 4: Admin Panel

- 🔧 Create `AdminRepository` (if not done)
- 🔧 Update `AdminDashboardScreen` with `AdminCubit`
- 🔧 Implement user management
- 🔧 Implement job moderation
- 🔧 Add statistics dashboard

#### Day 5: Testing & Polish

- 🧪 End-to-end testing of all features
- 🐛 Fix bugs found during testing
- 🎨 Polish UI/UX
- 📝 Update documentation
- ✅ Final code review

**Deliverables:**

- ✅ Complete review system
- ✅ Education section functional
- ✅ Admin panel operational
- ✅ All features tested and working

---

## 📂 Folder Structure

```
lib/
├── main.dart                           # ✅ Updated with MultiBlocProvider
├── core/
│   └── dependency_injection.dart       # ✅ GetIt setup
├── logic/
│   ├── cubits/
│   │   ├── auth/                       # ✅ IMPLEMENTED
│   │   │   ├── auth_cubit.dart
│   │   │   └── auth_state.dart
│   │   ├── job/                        # ✅ IMPLEMENTED
│   │   │   ├── job_cubit.dart
│   │   │   └── job_state.dart
│   │   ├── application/                # ✅ IMPLEMENTED
│   │   │   ├── application_cubit.dart
│   │   │   └── application_state.dart
│   │   ├── student_profile/            # ✅ IMPLEMENTED
│   │   │   ├── student_profile_cubit.dart
│   │   │   └── student_profile_state.dart
│   │   ├── employer_profile/           # ✅ IMPLEMENTED
│   │   │   ├── employer_profile_cubit.dart
│   │   │   └── employer_profile_state.dart
│   │   ├── employer_job/               # ✅ IMPLEMENTED
│   │   │   ├── employer_job_cubit.dart
│   │   │   └── employer_job_state.dart
│   │   ├── employer_application/       # ✅ IMPLEMENTED
│   │   │   ├── employer_application_cubit.dart
│   │   │   └── employer_application_state.dart
│   │   ├── notification/               # ✅ IMPLEMENTED
│   │   │   ├── notification_cubit.dart
│   │   │   └── notification_state.dart
│   │   ├── search/                     # ✅ IMPLEMENTED
│   │   │   ├── search_cubit.dart
│   │   │   └── search_state.dart
│   │   ├── saved_jobs/                 # ✅ IMPLEMENTED
│   │   │   ├── saved_jobs_cubit.dart
│   │   │   └── saved_jobs_state.dart
│   │   ├── review/                     # ✅ IMPLEMENTED
│   │   │   ├── review_cubit.dart
│   │   │   └── review_state.dart
│   │   ├── education/                  # ✅ IMPLEMENTED
│   │   │   ├── education_cubit.dart
│   │   │   └── education_state.dart
│   │   └── admin/                      # ✅ IMPLEMENTED
│   │       ├── admin_cubit.dart
│   │       └── admin_state.dart
│   └── services/
│       └── auth_service.dart           # ⚠️ DEPRECATED - Remove after migration
├── data/
│   ├── models/                         # ✅ All models exist
│   │   ├── user_model.dart
│   │   ├── job_post.dart
│   │   ├── application_model.dart
│   │   ├── student_model.dart
│   │   ├── employer_model.dart
│   │   ├── notification_model.dart
│   │   ├── review_model.dart
│   │   └── education_article_model.dart
│   └── repositories/                   # ✅ All implemented with mock data
│       ├── auth_repo.dart
│       ├── job_repo.dart
│       ├── application_repo.dart
│       ├── user_repo.dart
│       ├── notification_repo.dart
│       └── review_repo.dart
└── views/
    ├── screens/                        # ⚠️ Need to update to use BLoC
    │   ├── auth/
    │   ├── student/
    │   ├── employer/
    │   └── ...
    └── widgets/
```

---

## 🚀 How to Use Cubits in Screens

### 1. Access Cubit (Call Methods)

```dart
// In any screen, call cubit methods using context.read()
context.read<JobCubit>().loadJobs();
context.read<AuthCubit>().login(email: 'test@test.com', password: 'pass123');
context.read<SavedJobsCubit>().saveJob(jobId);
```

### 2. Listen to State Changes (Build UI)

```dart
// Use BlocBuilder to rebuild UI based on state
BlocBuilder<JobCubit, JobState>(
  builder: (context, state) {
    if (state is JobLoading) {
      return CircularProgressIndicator();
    } else if (state is JobLoaded) {
      return ListView.builder(
        itemCount: state.jobs.length,
        itemBuilder: (context, index) {
          return JobCard(job: state.jobs[index]);
        },
      );
    } else if (state is JobError) {
      return Text('Error: ${state.message}');
    }
    return SizedBox.shrink();
  },
)
```

### 3. Listen to State + Perform Actions (Show Snackbars, Navigate)

```dart
// Use BlocConsumer for both UI updates and side effects
BlocConsumer<AuthCubit, AuthState>(
  listener: (context, state) {
    if (state is AuthAuthenticated) {
      // Navigate to home
      context.go('/home');
    } else if (state is AuthError) {
      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
  builder: (context, state) {
    if (state is AuthLoading) {
      return CircularProgressIndicator();
    }
    return LoginForm();
  },
)
```

### 4. Provide Additional Cubits for Specific Screens

```dart
// If a cubit is not globally provided, provide it locally
BlocProvider(
  create: (context) => getIt<EmployerJobCubit>()..loadMyJobs(),
  child: EmployerJobsScreen(),
)
```

---

## 🎯 Quick Start Guide

1. **Run Flutter Pub Get:**

   ```bash
   flutter pub get
   ```

2. **Test App Runs:**

   ```bash
   flutter run
   ```

3. **Start with Week 1 - Authentication:**

   - Open `lib/views/screens/auth/login_screen.dart`
   - Replace `Provider.of<AuthService>` with `context.read<AuthCubit>()`
   - Replace `setState` with cubit method calls
   - Wrap UI in `BlocConsumer<AuthCubit, AuthState>`

4. **Follow the 5-Week Plan:**
   - Complete each week's tasks systematically
   - Test after each major feature
   - Don't skip to later weeks without completing earlier ones

---

## 📚 Resources

- **Flutter BLoC Documentation:** https://bloclibrary.dev/
- **Equatable Package:** https://pub.dev/packages/equatable
- **GetIt Documentation:** https://pub.dev/packages/get_it
- **Go Router (Navigation):** https://pub.dev/packages/go_router

---

## ⚠️ Important Notes

1. **Mock Data:** All repositories currently use mock data. Replace with real API calls.
2. **Error Handling:** Implement proper try-catch blocks in repositories.
3. **Token Management:** AuthRepository saves token but doesn't send with requests yet.
4. **Persistence:** Only auth state persists. Add persistence for other features if needed.
5. **Testing:** Write unit tests for Cubits and integration tests for flows.

---

## 🐛 Known Issues

1. **Model Field Mismatches:** Some repositories have minor field name mismatches with models. Fix during implementation.
2. **EducationCubit:** Repository not created yet - marked as TODO.
3. **AdminCubit:** Repository not created yet - marked as TODO.

---

## ✅ Checklist for Each Screen Migration

- [ ] Remove `setState` calls
- [ ] Remove `Provider.of` or `ChangeNotifierProvider`
- [ ] Wrap UI in `BlocBuilder` or `BlocConsumer`
- [ ] Call cubit methods instead of direct data manipulation
- [ ] Handle all state cases (Initial, Loading, Loaded, Error)
- [ ] Add loading indicators for Loading states
- [ ] Add error messages for Error states
- [ ] Test the feature end-to-end

---

**🎉 All 13 Cubits are ready to use! Start implementing following the 5-week plan above.**
