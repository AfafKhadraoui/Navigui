import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navigui/commons/themes/style_simple/colors.dart';
import 'package:navigui/routes/app_router.dart';
import 'package:navigui/views/widgets/home/educational_content_section.dart';
import 'package:navigui/views/widgets/employer/stat_card.dart';
import 'package:navigui/views/widgets/employer/job_post_card.dart';
import 'package:navigui/views/widgets/employer/application_card.dart';
import '../../../logic/services/secure_storage_service.dart';

/// Employer Home Screen
/// Dashboard showing hiring activity, job posts, and recent applications
class EmployerHomeScreen extends StatefulWidget {
  const EmployerHomeScreen({super.key});

  @override
  State<EmployerHomeScreen> createState() => _EmployerHomeScreenState();
}

class _EmployerHomeScreenState extends State<EmployerHomeScreen> {
  String _userName = 'Business';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final secureStorage = SecureStorageService();
    final session = await secureStorage.getUserSession();
    if (mounted) {
      setState(() {
        _userName = session['name'] ?? 'Business';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Quick Stats
                    _buildQuickStats(),

                    const SizedBox(height: 30),

                    // Active Job Posts
                    _buildSectionHeader('Active Job Posts', onViewAll: () {
                      context.go(AppRouter.tasks);
                    }),
                    const SizedBox(height: 15),
                    _buildActiveJobPosts(),

                    const SizedBox(height: 30),

                    // Recent Applications
                    _buildSectionHeader('Recent Applications', onViewAll: () {
                      context.go(AppRouter.tasks);
                    }),
                    const SizedBox(height: 15),
                    _buildRecentApplications(),

                    const SizedBox(height: 30),

                    // Learn & Grow
                    const EducationalContentSection(),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back,',
                style: TextStyle(
                  color: AppColors.white.withOpacity(0.7),
                  fontSize: 13,
                  fontFamily: 'Acme',
                ),
              ),
              const SizedBox(height: 3),
              Text(
                _userName,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 22,
                  fontFamily: 'Aclonica',
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          // Notification bell
          GestureDetector(
            onTap: () => context.push(AppRouter.notifications),
            child: Stack(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.grey1.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.notifications_outlined,
                    color: AppColors.white,
                    size: 24,
                  ),
                ),
                // Notification badge
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppColors.electricLime,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: EmployerStatCard(
              title: 'Active Posts',
              value: '3',
              color: AppColors.electricLime,
              icon: Icons.work_outline,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: EmployerStatCard(
              title: 'New Apps',
              value: '12',
              color: AppColors.purple2,
              icon: Icons.people_outline,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: EmployerStatCard(
              title: 'Hired',
              value: '2',
              color: AppColors.orange1,
              icon: Icons.check_circle_outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onViewAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontFamily: 'Aclonica',
              letterSpacing: -0.3,
            ),
          ),
          if (onViewAll != null)
            GestureDetector(
              onTap: onViewAll,
              child: Text(
                'View All',
                style: TextStyle(
                  color: AppColors.electricLime,
                  fontSize: 13,
                  fontFamily: 'Acme',
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActiveJobPosts() {
    return SizedBox(
      height: 150,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        children: [
          JobPostCard(
            title: 'Waiter Needed',
            applicants: 5,
            status: 'Active',
            color: AppColors.electricLime,
            postedDate: '2 days ago',
            location: 'Algiers',
            deadline: '5 days left',
            views: 42,
          ),
          const SizedBox(width: 12),
          JobPostCard(
            title: 'Delivery Driver',
            applicants: 8,
            status: 'Active',
            color: AppColors.orange1,
            postedDate: '5 days ago',
            location: 'Oran',
            deadline: '1 week left',
            views: 67,
          ),
          const SizedBox(width: 12),
          JobPostCard(
            title: 'Social Media Manager',
            applicants: 3,
            status: 'Paused',
            color: AppColors.purple2,
            postedDate: '1 week ago',
            location: 'Remote',
            deadline: 'Paused',
            views: 28,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentApplications() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          EmployerApplicationCard(
            studentName: 'Ahmed Benali',
            jobTitle: 'Waiter Needed',
            timeAgo: '2 hours ago',
            avatarColor: AppColors.purple2,
          ),
          const SizedBox(height: 12),
          EmployerApplicationCard(
            studentName: 'Fatima Kader',
            jobTitle: 'Delivery Driver',
            timeAgo: '5 hours ago',
            avatarColor: AppColors.electricLime,
          ),
          const SizedBox(height: 12),
          EmployerApplicationCard(
            studentName: 'Karim Mammeri',
            jobTitle: 'Waiter Needed',
            timeAgo: '1 day ago',
            avatarColor: AppColors.orange1,
          ),
        ],
      ),
    );
  }
}
