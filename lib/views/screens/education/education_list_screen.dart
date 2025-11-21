import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navigui/commons/themes/style_simple/colors.dart';
import 'package:navigui/views/widgets/cards/education_card.dart';

/// Education List Screen - Learn & Grow page
/// Articles, tips, guides
/// How to write applications, resume building, interview skills
class EducationListScreen extends StatelessWidget {
  const EducationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Title above featured card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          const Text(
                            'New to Job Hunting',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Aclonica',
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Featured card
                    _buildFeaturedCard(context),

                    const SizedBox(height: 25),

                    // For Students Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          const Text(
                            'For Students',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Aclonica',
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildStudentCardsGrid(context),

                    const SizedBox(height: 25),

                    // For Employers Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          const Text(
                            'For Employers',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Aclonica',
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildEmployerCardsGrid(context),

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

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
      child: Row(
        children: [
          // Back arrow
          GestureDetector(
            onTap: () => context.pop(),
            child: Icon(
              Icons.arrow_back_ios,
              color: AppColors.white,
              size: 20,
            ),
          ),

          const SizedBox(width: 15),

          // Title
          Expanded(
            child: Text(
              'Learn & Grow',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 24,
                fontFamily: 'Aclonica',
                letterSpacing: -0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: () {
          context.go('/learn/article/first-time-job-seekers');
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.purple2,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row - Icon, Title, and Badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.star,
                      color: AppColors.purple2,
                      size: 22,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Title
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'First-Time Job Seekers',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 15,
                          fontFamily: 'Aclonica',
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.3,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'complete guide',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 9,
                        fontFamily: 'Acme',
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Description
              Text(
                'Everything you need to write winning  applications and ace your interviews',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 10,
                  fontFamily: 'Acme',
                  letterSpacing: -0.2,
                  height: 1.3,
                ),
                maxLines: 2,
              ),

              const SizedBox(height: 12),

              // Bottom row - Buttons
              Row(
                children: [
                  // Read Now button
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF87CEEB),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Read Now',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 12,
                        fontFamily: 'Acme',
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Time badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.electricLime,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      '15 min',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 11,
                        fontFamily: 'Acme',
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Like button
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite,
                      color: AppColors.red1,
                      size: 16,
                    ),
                  ),

                  const SizedBox(width: 6),

                  // Bookmark button
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.bookmark_border,
                      color: AppColors.white,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudentCardsGrid(BuildContext context) {
    return SizedBox(
      height: 158,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        children: [
          EducationCard(
            title: 'Application Tips',
            badge1: '10min',
            badge2: 'Popular',
            badge3: 'beginner',
            backgroundColor: AppColors.electricLime,
            imagePath: 'assets/images/education/course3.png',
            isLiked: false,
            onTap: () {
              context.go('/learn/article/application-tips');
            },
          ),
          const SizedBox(width: 10),
          EducationCard(
            title: 'Build Your Profile',
            badge1: '8min',
            badge2: 'Trending',
            badge3: '',
            backgroundColor: AppColors.orange1,
            imagePath: 'assets/images/education/course4.png',
            isLiked: false,
            onTap: () {
              context.go('/learn/article/build-profile');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmployerCardsGrid(BuildContext context) {
    return SizedBox(
      height: 158,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        children: [
          EducationCard(
            title: 'Hiring Best Practices',
            badge1: '10min',
            badge2: 'New',
            badge3: 'Must-read',
            backgroundColor: AppColors.yellow2,
            imagePath: 'assets/images/education/course1.png',
            isLiked: false,
            onTap: () {
              context.go('/learn/article/hiring-practices');
            },
          ),
          const SizedBox(width: 10),
          EducationCard(
            title: 'Writing Job Posts',
            badge1: '5min',
            badge2: 'Popular',
            badge3: '',
            backgroundColor: AppColors.orange2,
            imagePath: 'assets/images/education/course2.png',
            isLiked: false,
            onTap: () {
              context.go('/learn/article/writing-job-posts');
            },
          ),
        ],
      ),
    );
  }
}
