# Role-Based Access Control Implementation Guide

## Overview

This guide explains how to implement restricted access in your Flutter app so that students and employers see different interfaces after login/signup.

## Architecture

### 1. User Model (`user_model.dart`)

- Contains `accountType` field with values: `'student'` or `'employer'`
- Base model for all users

### 2. Auth Service (`logic/services/auth_service.dart`)

- **Purpose**: Manages authentication state and user role
- **Key Features**:
  - Singleton pattern (accessible throughout the app)
  - Stores current user
  - Provides role checks: `isStudent`, `isEmployer`
  - Login, signup, and logout methods

### 3. Role-Based Navigation (`logic/services/role_based_navigation.dart`)

- **Purpose**: Returns correct screen based on user role
- **Key Methods**:
  - `getHomeScreen()` - Student home OR employer dashboard
  - `getBrowseScreen()` - Job listings OR employer's posted jobs
  - `getTasksScreen()` - Student tasks OR employer applications
  - `getLearnScreen()` - Shared education content
  - `getProfileScreen()` - Student OR employer profile

### 4. Screen Mapping

| Tab         | Student Screen             | Employer Screen                             |
| ----------- | -------------------------- | ------------------------------------------- |
| **Home**    | `HomeScreen`               | `EmployerHomeScreen` (statistics)           |
| **Browse**  | `JobsPage` (browse jobs)   | `EmployerJobsScreen` (manage posts)         |
| **Tasks**   | `MyTasksScreen` (schedule) | `EmployerApplicationsScreen` (applications) |
| **Learn**   | `EducationListScreen`      | `EducationListScreen` (shared)              |
| **Profile** | `MyProfileScreen`          | `EmployerProfileScreen`                     |

## Implementation Steps

### Step 1: Update Main App with AuthService

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Add provider package
import 'logic/services/auth_service.dart';
import 'routes/app_router.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
    );
  }
}
```

### Step 2: Update Signup Flow to Store User Role

In each final signup step:

```dart
// lib/views/screens/auth/step5Student.dart (or step4Employer.dart)
void _handleSignupComplete() async {
  final authService = context.read<AuthService>();

  await authService.signup(
    email: _emailFromPreviousStep,
    password: _passwordFromPreviousStep,
    name: _nameFromPreviousStep,
    phoneNumber: _phoneFromPreviousStep,
    location: _locationFromPreviousStep,
    accountType: 'student', // OR 'employer'
  );

  // Navigate to home
  context.go('/home');
}
```

### Step 3: Update Login Screen

```dart
// lib/views/screens/auth/login.dart
void _handleLogin() async {
  final authService = context.read<AuthService>();

  final success = await authService.login(
    _emailController.text,
    _passwordController.text,
  );

  if (success) {
    context.go('/home');
  }
}
```

### Step 4: Update Router with Role-Based Navigation

```dart
// lib/routes/app_router.dart
import '../logic/services/role_based_navigation.dart';

// In ShellRoute:
GoRoute(
  path: home,
  name: 'home',
  pageBuilder: (context, state) => NoTransitionPage(
    child: RoleBasedNavigation.getHomeScreen(),
  ),
),
GoRoute(
  path: jobs,
  name: 'jobs',
  pageBuilder: (context, state) => NoTransitionPage(
    child: RoleBasedNavigation.getBrowseScreen(),
  ),
),
GoRoute(
  path: tasks,
  name: 'tasks',
  pageBuilder: (context, state) => NoTransitionPage(
    child: RoleBasedNavigation.getTasksScreen(),
  ),
),
GoRoute(
  path: learn,
  name: 'learn',
  pageBuilder: (context, state) => NoTransitionPage(
    child: RoleBasedNavigation.getLearnScreen(),
  ),
),
GoRoute(
  path: profile,
  name: 'profile',
  pageBuilder: (context, state) => NoTransitionPage(
    child: RoleBasedNavigation.getProfileScreen(),
  ),
),
```

### Step 5: Update Bottom Navigation Labels (Optional)

```dart
// lib/views/widgets/navigation/bottom_nav_bar.dart
import '../../../logic/services/role_based_navigation.dart';

