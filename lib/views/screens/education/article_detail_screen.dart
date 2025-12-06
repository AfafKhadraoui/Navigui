import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:navigui/commons/themes/style_simple/colors.dart';
import '../../../logic/cubits/education/education_cubit.dart';
import '../../../logic/cubits/education/education_state.dart';
import '../../../core/dependency_injection.dart';
import '../../../data/models/education_article_model.dart';

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
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<EducationCubit>()..loadArticleDetail(widget.articleId),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
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
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Error loading article',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.electricLime,
                          foregroundColor: AppColors.background,
                        ),
                        child: const Text('Go Back'),
                      ),
                    ],
                  ),
                );
              }

              if (state is EducationArticleDetailLoaded) {
                final article = state.article;
                return Column(
                  children: [
                    // Header
                    _buildHeader(context, article),

                    // Content
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),

                            // Article info with tags
                            _buildArticleInfo(article),

                            const SizedBox(height: 20),

                            // Image section (if available)
                            if (article.imageUrl != null)
                              _buildImageSection(article),

                            const SizedBox(height: 30),

                            // Article content
                            _buildContent(article),

                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, EducationArticleModel article) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => context.pop(),
            child: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.white,
              size: 20,
            ),
          ),

          const SizedBox(width: 15),

          // Title
          Expanded(
            child: Text(
              article.title,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 20,
                fontFamily: 'Aclonica',
                letterSpacing: -0.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Like button (circular with black background)
          GestureDetector(
            onTap: () {
              setState(() {
                isLiked = !isLiked;
              });
              // Toggle like count in backend
              final cubit = context.read<EducationCubit>();
              if (isLiked) {
                cubit.incrementLikesCount(article.id);
              } else {
                cubit.decrementLikesCount(article.id);
              }
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
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

  Widget _buildArticleInfo(EducationArticleModel article) {
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
                  '${article.readTime} min',
                  style: const TextStyle(
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
                  '${article.viewsCount} views',
                  style: const TextStyle(
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
                  color: AppColors.red1.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.red1, width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.favorite,
                      color: AppColors.red1,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${article.likesCount}',
                      style: const TextStyle(
                        color: AppColors.red1,
                        fontSize: 11,
                        fontFamily: 'Acme',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Author and date
          if (article.author != null)
            Text(
              'By ${article.author}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontFamily: 'Acme',
              ),
            ),
          if (article.author != null) const SizedBox(height: 6),
          Text(
            _formatDate(article.publishedAt),
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(EducationArticleModel article) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: article.imageUrl!.startsWith('http')
            ? Image.network(
                article.imageUrl!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: AppColors.black,
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.white54,
                    size: 48,
                  ),
                ),
              )
            : Image.asset(
                article.imageUrl!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: AppColors.black,
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.white54,
                    size: 48,
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildContent(EducationArticleModel article) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Article title
          Text(
            article.title,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 24,
              fontFamily: 'Aclonica',
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 20),

          // Article content (formatted)
          _buildFormattedContent(article.content),
        ],
      ),
    );
  }

  Widget _buildFormattedContent(String content) {
    // Split content by lines and parse markdown-style formatting
    final lines = content.split('\n');
    List<Widget> contentWidgets = [];

    for (var line in lines) {
      line = line.trim();

      if (line.isEmpty) {
        contentWidgets.add(const SizedBox(height: 10));
      } else if (line.startsWith('##')) {
        // Heading
        contentWidgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: Text(
              line.replaceFirst('##', '').trim(),
              style: const TextStyle(
                color: AppColors.electricLime,
                fontSize: 20,
                fontFamily: 'Aclonica',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      } else if (line.startsWith('###')) {
        // Subheading
        contentWidgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 8),
            child: Text(
              line.replaceFirst('###', '').trim(),
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontFamily: 'Aclonica',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      } else if (line.startsWith('-') || line.startsWith('•')) {
        // Bullet point
        contentWidgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '• ',
                  style: TextStyle(
                    color: AppColors.electricLime,
                    fontSize: 16,
                  ),
                ),
                Expanded(
                  child: Text(
                    line.replaceFirst(RegExp(r'^[-•]\s*'), ''),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (line.startsWith(RegExp(r'^\d+\.'))) {
        // Numbered list
        contentWidgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 6),
            child: Text(
              line,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
                height: 1.6,
              ),
            ),
          ),
        );
      } else if (line.startsWith('**') && line.endsWith('**')) {
        // Bold text
        contentWidgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              line.replaceAll('**', ''),
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                height: 1.6,
              ),
            ),
          ),
        );
      } else {
        // Regular paragraph
        contentWidgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              line,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
                height: 1.6,
              ),
            ),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: contentWidgets,
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
