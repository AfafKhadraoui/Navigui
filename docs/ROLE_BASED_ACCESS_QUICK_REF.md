# Role-Based Access Control - Quick Reference

## Flow Diagram

```
┌──────────────────────────────────────────────────────────────┐
│                       APP STARTUP                             │
│                          ↓                                    │
│                   Splash Screen                               │
│                          ↓                                    │
│                   Login/Signup                                │
└──────────────────────────────────────────────────────────────┘
                           ↓
                    Account Type?
                     /          \
              STUDENT            EMPLOYER
                 ↓                   ↓
       ┌─────────────────┐   ┌──────────────────┐
       │  Student Signup │   │  Employer Signup │
       │   (5 Steps)     │   │   (4 Steps)      │
       └─────────────────┘   └──────────────────┘
                 ↓                   ↓
         Save: accountType='student' OR accountType='employer'
                          ↓
                    AuthService
          ┌──────────────┴──────────────┐
          │  Stores current user role   │
          │  - isStudent                │
          │  - isEmployer               │
          └──────────────┬──────────────┘
                         ↓
              RoleBasedNavigation
          ┌──────────────┴──────────────┐
          │  Returns correct screen     │
          │  based on user role         │
          └──────────────┬──────────────┘
                         ↓
    ┌───────────────────────────────────────┐
    │         BOTTOM NAVIGATION             │
    ├───────────────────────────────────────┤
    │  Home  │  Browse │ Tasks │ Learn │ Profile │
    └────┬───┴────┬────┴───┬───┴───┬───┴────┬───┘
         ↓        ↓        ↓       ↓        ↓
    ┌────────────────────────────────────────────────────┐
    │              STUDENT INTERFACE                      │
    ├────────────────────────────────────────────────────┤
    │  Home          → HomeScreen (job feed)             │
    │  Browse        → JobsPage (search jobs)            │
    │  Tasks         → MyTasksScreen (schedule)          │
    │  Learn         → EducationListScreen               │
    │  Profile       → MyProfileScreen                   │
    └────────────────────────────────────────────────────┘

    ┌────────────────────────────────────────────────────┐
    │             EMPLOYER INTERFACE                      │
    ├────────────────────────────────────────────────────┤
    │  Home          → EmployerHomeScreen (statistics)   │
    │  My Jobs       → EmployerJobsScreen (manage posts) │
    │  Applications  → EmployerApplicationsScreen        │
    │  Learn         → EducationListScreen               │
    │  Profile       → EmployerProfileScreen             │
    └────────────────────────────────────────────────────┘
```

## Key Components

### 1. AuthService (Singleton)

```dart
AuthService()
  ├── currentUser: UserModel?
  ├── isAuthenticated: bool
  ├── isStudent: bool
  ├── isEmployer: bool
  ├── login(email, password)
  ├── signup(...)
  └── logout()
```

### 2. RoleBasedNavigation

```dart
RoleBasedNavigation
  ├── getHomeScreen()      → Student or Employer home
  ├── getBrowseScreen()    → Jobs or My Jobs
  ├── getTasksScreen()     → Tasks or Applications
  ├── getLearnScreen()     → Shared education
  ├── getProfileScreen()   → Student or Employer profile
  └── getNavLabel(index)   → Dynamic labels
```

## Implementation Checklist

### Phase 1: Setup (15 minutes)

- [x] Create `auth_service.dart`
- [x] Create `role_based_navigation.dart`
- [x] Create 3 employer screens (placeholder)
- [ ] Add `provider` to `pubspec.yaml`
- [ ] Run `flutter pub get`

### Phase 2: Integration (30 minutes)

- [ ] Wrap app in ChangeNotifierProvider in `main.dart`
- [ ] Update `app_router.dart` to use `RoleBasedNavigation`
- [ ] Update `step5Student.dart` to call `authService.signup()`
- [ ] Update `step4Employer.dart` to call `authService.signup()`
- [ ] Update `login.dart` to call `authService.login()`

### Phase 3: Testing (15 minutes)

- [ ] Test student signup → verify student screens
- [ ] Test employer signup → verify employer screens
- [ ] Test login for both roles
- [ ] Test navigation between tabs

### Phase 4: Enhancement (Optional)

- [ ] Add route guards (redirect unauthorized users)
- [ ] Add persistence with shared_preferences
- [ ] Connect to real backend API
- [ ] Add loading states and error handling

## Quick Code Snippets

### Access Auth Anywhere

```dart
// Read once (in methods)
final authService = context.read<AuthService>();

// Watch for changes (in build)
final authService = context.watch<AuthService>();

// Check role
if (authService.isStudent) { /* ... */ }
```

### Update Router

```dart
// Before:
pageBuilder: (context, state) => NoTransitionPage(
  child: HomeScreen(),
),

// After:
pageBuilder: (context, state) => NoTransitionPage(
  child: RoleBasedNavigation.getHomeScreen(),
),
```

### Signup Integration

```dart
await context.read<AuthService>().signup(
  email: email,
  password: password,
  name: name,
  phoneNumber: phone,
  location: location,
  accountType: 'student', // or 'employer'
);
```

## Common Issues & Solutions

### Issue: "Provider not found"

**Solution**: Make sure `main.dart` wraps app in `ChangeNotifierProvider`

### Issue: Both roles see same screens

**Solution**: Check `app_router.dart` uses `RoleBasedNavigation.getXScreen()`

### Issue: User logged out after restart

**Solution**: Add persistence with `shared_preferences` in `AuthService`

### Issue: Can't access user in widget

**Solution**: Use `context.watch<AuthService>()` or `context.read<AuthService>()`

## File Locations

```
✅ Already Created:
- lib/logic/services/auth_service.dart
- lib/logic/services/role_based_navigation.dart
- lib/views/screens/employer/employer_home_screen.dart
- lib/views/screens/employer/employer_jobs_screen.dart
- lib/views/screens/employer/employer_applications_screen.dart

📝 Need to Update:
- pubspec.yaml (add provider package)
- lib/main.dart (wrap with Provider)
- lib/routes/app_router.dart (use RoleBasedNavigation)
- lib/views/screens/auth/step5Student.dart (call signup)
- lib/views/screens/auth/step4Employer.dart (call signup)
- lib/views/screens/auth/login.dart (call login)
```

## Summary

✨ **What You Get**:

- Automatic screen selection based on user role
- Student sees: Job browsing, tasks, schedule
- Employer sees: Statistics, job management, applications
- Shared: Education content
- Clean separation of concerns

🔒 **Security**:

- Role stored in UserModel
- Managed by AuthService singleton
- Optional route guards for extra protection

🚀 **Easy to Extend**:

- Add new roles (e.g., 'admin')
- Add role-specific features easily
- Modify screens per role without conflicts
