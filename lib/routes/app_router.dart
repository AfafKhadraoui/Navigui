// lib/routes/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../views/screens/onboarding/splash_screen.dart';
import '../views/screens/auth/login.dart';
import '../views/screens/auth/AccountType.dart';
import '../views/screens/auth/step1Student.dart';
import '../views/screens/auth/step2Student.dart';
import '../views/screens/auth/step3Student.dart';
import '../views/screens/auth/step4StudentSkills.dart';
import '../views/screens/auth/step5Student.dart';
import '../views/screens/auth/step1Employer.dart';
import '../views/screens/auth/step2Employer.dart';
import '../views/screens/auth/step3Employer.dart';
import '../views/screens/auth/step4Employer.dart';
import '../views/screens/onboarding/onboarding_screen.dart';
import '../views/screens/notifications/notifications_screen.dart';
import '../views/widgets/navigation/bottom_nav_bar.dart';

// Job board screens
import '../views/screens/tasks/employer/employer_dashboard_screen.dart';
import '../views/screens/tasks/employer/create_job_screen.dart';
import '../views/screens/tasks/employer/job_detail_employer_screen.dart';
import '../views/screens/tasks/employer/job_requests_screen.dart';
import '../views/screens/tasks/employer/request_detail_screen.dart';

import '../logic/models/job_post.dart';
import '../logic/models/application.dart';
import '../logic/services/auth_service.dart';
import '../logic/services/role_based_navigation.dart';
import '../views/screens/profile/edit_student_profile_screen2.dart';
import '../views/screens/employer/create_employer_profile_screen.dart';
import '../views/screens/employer/edit_employer_profile_screen2.dart';
import '../views/screens/jobs/job_detail_screen.dart';
import '../views/screens/education/article_detail_screen.dart';

