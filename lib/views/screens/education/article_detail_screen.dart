import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navigui/commons/themes/style_simple/colors.dart';

/// Individual Education Article Screen
/// Displays detailed content for a specific educational article
class EducationArticleScreen extends StatefulWidget {
  final String articleId;

  const EducationArticleScreen({
    super.key,
    required this.articleId,
  });

  @override
  State<EducationArticleScreen> createState() => _EducationArticleScreenState();
}

class _EducationArticleScreenState extends State<EducationArticleScreen> {
  bool isBookmarked = false;
  bool isLiked = false;

  Map<String, dynamic> _getArticleData() {
    switch (widget.articleId) {
      case 'your-first-job':
        return {
          'title': 'Your First Job',
          'badge1': '10min',
          'badge2': 'New',
        };
      case 'know-your-rights':
        return {
          'title': 'Know Your Rights',
          'badge1': '5min',
          'badge2': 'Popular',
        };
      case 'first-time-job-seekers':
        return {
          'title': 'First-Time Job Seekers',
          'badge1': '15min',
          'badge2': 'Complete Guide',
        };
      case 'application-tips':
        return {
          'title': 'Application Tips',
          'badge1': '10min',
          'badge2': 'Beginner',
        };
      case 'build-profile':
        return {
          'title': 'Build Your Profile',
          'badge1': '8min',
          'badge2': 'Trending',
        };
      case 'hiring-practices':
        return {
          'title': 'Hiring Best Practices',
          'badge1': '10min',
          'badge2': 'Must-read',
        };
      case 'writing-job-posts':
        return {
          'title': 'Writing Job Posts',
          'badge1': '5min',
          'badge2': 'Popular',
        };
      default:
        return {
          'title': 'Article',
          'badge1': '10min',
          'badge2': 'Article',
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final articleData = _getArticleData();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context, articleData),

            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Article info with tags
                    _buildArticleInfo(articleData),

                    const SizedBox(height: 20),

                    // Video/Image section
                    _buildMediaSection(),

                    const SizedBox(height: 30),

                    // Article content
                    _buildContent(),

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

  Widget _buildHeader(BuildContext context, Map<String, dynamic> articleData) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
      child: Row(
        children: [
          // Back button
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
              articleData['title'],
              style: TextStyle(
                color: AppColors.white,
                fontSize: 20,
                fontFamily: 'Aclonica',
                letterSpacing: -0.5,
              ),
            ),
          ),

          // Bookmark button (circular with black background)
          GestureDetector(
            onTap: () {
              setState(() {
                isBookmarked = !isBookmarked;
              });
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.black,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: AppColors.white,
                size: 18,
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Like button (circular with black background)
          GestureDetector(
            onTap: () {
              setState(() {
                isLiked = !isLiked;
              });
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.black,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? AppColors.red1 : AppColors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleInfo(Map<String, dynamic> articleData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tags/badges row
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.electricLime,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  articleData['badge1'],
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 11,
                    fontFamily: 'Acme',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.purple2,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  articleData['badge2'],
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 11,
                    fontFamily: 'Acme',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMediaSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.grey1.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            'assets/images/education/technology.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.purple2.withOpacity(0.2),
                      AppColors.electricLime.withOpacity(0.15),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.image,
                    color: AppColors.white.withOpacity(0.5),
                    size: 50,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main content intro
          Text(
            'Explore strategies, tools, and platforms to excel in today\'s digital landscape. From SEO and social media to email campaigns and analytics, gain practical skills for success. Perfect for beginners, getting your first job can feel overwhelming, but with the right approach, you can stand out from the crowd.',
            style: TextStyle(
              color: AppColors.white.withOpacity(0.85),
              fontSize: 15,
              fontFamily: 'Acme',
              height: 1.6,
              letterSpacing: 0.1,
            ),
          ),

          const SizedBox(height: 25),

          // Section 1
          Text(
            'Understanding What Employers Want',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontFamily: 'Aclonica',
              letterSpacing: -0.3,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'Before you start writing, take time to understand what the employer is looking for. Read the job description carefully and make a list of the key skills and qualifications they mention. This will help you tailor your application to show you\'re the right fit.\n\nEmployers want to see that you\'ve done your homework. Research the company, understand their values, and think about how your experience aligns with their mission.',
            style: TextStyle(
              color: AppColors.white.withOpacity(0.8),
              fontSize: 14,
              fontFamily: 'Acme',
              height: 1.6,
            ),
          ),

          const SizedBox(height: 25),

          // Section 2
          Text(
            'Crafting Your Application',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontFamily: 'Aclonica',
              letterSpacing: -0.3,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'Start with a strong opening that grabs attention. Mention the specific position you\'re applying for and briefly explain why you\'re interested. Keep it concise and genuine.\n\nIn the body, highlight 2-3 relevant experiences or skills. Use specific examples rather than generic statements. Instead of saying "I\'m a hard worker," describe a time when you went above and beyond to complete a project.\n\nEnd with a clear call to action. Express your enthusiasm for an interview and thank them for considering your application.',
            style: TextStyle(
              color: AppColors.white.withOpacity(0.8),
              fontSize: 14,
              fontFamily: 'Acme',
              height: 1.6,
            ),
          ),

          const SizedBox(height: 25),

          // Section 3
          Text(
            'Common Mistakes to Avoid',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontFamily: 'Aclonica',
              letterSpacing: -0.3,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'Don\'t use the same application for every job. Generic applications are easy to spot and rarely succeed. Always customize.\n\nAvoid being too formal or too casual. Find a professional but friendly tone that matches the company culture.\n\nNever submit without proofreading. Spelling and grammar mistakes can cost you the opportunity. Read it out loud, use spell check, and if possible, have someone else review it.',
            style: TextStyle(
              color: AppColors.white.withOpacity(0.8),
              fontSize: 14,
              fontFamily: 'Acme',
              height: 1.6,
            ),
          ),

          const SizedBox(height: 30),

          // Read more section
          Text(
            'Read more',
            style: TextStyle(
              color: AppColors.electricLime,
              fontSize: 15,
              fontFamily: 'Acme',
              decoration: TextDecoration.underline,
            ),
          ),

          const SizedBox(height: 35),

          // Next articles
          Text(
            'Next in this series',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontFamily: 'Aclonica',
              letterSpacing: -0.3,
            ),
          ),

          const SizedBox(height: 15),

          _buildNextArticleCard(
            'Building Your Professional Profile',
            '12 min',
            AppColors.orange1,
          ),

          const SizedBox(height: 12),

          _buildNextArticleCard(
            'Interview Preparation Guide',
            '10 min',
            AppColors.purple2,
          ),
        ],
      ),
    );
  }

  Widget _buildNextArticleCard(String title, String duration, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 15,
                    fontFamily: 'Aclonica',
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  duration,
                  style: TextStyle(
                    color: AppColors.white.withOpacity(0.6),
                    fontSize: 12,
                    fontFamily: 'Acme',
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: AppColors.white.withOpacity(0.6),
            size: 16,
          ),
        ],
      ),
    );
  }
}
