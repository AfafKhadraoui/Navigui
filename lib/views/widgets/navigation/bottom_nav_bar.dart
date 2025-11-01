import 'package:flutter/material.dart';
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
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent, // Remove splash effect
          highlightColor: Colors.transparent, // Remove highlight effect
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.background,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.grey2,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          elevation: 0,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          enableFeedback: false, // Disable haptic feedback
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work_outline),
              activeIcon: Icon(Icons.work),
              label: 'Browse',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.task_alt_outlined),
              activeIcon: Icon(Icons.task_alt),
              label: 'My Tasks',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school_outlined),
              activeIcon: Icon(Icons.school),
              label: 'Learn',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
