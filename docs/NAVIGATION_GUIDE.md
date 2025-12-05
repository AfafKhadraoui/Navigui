# Navigation & Bottom Bar Guide

## How It Works

### The Problem You Had:

- Bottom bar was showing on **EVERY** screen (including login/welcome)
- No way to navigate between different screens
- All pages were hardcoded in `IndexedStack`

### The Solution:

**Two-tier routing system using `go_router`:**

1. **Public Routes** (NO bottom bar): Welcome, Onboarding, Login, Register
2. **Protected Routes** (WITH bottom bar): Home, Jobs, Learn, Profile

---

## 📁 File Structure

```
lib/
├── main.dart                      # App entry - uses router
├── routes/
│   └── app_router.dart           # 🎯 ALL ROUTES DEFINED HERE
├── views/
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── login_screen.dart       # NO bottom bar
│   │   │   └── register_screen.dart    # NO bottom bar
│   │   ├── onboarding/
│   │   │   ├── welcome_screen.dart     # NO bottom bar
│   │   │   └── onboarding_screen.dart  # NO bottom bar
│   │   ├── homescreen/
│   │   │   └── home_screen.dart        # WITH bottom bar
│   │   ├── jobs/
│   │   │   └── jobs_page.dart          # WITH bottom bar
│   │   ├── education/
│   │   │   └── education_list_screen.dart  # WITH bottom bar
│   │   └── profile/
│   │       └── my_profile_screen.dart  # WITH bottom bar
│   └── widgets/
│       └── navigation/
│           └── bottom_nav_bar.dart     # The bottom bar widget
```

---

##  How to Use

### Navigate Between Screens

```dart
import 'package:go_router/go_router.dart';
import '../../../routes/app_router.dart';

// Navigate to login (no bottom bar)
context.go(AppRouter.login);

// Navigate to home (with bottom bar)
context.go(AppRouter.home);

// Go back
context.pop();
```

### Available Routes

```dart
// PUBLIC ROUTES (No Bottom Bar)
AppRouter.welcome      // '/'
AppRouter.onboarding   // '/onboarding'
AppRouter.login        // '/login'
AppRouter.register     // '/register'

// PROTECTED ROUTES (With Bottom Bar)
AppRouter.home         // '/home'
AppRouter.jobs         // '/jobs'
AppRouter.learn        // '/learn'
AppRouter.profile      // '/profile'
```

---

## How Bottom Bar Works

### Magic: `ShellRoute`

In `app_router.dart`, the protected routes are wrapped in `ShellRoute`:

```dart
ShellRoute(
  builder: (context, state, child) {
    return RootScaffold(child: child); // Wraps with bottom bar
  },
  routes: [
    GoRoute(path: home, ...),
    GoRoute(path: jobs, ...),
    // etc.
  ],
)
```

This means:

- ✅ `/home`, `/jobs`, `/learn`, `/profile` → **RootScaffold wraps them** → bottom bar shows
- ❌ `/login`, `/register`, `/welcome` → **Not in ShellRoute** → no bottom bar!

---

## 📝 Examples

### Example 1: Login Button

```dart
// In login_screen.dart
ElevatedButton(
  onPressed: () {
    // TODO: Add your authentication logic here

    // After successful login:
    context.go(AppRouter.home); // Now user sees home WITH bottom bar!
  },
  child: const Text('Login'),
)
```

### Example 2: Logout Button

```dart
// In profile_screen.dart or settings
ElevatedButton(
  onPressed: () {
    // TODO: Clear user session/tokens

    // Logout - go back to welcome:
    context.go(AppRouter.welcome); // Back to welcome, no bottom bar
  },
  child: const Text('Logout'),
)
```

### Example 3: Navigate from Home to Job Details

```dart
// In home_screen.dart
ListTile(
  title: Text('Job Title'),
  onTap: () {
    // Option 1: Push (keeps bottom bar)
    context.push('/jobs/${job.id}');

    // Option 2: Go to jobs tab (shows bottom bar)
    context.go(AppRouter.jobs);
  },
)
```

---

## Customizing Routes

### Add New Public Route (No Bottom Bar)

In `app_router.dart`:

```dart
GoRoute(
  path: '/forgot-password',
  name: 'forgot-password',
  builder: (context, state) => const ForgotPasswordScreen(),
),
```

### Add New Protected Route (With Bottom Bar)

In `app_router.dart`, inside `ShellRoute`:

```dart
GoRoute(
  path: '/settings',
  name: 'settings',
  pageBuilder: (context, state) => NoTransitionPage(
    child: const SettingsScreen(),
  ),
),
```

---

##  App Flow

```
1. App Starts
   ↓
2. Welcome Screen (no bottom bar)
   ↓
3. User clicks "Get Started"
   ↓
4. Onboarding Screen (no bottom bar)
   ↓
5. User clicks "Register" or "Login"
   ↓
6. Login/Register Screen (no bottom bar)
   ↓
7. After successful auth → context.go(AppRouter.home)
   ↓
8. Home Screen (WITH bottom bar!)
   ↓
9. User can tap tabs: Jobs, Learn, Profile (all keep bottom bar)
   ↓
10. User clicks "Logout" → context.go(AppRouter.welcome)
   ↓
11. Back to Welcome (no bottom bar)
```

---

## Important Notes

### 1. Initial Route

```dart
// In app_router.dart
initialLocation: AppRouter.welcome,  // App starts at welcome

// To test with home directly:
initialLocation: AppRouter.home,  // Start at home (for development)
```

### 2. Bottom Bar Tab Switching

The bottom bar automatically:

- Highlights current tab based on route
- Switches pages when tapped
- No need to manually manage `IndexedStack`!

### 3. Deep Links

Routes work with deep links too:

```dart
// User opens: myapp://navigui/jobs
// → Opens Jobs page WITH bottom bar

// User opens: myapp://navigui/login
// → Opens Login page WITHOUT bottom bar
```

---

## 🐛 Troubleshooting

### Bottom bar showing on login?

- Check that `/login` route is **outside** `ShellRoute` in `app_router.dart`

### Can't navigate?

```dart
// ✅ Correct:
import 'package:go_router/go_router.dart';
import '../../../routes/app_router.dart';
context.go(AppRouter.home);

// ❌ Wrong:
Navigator.push(context, ...); // Don't use old Navigator
```

### Bottom bar not updating?

- Make sure you're using `context.go()` not `Navigator.push()`
- GoRouter manages state automatically

---

## 📚 Learn More

- GoRouter docs: https://pub.dev/packages/go_router
- ShellRoute: https://pub.dev/documentation/go_router/latest/topics/Configuration-topic.html#shell-routes

---

✅ **You're all set!** The bottom bar now only shows where it should!
