import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../views/screens/homescreen/home_screen.dart';
import '../../views/screens/jobs/jobs_page.dart';
import '../../views/screens/tasks/my_tasks_screen.dart';
import '../../views/screens/education/education_list_screen.dart';
import '../../views/screens/profile/my_profile_screen.dart';
import '../../views/screens/employer/employer_home_screen.dart';
import '../../views/screens/employer/my_job_posts_screen.dart';
import '../../views/screens/employer/student_requests_screen.dart';
import '../../views/screens/profile/employer_profile_screen.dart';
import '../../views/screens/admin/admin_dashboard_screen.dart';

/// Role-Based Navigation Helper
/// Returns the correct screen based on user role
class RoleBasedNavigation {
  /// Get Home screen based on role
  static Widget getHomeScreen() {
    return FutureBuilder<String>(
      future: _getUserRole(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final role = snapshot.data!;
        if (role == 'admin') {
          return const AdminDashboardScreen();
        } else if (role == 'employer') {
          return const EmployerHomeScreen();
        }
        return const HomeScreen();
      },
    );
  }

  /// Helper to get user role from email
  static Future<String> _getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email') ?? '';
    final emailLower = email.toLowerCase();

    if (emailLower.contains('admin')) {
      return 'admin';
    } else if (emailLower.contains('employer')) {
      return 'employer';
    }
    return 'student';
  }

  /// Get Browse/Jobs screen based on role
  static Widget getBrowseScreen() {
    return FutureBuilder<String>(
      future: _getUserRole(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final role = snapshot.data!;
        if (role == 'employer') {
          return const MyJobPostsScreen();
        }
        return const JobsPage();
      },
    );
  }

  /// Get Tasks/Applications screen based on role
  static Widget getTasksScreen() {
    return FutureBuilder<String>(
      future: _getUserRole(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final role = snapshot.data!;
        if (role == 'employer') {
          return const StudentRequestsScreen();
        }
        return const MyTasksScreen();
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
    return FutureBuilder<String>(
      future: _getUserRole(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final role = snapshot.data!;
        if (role == 'employer') {
          return const EmployerProfileScreen();
        }
        return const MyProfileScreen();
      },
    );
  }

  /// Get bottom nav item label based on role and index
  static String getNavLabel(int index, BuildContext context) {
    // Simple default for testing
    final isEmployer = false;

    if (isEmployer) {
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
