import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:navigui/commons/themes/style_simple/colors.dart';
import 'package:navigui/views/widgets/cards/education_card.dart';
import '../../../logic/cubits/education/education_cubit.dart';
import '../../../logic/cubits/education/education_state.dart';
import '../../../logic/cubits/auth/auth_cubit.dart';
import '../../../logic/cubits/auth/auth_state.dart';

import '../../../core/dependency_injection.dart';
import '../../../data/models/education_article_model.dart';

/// Education List Screen - Learn & Grow page
/// Articles, tips, guides
/// How to write applications, resume building, interview skills
class EducationListScreen extends StatelessWidget {
  const EducationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<EducationCubit>()..loadArticles(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(context),

              // Scrollable content
              Expanded(
                child: BlocBuilder<EducationCubit, EducationState>(
                  builder: (context, state) {
                    if (state is EducationLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.electricLime,
                        ),
                      );
                    }

                    if (state is EducationError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error loading articles',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.message,
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    // Get articles from backend or show static content
                    List<EducationArticleModel> articles = [];
                    if (state is EducationArticlesLoaded) {
                      articles = state.articles;
                    }

                    return SingleChildScrollView(
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

                          // Featured card - show from backend if available, else static
                          _buildFeaturedCard(context, articles),

                          const SizedBox(height: 25),

                          // For Students Section
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                GestureDetector(
                                  onTap: () {
                                    context.go('/learn/all-student-articles');
                                  },
                                  child: const Text(
                                    'view all',
                                    style: TextStyle(
                                      color: AppColors.electricLime,
                                      fontSize: 14,
                                      fontFamily: 'Acme',
                                      letterSpacing: -0.5,
                                      decoration: TextDecoration.underline,
                                      decorationColor: AppColors.electricLime,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          _buildStudentCardsColumn(context, articles),

                          const SizedBox(height: 25),

                          // For Employers Section
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                GestureDetector(
                                  onTap: () {
                                    context.go('/learn/all-employer-articles');
                                  },
                                  child: const Text(
                                    'view all',
                                    style: TextStyle(
                                      color: AppColors.electricLime,
                                      fontSize: 14,
                                      fontFamily: 'Acme',
                                      letterSpacing: -0.5,
                                      decoration: TextDecoration.underline,
                                      decorationColor: AppColors.electricLime,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          _buildEmployerCardsColumn(context, articles),

                          const SizedBox(height: 100),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
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

  Widget _buildFeaturedCard(
      BuildContext context, List<EducationArticleModel> articles) {
    // Get current user type from auth state
    String userType = 'student'; // Default fallback

    try {
      final authState = context.read<AuthCubit>().state;
      if (authState is AuthAuthenticated) {
        userType = authState.user.accountType;
      }
    } catch (e) {
      // AuthCubit not available, use default
    }

    // Filter articles by user type and get the most recent one (sorted by publishedAt)
    final userArticles = articles
        .where((a) => a.targetAudience == userType)
        .toList()
      ..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));

    final featuredArticle = userArticles.isNotEmpty ? userArticles.first : null;
    final title = featuredArticle?.title ?? 'First-Time Job Seekers';
    final description = featuredArticle?.content ??
        'Everything you need to write winning  applications and ace your interviews';
    final readTime = featuredArticle?.readTime ?? 15;
    final articleId = featuredArticle?.id ?? 'first-time-job-seekers';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: () {
          context.go('/learn/article/$articleId');
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
                        title,
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 15,
                          fontFamily: 'Aclonica',
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.3,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
                description.length > 100
                    ? '${description.substring(0, 100)}...'
                    : description,
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 10,
                  fontFamily: 'Acme',
                  letterSpacing: -0.2,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
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
                      '$readTime min',
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

  Widget _buildStudentCardsColumn(
      BuildContext context, List<EducationArticleModel> articles) {
    // Filter articles for students or use static content
    final studentArticles =
        articles.where((a) => a.targetAudience == 'student').toList();

    // Static fallback content
    final staticCards = [
      {
        'title': 'Application Tips',
        'badge1': '10min',
        'badge2': 'Popular',
        'badge3': 'beginner',
        'color': AppColors.electricLime,
        'image': 'assets/images/education/course3.png',
        'id': 'application-tips',
      },
      {
        'title': 'Build Your Profile',
        'badge1': '8min',
        'badge2': 'Trending',
        'badge3': '',
        'color': AppColors.orange1,
        'image': 'assets/images/education/course4.png',
        'id': 'build-profile',
      },
    ];

    return SizedBox(
      height: 158,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: studentArticles.isNotEmpty
            ? studentArticles.length
            : staticCards.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          if (studentArticles.isNotEmpty) {
            final article = studentArticles[index];
            final colors = [
              AppColors.electricLime,
              AppColors.orange1,
              AppColors.yellow2
            ];
            // Use course images for card illustrations
            final courseImages = [
              'assets/images/education/course3.png',
              'assets/images/education/course4.png',
              'assets/images/education/course1.png',
            ];
            return EducationCard(
              title: article.title,
              badge1: '${article.readTime}min',
              badge2: article.viewsCount > 100 ? 'Popular' : 'New',
              badge3: '',
              backgroundColor: colors[index % colors.length],
              imagePath: courseImages[index % courseImages.length],
              isLiked: false,
              onTap: () {
                context.go('/learn/article/${article.id}');
              },
            );
          } else {
            final card = staticCards[index];
            return EducationCard(
              title: card['title'] as String,
              badge1: card['badge1'] as String,
              badge2: card['badge2'] as String,
              badge3: card['badge3'] as String,
              backgroundColor: card['color'] as Color,
              imagePath: card['image'] as String,
              isLiked: false,
              onTap: () {
                context.go('/learn/article/${card['id']}');
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildEmployerCardsColumn(
      BuildContext context, List<EducationArticleModel> articles) {
    // Filter articles for employers or use static content
    final employerArticles =
        articles.where((a) => a.targetAudience == 'employer').toList();

    // Static fallback content
    final staticCards = [
      {
        'title': 'Hiring Best Practices',
        'badge1': '10min',
        'badge2': 'New',
        'badge3': 'Must-read',
        'color': AppColors.yellow2,
        'image': 'assets/images/education/course1.png',
        'id': 'hiring-practices',
      },
      {
        'title': 'Writing Job Posts',
        'badge1': '5min',
        'badge2': 'Popular',
        'badge3': '',
        'color': AppColors.orange2,
        'image': 'assets/images/education/course2.png',
        'id': 'writing-job-posts',
      },
    ];

    return SizedBox(
      height: 158,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: employerArticles.isNotEmpty
            ? employerArticles.length
            : staticCards.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          if (employerArticles.isNotEmpty) {
            final article = employerArticles[index];
            final colors = [
              AppColors.yellow2,
              AppColors.orange2,
              AppColors.purple2
            ];
            // Use course images for card illustrations
            final courseImages = [
              'assets/images/education/course1.png',
              'assets/images/education/course2.png',
              'assets/images/education/course3.png',
            ];
            return EducationCard(
              title: article.title,
              badge1: '${article.readTime}min',
              badge2: article.viewsCount > 100 ? 'Popular' : 'New',
              badge3: 'Must-read',
              backgroundColor: colors[index % colors.length],
              imagePath: courseImages[index % courseImages.length],
              isLiked: false,
              onTap: () {
                context.go('/learn/article/${article.id}');
              },
            );
          } else {
            final card = staticCards[index];
            return EducationCard(
              title: card['title'] as String,
              badge1: card['badge1'] as String,
              badge2: card['badge2'] as String,
              badge3: card['badge3'] as String,
              backgroundColor: card['color'] as Color,
              imagePath: card['image'] as String,
              isLiked: false,
              onTap: () {
                context.go('/learn/article/${card['id']}');
              },
            );
          }
        },
      ),
    );
  }
}
