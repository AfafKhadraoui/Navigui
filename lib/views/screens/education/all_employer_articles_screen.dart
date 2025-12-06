import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../commons/themes/style_simple/colors.dart';
import '../../../generated/s.dart';
import '../../../logic/cubits/education/education_cubit.dart';
import '../../../logic/cubits/education/education_state.dart';
import '../../../core/dependency_injection.dart';
import '../../widgets/cards/education_card.dart';

class AllEmployerArticlesScreen extends StatelessWidget {
  const AllEmployerArticlesScreen({super.key});

  TextStyle _getUITextStyle(
    BuildContext context, {
    required double fontSize,
    Color color = Colors.white,
    FontWeight? fontWeight,
  }) {
    final locale = Localizations.localeOf(context).languageCode;
    if (locale == 'ar') {
      return GoogleFonts.cairo(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight ?? FontWeight.w700,
      );
    }
    return TextStyle(
      fontSize: fontSize,
      color: color,
      fontFamily: 'Aclonica',
      fontWeight: fontWeight ?? FontWeight.w400,
      letterSpacing: -0.5,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<EducationCubit>()..loadArticles(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
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
                              size: 48,
                              color: Colors.red.shade300,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              S.of(context)!.learnFailedToLoadArticles,
                              style: TextStyle(
                                color: Colors.red.shade300,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is EducationArticlesLoaded) {
                      final employerArticles = state.articles
                          .where((a) => a.targetAudience == 'employer')
                          .toList();

                      if (employerArticles.isEmpty) {
                        return Center(
                          child: Text(
                            S.of(context)!.learnNoEmployerArticles,
                            style: TextStyle(
                              color: AppColors.white.withOpacity(0.6),
                              fontSize: 16,
                            ),
                          ),
                        );
                      }

                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              const SizedBox(height: 12),
                              _buildArticlesGrid(context, employerArticles),
                              const SizedBox(height: 100),
                            ],
                          ),
                        ),
                      );
                    }

                    return const SizedBox.shrink();
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
          GestureDetector(
            onTap: () => context.pop(),
            child: Icon(
              Icons.arrow_back_ios,
              color: AppColors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            S.of(context)!.learnAllEmployerArticles,
            style: _getUITextStyle(context, fontSize: 24, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildArticlesGrid(BuildContext context, List<dynamic> articles) {
    final cardColors = [
      AppColors.orange1,
      AppColors.purple1,
      AppColors.electricLime3,
      AppColors.yellow2,
    ];

    final cardImages = [
      'assets/images/education/course1.png',
      'assets/images/education/course2.png',
      'assets/images/education/course3.png',
      'assets/images/education/course4.png',
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: articles.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final article = articles[index];
        // Get a preview of the content (first 120 characters)
        String description = article.content.length > 120
            ? '${article.content.substring(0, 120)}...'
            : article.content;

        // Calculate days ago
        final publishedDate = article.publishedAt is String
            ? DateTime.parse(article.publishedAt)
            : article.publishedAt as DateTime;
        final daysAgo = DateTime.now().difference(publishedDate).inDays;
        String dateStr = daysAgo == 0
            ? 'Today'
            : daysAgo == 1
                ? '1 day ago'
                : '$daysAgo days ago';

        return EducationCard(
          title: article.title,
          badge1: '${article.readTime}min',
          badge2: index < 3 ? 'Popular' : '',
          badge3: '',
          backgroundColor: cardColors[index % cardColors.length],
          imagePath: cardImages[index % cardImages.length],
          isLiked: false,
          description: description,
          author: 'Navigui Team',
          publishedDate: dateStr,
          viewsCount: article.viewsCount,
          onTap: () {
            context.go('/learn/article/${article.id}');
          },
        );
      },
    );
  }
}