// In items:
items: [
  BottomNavigationBarItem(
    icon: Icon(Icons.home_outlined),
    label: RoleBasedNavigation.getNavLabel(0),
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.work_outline),
    label: RoleBasedNavigation.getNavLabel(1),
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.task_alt_outlined),
    label: RoleBasedNavigation.getNavLabel(2),
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.school_outlined),
    label: RoleBasedNavigation.getNavLabel(3),
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.person_outline),
    label: RoleBasedNavigation.getNavLabel(4),
  ),
],
```

### Step 6: Add Route Guards (Optional but Recommended)

```dart
// lib/routes/app_router.dart
GoRouter(
  redirect: (context, state) {
    final authService = context.read<AuthService>();
    final location = state.matchedLocation;

    // Public routes
    if (location.startsWith('/login') ||
        location.startsWith('/signup') ||
        location.startsWith('/splash')) {
      return null; // Allow access
    }

    // Protected routes require authentication
    if (!authService.isAuthenticated) {
      return '/login';
    }

    return null; // Allow access
  },
  // ... rest of router config
)
```

## Required Dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  go_router: ^14.0.0 # Already installed
  provider: ^6.1.1 # Add this for state management
```

Run: `flutter pub get`

## Usage Examples

### Check User Role Anywhere in the App

```dart
import 'package:provider/provider.dart';
import 'logic/services/auth_service.dart';

// In any widget:
final authService = context.watch<AuthService>();

if (authService.isStudent) {
  // Show student-specific content
} else if (authService.isEmployer) {
  // Show employer-specific content
}
```

### Access Current User

```dart
final authService = context.read<AuthService>();
final user = authService.currentUser;

print('User: ${user?.name}');
print('Role: ${user?.accountType}');
```

### Logout

```dart
void _handleLogout() {
  context.read<AuthService>().logout();
  context.go('/login');
}
```

## Testing

### Test Student Flow:

1. Sign up as student
2. Login with student credentials
3. Verify you see: HomeScreen, JobsPage, MyTasksScreen

### Test Employer Flow:

1. Sign up as employer
2. Login with employer credentials
3. Verify you see: EmployerHomeScreen, EmployerJobsScreen, EmployerApplicationsScreen

## Next Steps

1. **Implement the 3 placeholder employer screens**:

   - `EmployerHomeScreen` - Add real statistics
   - `EmployerJobsScreen` - Add job post list and create job flow
   - `EmployerApplicationsScreen` - Add application cards with accept/reject

2. **Add persistence**:

   - Use `shared_preferences` or `secure_storage` to save login state
   - Persist user data across app restarts

3. **Connect to backend**:

   - Replace mock login/signup in `AuthService`
   - Call your actual API endpoints
   - Store JWT tokens

4. **Add loading states**:
   - Show loading spinner during authentication
   - Handle errors gracefully

## File Structure

```
lib/
├── logic/
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── student_model.dart
│   │   └── employer_model.dart
│   └── services/
│       ├── auth_service.dart          ✅ NEW
│       └── role_based_navigation.dart  ✅ NEW
├── views/
│   └── screens/
│       ├── employer/
│       │   ├── employer_home_screen.dart          ✅ NEW
│       │   ├── employer_jobs_screen.dart          ✅ NEW
│       │   ├── employer_applications_screen.dart  ✅ NEW
│       │   └── employer_profile_screen.dart       (exists)
│       ├── homescreen/
│       │   └── home_screen.dart          (student)
│       ├── jobs/
│       │   └── jobs_page.dart            (student)
│       ├── tasks/
│       │   └── my_tasks_screen.dart      (student)
│       └── profile/
│           └── my_profile_screen.dart    (student)
└── routes/
    └── app_router.dart                   (update this)
```

## Summary

✅ **Created Files**:

- `auth_service.dart` - Manages authentication and user role
- `role_based_navigation.dart` - Returns screens based on role
- `employer_home_screen.dart` - Employer dashboard
- `employer_jobs_screen.dart` - Employer job management
- `employer_applications_screen.dart` - Employer applications view

📝 **Files to Update**:

- `main.dart` - Add Provider wrapper
- `app_router.dart` - Use RoleBasedNavigation methods
- `step5Student.dart` & `step4Employer.dart` - Call authService.signup()
- `login.dart` - Call authService.login()
- `pubspec.yaml` - Add provider package

🎯 **Result**: Students and employers will automatically see their respective interfaces after login/signup!
