import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';
import '../../views/screens/homescreen/home_screen.dart';
import '../../views/screens/jobs/jobs_page.dart';
import '../../views/screens/tasks/my_tasks_screen.dart';
import '../../views/screens/education/education_list_screen.dart';
import '../../views/screens/profile/my_profile_screen.dart';

// Employer screens (create these as needed)
import '../../views/screens/employer/employer_home_screen.dart';
import '../../views/screens/employer/employer_jobs_screen.dart';
import '../../views/screens/employer/employer_applications_screen.dart';
import '../../views/screens/profile/employer_profile_screen.dart';

// Admin screens
import '../../views/screens/admin/admin_dashboard_screen.dart';
import '../../views/screens/admin/admin_users_screen.dart';
import '../../views/screens/admin/admin_jobs_screen.dart';
import '../../views/screens/admin/admin_settings_screen.dart';

/// Role-Based Navigation Helper
/// Returns the correct screen based on user role
class RoleBasedNavigation {
  /// Get Home screen based on role
  static Widget getHomeScreen() {
    return Consumer<AuthService>(
      builder: (context, authService, _) {
        final accountType = authService.currentUser?.accountType;
        if (accountType == 'admin') {
          return const AdminDashboardScreen(); // Admin dashboard
        } else if (authService.isEmployer) {
          return const EmployerHomeScreen(); // Employer dashboard with statistics
        }
        return const HomeScreen(); // Student home
      },
    );
  }

  /// Get Browse/Jobs screen based on role
  static Widget getBrowseScreen() {
    return Consumer<AuthService>(
      builder: (context, authService, _) {
        final accountType = authService.currentUser?.accountType;
        if (accountType == 'admin') {
          return const AdminUsersScreen(); // Admin users management (not used in nav)
        } else if (authService.isEmployer) {
          return const EmployerJobsScreen(); // Employer's posted jobs + post new job
        }
        return const JobsPage(); // Student job listings
      },
    );
  }

  /// Get Tasks/Applications screen based on role
  static Widget getTasksScreen() {
    return Consumer<AuthService>(
      builder: (context, authService, _) {
        final accountType = authService.currentUser?.accountType;
        if (accountType == 'admin') {
          return const AdminJobsScreen(); // Admin jobs management (not used in nav)
        } else if (authService.isEmployer) {
          return const EmployerApplicationsScreen(); // View applications received
        }
        return const MyTasksScreen(); // Student tasks/schedule
      },
    );
  }

  /// Get Learn screen based on role (shared for now)
  static Widget getLearnScreen() {
    // Both roles see the same screen for now
    // You can customize badges/content per role if needed
    return const EducationListScreen();
  }

  /// Get Profile screen based on role
  static Widget getProfileScreen() {
    return Consumer<AuthService>(
      builder: (context, authService, _) {
        final accountType = authService.currentUser?.accountType;
        if (accountType == 'admin') {
          return const AdminSettingsScreen(); // Admin settings (not used in nav)
        } else if (authService.isEmployer) {
          return const EmployerProfileScreen(); // Employer profile
        }
        return const MyProfileScreen(); // Student profile
      },
    );
  }

  /// Get bottom nav item label based on role and index
  static String getNavLabel(int index, BuildContext context) {
    final authService = context.watch<AuthService>();

    if (authService.isEmployer) {
      switch (index) {
        case 0:
          return 'Home';
        case 1:
          return 'My Jobs';
        case 2:
          return 'Applications';
        case 3:
          return 'Learn';
        case 4:
          return 'Profile';
        default:
          return '';
      }
    } else {
      switch (index) {
        case 0:
          return 'Home';
        case 1:
          return 'Browse';
        case 2:
          return 'My Tasks';
        case 3:
          return 'Learn';
        case 4:
          return 'Profile';
        default:
          return '';
      }
    }
  }
}