// Admin screens
import '../views/screens/admin/admin_users_screen.dart';
import '../views/screens/admin/admin_jobs_screen.dart';
import '../views/screens/admin/admin_reports_screen.dart';
import '../views/screens/admin/admin_settings_screen.dart';

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
  static const String accountType = '/account-type';

  // Student signup steps
  static const String studentStep1 = '/signup/student/step1';
  static const String studentStep2 = '/signup/student/step2';
  static const String studentStep3 = '/signup/student/step3';
  static const String studentStep4 = '/signup/student/step4';
  static const String studentStep5 = '/signup/student/step5';

  // Employer signup steps
  static const String employerStep1 = '/signup/employer/step1';
  static const String employerStep2 = '/signup/employer/step2';
  static const String employerStep3 = '/signup/employer/step3';
  static const String employerStep4 = '/signup/employer/step4';

  // Main app routes (with bottom bar) - 5 tabs
  static const String home = '/home';
  static const String jobs = '/jobs';
  static const String jobDetails = '/jobs/:id'; // New route for job details
  static const String tasks = '/tasks';
  static const String learn = '/learn';
  static const String profile = '/profile';

  // Additional routes
  static const String notifications = '/notifications';


  // Job board sub-routes (nested under /tasks)
  static const String myJobPosts = '/tasks/my-posts';
  static const String jobPostForm = '/tasks/post-form';
  static const String jobPostDetail = '/tasks/job';
  static const String studentRequests = '/tasks/requests';
  static const String studentRequestDetail = '/tasks/request';
  // Profile routes
  static const String editStudentProfile = '/profile/edit-student';
  static const String createEmployerProfile = '/profile/create-employer';
  static const String editEmployerProfile = '/profile/edit-employer';

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
        builder: (context, state) => const LoginScreen2(),
      ),

      GoRoute(
        path: accountType,
        name: 'account-type',
        builder: (context, state) => const AccountTypeScreen(),
      ),

      // Student signup steps
      GoRoute(
        path: studentStep1,
        name: 'student-step1',
        builder: (context, state) => const Step1StudentScreen(),
      ),

      GoRoute(
        path: studentStep2,
        name: 'student-step2',
        builder: (context, state) => const Step2StudentScreen(),
      ),

      GoRoute(
        path: studentStep3,
        name: 'student-step3',
        builder: (context, state) => const Step3StudentScreen(),
      ),

      GoRoute(
        path: studentStep4,
        name: 'student-step4',
        builder: (context, state) => const Step4StudentSkillsScreen(),
      ),

      GoRoute(
        path: studentStep5,
        name: 'student-step5',
        builder: (context, state) => const Step5StudentScreen(),
      ),

      // Employer signup steps
      GoRoute(
        path: employerStep1,
        name: 'employer-step1',
        builder: (context, state) => const Step1EmployerScreen(),
      ),

      GoRoute(
        path: employerStep2,
        name: 'employer-step2',
        builder: (context, state) => const Step2EmployerScreen(),
      ),

      GoRoute(
        path: employerStep3,
        name: 'employer-step3',
        builder: (context, state) => const Step3EmployerScreen(),
      ),

      GoRoute(
        path: employerStep4,
        name: 'employer-step4',
        builder: (context, state) => const Step4EmployerScreen(),
      ),

      GoRoute(
        path: notifications,
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),

 // Profile management routes (outside bottom nav)
      GoRoute(
        path: editStudentProfile,
        name: 'edit-student-profile',
        builder: (context, state) => const EditStudentProfileScreen(),
      ),

      GoRoute(
        path: createEmployerProfile,
        name: 'create-employer-profile',
        builder: (context, state) => const CreateEmployerProfileScreen(),
      ),

      GoRoute(
        path: editEmployerProfile,
        name: 'edit-employer-profile',
        builder: (context, state) => const EditEmployerProfileScreen2(),
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
            pageBuilder: (context, state) => NoTransitionPage(
              child: RoleBasedNavigation.getHomeScreen(),
            ),
          ),

          // Jobs routes
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
          GoRoute(
            path: profile,
            name: 'profile',
            pageBuilder: (context, state) => NoTransitionPage(
              child: RoleBasedNavigation.getProfileScreen(),
            ),
          ),

          // ============================================
          // ADMIN ROUTES (Admin Dashboard Navigation)
          // ============================================
          
          GoRoute(
            path: '/admin/users',
            name: 'admin-users',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AdminUsersScreen(),
            ),
          ),

          GoRoute(
            path: '/admin/jobs',
            name: 'admin-jobs',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AdminJobsScreen(),
            ),
          ),

          GoRoute(
            path: '/admin/reports',
            name: 'admin-reports',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AdminReportsScreen(),
            ),
          ),

          GoRoute(
            path: '/admin/settings',
            name: 'admin-settings',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AdminSettingsScreen(),
            ),
          ),

          // ============================================
          // JOB BOARD SUB-ROUTES (Nested under tasks)
          // ============================================

          // My Job Posts List
          GoRoute(
            path: myJobPosts,
            name: 'my-job-posts',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: EmployerDashboardScreen(),
            ),
          ),

          // Job Post Form (Create/Edit)
          GoRoute(
            path: jobPostForm,
            name: 'job-post-form',
            builder: (context, state) {
              final job = state.extra as JobPost?;
              return CreateJobScreen(job: job);
            },
          ),

          // Job Post Detail
          GoRoute(
            path: '$jobPostDetail/:id',
            name: 'job-post-detail',
            builder: (context, state) {
              final job = state.extra as JobPost;
              return JobDetailEmployerScreen(job: job);
            },
          ),

          // Student Requests List
          GoRoute(
            path: studentRequests,
            name: 'student-requests',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: JobRequestsScreen(),
            ),
          ),

          // Student Request Detail
          GoRoute(
            path: '$studentRequestDetail/:id',
            name: 'student-request-detail',
            builder: (context, state) {
              final application = state.extra as Application;
              return RequestDetailScreen(application: application);
            },
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
    final authService = context.watch<AuthService>();
    final isAdmin = authService.currentUser?.accountType == 'admin';

    if (isAdmin) {
      // Admin has 4 tabs: Dashboard (0), Users (1), Jobs (2), Settings (3)
      if (location.startsWith(AppRouter.home)) return 0;
      if (location.startsWith('/admin/users')) return 1;
      if (location.startsWith('/admin/jobs')) return 2;
      if (location.startsWith('/admin/settings')) return 3;
      return 0;
    } else {
      // Student/Employer have 5 tabs
      if (location.startsWith(AppRouter.home)) return 0;
      if (location.startsWith(AppRouter.jobs)) return 1;
      if (location.startsWith(AppRouter.tasks)) return 2;
      if (location.startsWith(AppRouter.learn)) return 3;
      if (location.startsWith(AppRouter.profile)) return 4;
      return 0;
    }
  }

  void _onItemTapped(int index) {
    final authService = context.read<AuthService>();
    final isAdmin = authService.currentUser?.accountType == 'admin';

    if (isAdmin) {
      // Admin navigation: Dashboard, Users, Jobs, Settings
      switch (index) {
        case 0:
          context.go(AppRouter.home); // Admin Dashboard
          break;
        case 1:
          context.go('/admin/users'); // Admin Users
          break;
        case 2:
          context.go('/admin/jobs'); // Admin Jobs
          break;
        case 3:
          context.go('/admin/settings'); // Admin Settings
          break;
      }
    } else {
      // Student/Employer navigation: Home, Jobs, Tasks, Learn, Profile
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
