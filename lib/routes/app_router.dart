import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
import '../views/screens/homescreen/home_screen.dart';
import '../views/screens/jobs/jobs_page.dart';
import '../views/screens/tasks/my_tasks_screen.dart';
import '../views/screens/education/education_list_screen.dart';
import '../views/screens/profile/my_profile_screen.dart';
import '../logic/services/role_based_navigation.dart';
import '../views/screens/profile/edit_student_profile_screen2.dart';
import '../views/screens/employer/create_employer_profile_screen.dart';
import '../views/screens/employer/edit_employer_profile_screen2.dart';
import '../views/screens/notifications/notifications_screen.dart';
import '../views/widgets/navigation/bottom_nav_bar.dart';
import '../views/screens/jobs/job_detail_screen.dart';
import '../views/screens/education/article_detail_screen.dart';
import '../views/screens/employer/my_job_posts_screen.dart';
import '../views/screens/employer/job_post_form_screen.dart';
import '../views/screens/employer/job_post_detail_screen.dart';
import '../views/screens/employer/student_requests_screen.dart';
import '../views/screens/employer/job_applications_screen.dart';
import '../views/screens/employer/student_request_detail_screen.dart';
import '../models/job_post.dart';
import '../models/application.dart';

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

  // Profile routes
  static const String editStudentProfile = '/profile/edit-student';
  static const String createEmployerProfile = '/profile/create-employer';
  static const String editEmployerProfile = '/profile/edit-employer';

  // Job board sub-routes (nested under /tasks for employer)
  static const String myJobPosts = '/tasks/my-posts';
  static const String jobPostForm = '/tasks/post-form';
  static const String jobPostDetail = '/tasks/job';
  static const String jobApplications = '/job-applications';
  static const String studentRequests = '/tasks/requests';
  static const String studentRequestDetail = '/tasks/request';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    restorationScopeId: null,
    routes: [
      // PUBLIC ROUTES (No Bottom Bar)
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

      // PROTECTED ROUTES (With Bottom Bar)
      ShellRoute(
        builder: (context, state, child) {
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
            routes: [
              // My Job Posts List (employer)
              GoRoute(
                path: 'my-posts',
                name: 'my-job-posts',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: MyJobPostsScreen(),
                ),
              ),

              // Job Post Form (Create/Edit)
              GoRoute(
                path: 'post-form',
                name: 'job-post-form',
                builder: (context, state) {
                  final job = state.extra as JobPost?;
                  return JobPostFormScreen(job: job);
                },
              ),

              // Job Post Detail
              GoRoute(
                path: 'job/:id',
                name: 'job-post-detail',
                builder: (context, state) {
                  final job = state.extra as JobPost;
                  return JobPostDetailScreen(job: job);
                },
              ),

//applications for specific job
GoRoute(
  path: '/job-applications/:jobId',
  name: 'jobApplications',
  builder: (context, state) {
    final jobPost = state.extra as JobPost;
    return JobApplicationsScreen(jobPost: jobPost);
  },
),

              // Student Requests List (employer)
              GoRoute(
                path: 'requests',
                name: 'student-requests',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: StudentRequestsScreen(),
                ),
              ),

              // Student Request Detail
              GoRoute(
                path: 'request/:id',
                name: 'student-request-detail',
                builder: (context, state) {
                  final application = state.extra as Application;
                  return StudentRequestDetailScreen(application: application);
                },
              ),
            ],
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
