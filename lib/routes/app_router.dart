import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../views/screens/onboarding/splash_screen.dart';
import '../views/screens/auth/login_screen.dart';
import '../views/screens/auth/register_screen.dart';
import '../views/screens/onboarding/onboarding_screen.dart';
import '../views/screens/homescreen/home_screen.dart';
import '../views/screens/jobs/jobs_page.dart';
import '../views/screens/tasks/my_tasks_screen.dart';
import '../views/screens/education/education_list_screen.dart';
import '../views/screens/profile/my_profile_screen.dart';
import '../views/screens/notifications/notifications_screen.dart';
import '../views/widgets/navigation/bottom_nav_bar.dart';

/// App Router Configuration
///
/// Two types of routes:
/// 1. Public routes (splash, welcome, login, register) - NO bottom bar
/// 2. Protected routes (home, jobs, tasks, learn, profile) - WITH bottom bar
///
/// Navigation Structure (5 tabs):
/// - Home: Main feed with job recommendations
/// - Browse Jobs: Full job listings with search/filter
/// - My Tasks: Student view (applied jobs) | Employer view (posted jobs & applicants)
/// - Learn: Educational content
/// - Profile: User settings
///
/// How it works:
/// - ShellRoute wraps protected pages with RootScaffold (bottom bar)
/// - Public pages are outside ShellRoute (no bottom bar)
class AppRouter {
  // Route names as constants
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';

  // Main app routes (with bottom bar) - 5 tabs
  static const String home = '/home';
  static const String jobs = '/jobs';
  static const String tasks = '/tasks';
  static const String learn = '/learn';
  static const String profile = '/profile';

  // Additional routes
  static const String notifications = '/notifications';

  static final GoRouter router = GoRouter(
    initialLocation: splash, // Start at splash screen
    restorationScopeId:
        null, // Disable state restoration to always start at splash
    routes: [
      // ============================================
      // PUBLIC ROUTES (No Bottom Bar)
      // ============================================

      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
        path: onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      GoRoute(
        path: notifications,
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),

      // ============================================
      // PROTECTED ROUTES (With Bottom Bar)
      // ============================================

      ShellRoute(
        builder: (context, state, child) {
          // This wraps all child routes with the bottom navigation bar
          return RootScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: home,
            name: 'home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: jobs,
            name: 'jobs',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: JobsPage(),
            ),
          ),
          GoRoute(
            path: tasks,
            name: 'tasks',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: MyTasksScreen(),
            ),
          ),
          GoRoute(
            path: learn,
            name: 'learn',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: EducationListScreen(),
            ),
          ),
          GoRoute(
            path: profile,
            name: 'profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: MyProfileScreen(),
            ),
          ),
        ],
      ),
    ],
  );
}

/// Root scaffold that contains the bottom navigation bar
/// Now receives child from ShellRoute instead of using IndexedStack
class RootScaffold extends StatefulWidget {
  final Widget child;

  const RootScaffold({
    super.key,
    required this.child,
  });

  @override
  State<RootScaffold> createState() => _RootScaffoldState();
}

class _RootScaffoldState extends State<RootScaffold> {
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;

    if (location.startsWith(AppRouter.home)) return 0;
    if (location.startsWith(AppRouter.jobs)) return 1;
    if (location.startsWith(AppRouter.tasks)) return 2;
    if (location.startsWith(AppRouter.learn)) return 3;
    if (location.startsWith(AppRouter.profile)) return 4;

    return 0;
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        context.go(AppRouter.home);
        break;
      case 1:
        context.go(AppRouter.jobs);
        break;
      case 2:
        context.go(AppRouter.tasks);
        break;
      case 3:
        context.go(AppRouter.learn);
        break;
      case 4:
        context.go(AppRouter.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: _onItemTapped,
      ),
    );
  }
}
