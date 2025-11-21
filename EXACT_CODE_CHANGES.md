# Exact Code Changes Needed

## 1. Update pubspec.yaml

Add this dependency:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  google_fonts: ^6.1.0
  go_router: ^14.0.0
  url_launcher: ^6.2.5
  provider: ^6.1.1 # ADD THIS LINE
```

Then run: `flutter pub get`

---

## 2. Update lib/main.dart

**Replace entire file with:**

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      title: 'NavigUI',
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
  }
}
```

---

## 3. Update lib/routes/app_router.dart

**Add import at top:**

```dart
import '../logic/services/role_based_navigation.dart';
```

**Replace the 5 routes in ShellRoute with:**

```dart
ShellRoute(
  builder: (context, state, child) {
    return RootScaffold(child: child);
  },
  routes: [
    // HOME - Role-based
    GoRoute(
      path: home,
      name: 'home',
      pageBuilder: (context, state) => NoTransitionPage(
        child: RoleBasedNavigation.getHomeScreen(),
      ),
    ),

    // BROWSE/JOBS - Role-based
    GoRoute(
      path: jobs,
      name: 'jobs',
      pageBuilder: (context, state) => NoTransitionPage(
        child: RoleBasedNavigation.getBrowseScreen(),
      ),
      routes: [
        GoRoute(
          path: 'details/:id',
          name: 'jobDetails',
          builder: (context, state) {
            final job = state.extra as Map<String, dynamic>;
            return JobDetailsScreen(job: job);
          },
        ),
      ],
    ),

    // TASKS/APPLICATIONS - Role-based
    GoRoute(
      path: tasks,
      name: 'tasks',
      pageBuilder: (context, state) => NoTransitionPage(
        child: RoleBasedNavigation.getTasksScreen(),
      ),
    ),

    // LEARN - Shared
    GoRoute(
      path: learn,
      name: 'learn',
      pageBuilder: (context, state) => NoTransitionPage(
        child: RoleBasedNavigation.getLearnScreen(),
      ),
      routes: [
        GoRoute(
          path: 'article/:id',
          name: 'article',
          builder: (context, state) {
            final articleId = state.pathParameters['id'] ?? '';
            return EducationArticleScreen(articleId: articleId);
          },
        ),
      ],
    ),

    // PROFILE - Role-based
    GoRoute(
      path: profile,
      name: 'profile',
      pageBuilder: (context, state) => NoTransitionPage(
        child: RoleBasedNavigation.getProfileScreen(),
      ),
    ),
  ],
),
```

---

## 4. Update Login Screen

**File: lib/views/screens/auth/login.dart**

**Add imports at top:**

```dart
import 'package:provider/provider.dart';
import '../../../logic/services/auth_service.dart';
```

**Update the login button's onPressed method:**

```dart
ElevatedButton(
  onPressed: () async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Call auth service
    final authService = context.read<AuthService>();
    final success = await authService.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    // Hide loading
    if (context.mounted) Navigator.pop(context);

    if (success) {
      // Navigate to home
      if (context.mounted) context.go('/home');
    } else {
      // Show error
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login failed. Please try again.'),
          ),
        );
      }
    }
  },
  child: const Text('Log In'),
),
```

---

## 5. Update Student Signup Final Step

**File: lib/views/screens/auth/step5Student.dart**

**Add imports at top:**

```dart
import 'package:provider/provider.dart';
import '../../../logic/services/auth_service.dart';
```

**Update the "Continue" button to call signup:**

```dart
void _handleContinue() async {
  // Get auth service
  final authService = context.read<AuthService>();

  // TODO: Get actual data from previous steps
  // For now using placeholder data
  await authService.signup(
    email: 'student@example.com', // Get from step1
    password: 'password123',      // Get from step1
    name: 'Student Name',         // Get from step2
    phoneNumber: '+213XXXXXXXXX', // Get from step2
    location: 'Alger',            // Get from step2
    accountType: 'student',
  );

  // Navigate to success dialog, then home
  if (mounted) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => SignupSuccessDialog(
          userName: 'Student Name',
          isStudent: true,
          onGoToDashboard: () {
            context.go('/home');
          },
          onStartOver: () {
            context.go('/signup/student/step1');
          },
        ),
      ),
    );
  }
}
```

---

