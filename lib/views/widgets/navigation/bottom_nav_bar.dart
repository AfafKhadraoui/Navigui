import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../commons/themes/style_simple/colors.dart';
import '../../../logic/services/auth_service.dart';

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
    final authService = context.watch<AuthService>();
    final isEmployer = authService.isEmployer;
    final selectedColor =
        isEmployer ? AppColors.electricLime : AppColors.purple6;

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
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                activeIcon: const Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                    isEmployer ? Icons.business_outlined : Icons.work_outline),
                activeIcon: Icon(isEmployer ? Icons.business : Icons.work),
                label: isEmployer ? 'My Jobs' : 'Browse',
              ),
              BottomNavigationBarItem(
                icon: Icon(isEmployer
                    ? Icons.assignment_outlined
                    : Icons.task_alt_outlined),
                activeIcon:
                    Icon(isEmployer ? Icons.assignment : Icons.task_alt),
                label: isEmployer ? 'Applications' : 'My Tasks',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.school_outlined),
                activeIcon: const Icon(Icons.school),
                label: 'Learn',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_outline),
                activeIcon: const Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
