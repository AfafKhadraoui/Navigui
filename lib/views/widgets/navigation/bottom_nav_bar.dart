import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../commons/themes/style_simple/colors.dart';

/// Bottom Navigation Bar
/// 5 tabs: Home, Browse Jobs, My Tasks, Learn, Profile
///
/// Navigation Structure:
/// 1. Home - Main landing page with job feed
/// 2. Browse Jobs - Full job listings and search
/// 3. My Tasks - Student: Applied jobs & progress | Employer: Posted jobs & applicants
/// 4. Learn - Educational content and courses
/// 5. Profile - User profile and settings
class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, bool>>(
      future: _getUserRoleFlags(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        final flags = snapshot.data!;
        final isEmployer = flags['isEmployer'] ?? false;
        final isAdmin = flags['isAdmin'] ?? false;

        return _buildNavBar(context, isEmployer, isAdmin);
      },
    );
  }

  Future<Map<String, bool>> _getUserRoleFlags() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email') ?? '';
    final emailLower = email.toLowerCase();
    return {
      'isAdmin': emailLower.contains('admin'),
      'isEmployer': emailLower.contains('employer'),
    };
  }

  Widget _buildNavBar(BuildContext context, bool isEmployer, bool isAdmin) {
    // Set colors based on role
    final Color selectedColor;
    if (isAdmin) {
      selectedColor = AppColors.orange2;
    } else if (isEmployer) {
      selectedColor = AppColors.electricLime;
    } else {
      selectedColor = AppColors.purple6;
    }

    // Admin has 4 tabs: Dashboard, Users, Jobs, Settings
    final List<BottomNavigationBarItem> navItems;
    if (isAdmin) {
      navItems = [
        const BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          activeIcon: Icon(Icons.people),
          label: 'Users',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.work_outline),
          activeIcon: Icon(Icons.work),
          label: 'Jobs',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          activeIcon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ];
    } else {
      // Student/Employer have 5 tabs
      navItems = [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(isEmployer ? Icons.business_outlined : Icons.work_outline),
          activeIcon: Icon(isEmployer ? Icons.business : Icons.work),
          label: isEmployer ? 'My Jobs' : 'Browse',
        ),
        BottomNavigationBarItem(
          icon: Icon(
              isEmployer ? Icons.assignment_outlined : Icons.task_alt_outlined),
          activeIcon: Icon(isEmployer ? Icons.assignment : Icons.task_alt),
          label: isEmployer ? 'Applications' : 'My Tasks',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.school_outlined),
          activeIcon: Icon(Icons.school),
          label: 'Learn',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ];
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: AppColors.grey2.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Material(
        color: AppColors.background,
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTap,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            selectedItemColor: selectedColor,
            unselectedItemColor: AppColors.grey2,
            selectedFontSize: 11,
            unselectedFontSize: 11,
            elevation: 0,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            enableFeedback: false,
            items: navItems,
          ),
        ),
      ),
    );
  }
}