## 6. Update Employer Signup Final Step

**File: lib/views/screens/auth/step4Employer.dart**

**Add imports at top:**

```dart
import 'package:provider/provider.dart';
import '../../../logic/services/auth_service.dart';
```

**Update the "Continue" button to call signup:**

```dart
void _handleContinue() async {
  // Get auth service
  final authService = context.read<AuthService>();

  // TODO: Get actual data from previous steps
  await authService.signup(
    email: 'employer@example.com', // Get from step1
    password: 'password123',       // Get from step1
    name: 'Company Name',          // Get from step2
    phoneNumber: '+213XXXXXXXXX',  // Get from step2
    location: 'Alger',             // Get from step2
    accountType: 'employer',
  );

  // Navigate to success dialog, then home
  if (mounted) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => SignupSuccessDialog(
          userName: 'Company Name',
          isStudent: false,
          onGoToDashboard: () {
            context.go('/home');
          },
          onStartOver: () {
            context.go('/signup/employer/step1');
          },
        ),
      ),
    );
  }
}
```

---

## 7. (Optional) Update Bottom Nav Labels

**File: lib/views/widgets/navigation/bottom_nav_bar.dart**

**Add import:**

```dart
import '../../../logic/services/role_based_navigation.dart';
```

**Update items to use dynamic labels:**

```dart
items: [
  BottomNavigationBarItem(
    icon: const Icon(Icons.home_outlined),
    activeIcon: const Icon(Icons.home),
    label: RoleBasedNavigation.getNavLabel(0),
  ),
  BottomNavigationBarItem(
    icon: const Icon(Icons.work_outline),
    activeIcon: const Icon(Icons.work),
    label: RoleBasedNavigation.getNavLabel(1),
  ),
  BottomNavigationBarItem(
    icon: const Icon(Icons.task_alt_outlined),
    activeIcon: const Icon(Icons.task_alt),
    label: RoleBasedNavigation.getNavLabel(2),
  ),
  BottomNavigationBarItem(
    icon: const Icon(Icons.school_outlined),
    activeIcon: const Icon(Icons.school),
    label: RoleBasedNavigation.getNavLabel(3),
  ),
  BottomNavigationBarItem(
    icon: const Icon(Icons.person_outline),
    activeIcon: const Icon(Icons.person),
    label: RoleBasedNavigation.getNavLabel(4),
  ),
],
```

---

## 8. (Optional) Add Route Guards

**File: lib/routes/app_router.dart**

**Update GoRouter initialization:**

```dart
static final GoRouter router = GoRouter(
  initialLocation: splash,
  restorationScopeId: null,
  redirect: (BuildContext context, GoRouterState state) {
    // This requires Provider in scope
    // For now, skip this until Provider is set up
    return null;
  },
  routes: [
    // ... existing routes
  ],
);
```

---

## Testing Steps

### 1. Student Flow

```
1. Run app
2. Choose "Student" account type
3. Complete 5 signup steps
4. Verify you land on student HomeScreen
5. Navigate tabs: Home → Jobs → Tasks → Learn → Profile
6. Confirm all screens are student versions
```

### 2. Employer Flow

```
1. Run app
2. Choose "Employer" account type
3. Complete 4 signup steps
4. Verify you land on EmployerHomeScreen (with statistics)
5. Navigate tabs: Home → My Jobs → Applications → Learn → Profile
6. Confirm employer screens appear
```

### 3. Login Test

```
1. Login with test credentials
2. Backend should return accountType: 'student' or 'employer'
3. Verify correct interface loads
```

---

## That's It!

After making these changes:

- ✅ Students see student interface
- ✅ Employers see employer interface
- ✅ Navigation works automatically based on role
- ✅ Login/signup properly stores user role

## Next Steps

1. **Pass data between signup steps**

   - Store form data in a Provider or StatefulWidget
   - Pass to AuthService.signup() at the end

2. **Connect to real backend**

   - Replace mock login/signup in AuthService
   - Get user role from API response

3. **Add persistence**

   - Use `shared_preferences` to save login state
   - Auto-login on app restart if token valid

4. **Implement employer screens fully**
   - Add real statistics to EmployerHomeScreen
   - Build job posting form in EmployerJobsScreen
   - Add application cards to EmployerApplicationsScreen
