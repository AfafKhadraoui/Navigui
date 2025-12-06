import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:navigui/commons/themes/style_simple/colors.dart';
import 'package:navigui/views/widgets/cards/education_card.dart';
import 'package:navigui/views/widgets/cards/section_header.dart';
import 'package:navigui/routes/app_router.dart';
import '../../../logic/cubits/education/education_cubit.dart';
import '../../../logic/cubits/education/education_state.dart';
import '../../../logic/cubits/auth/auth_cubit.dart';
import '../../../logic/cubits/auth/auth_state.dart';
import '../../../core/dependency_injection.dart';

class EducationalContentSection extends StatelessWidget {
  const EducationalContentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<EducationCubit>()..loadArticles(),
      child: Column(
        children: [
          SectionHeader(
            title: 'Learn&Grow',
            onExploreTap: () {
              context.go(AppRouter.learn);
            },
          ),
          const SizedBox(height: 15),
          BlocBuilder<EducationCubit, EducationState>(
            builder: (context, state) {
              if (state is EducationLoading) {
                return const SizedBox(
                  height: 158,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (state is EducationError) {
                return SizedBox(
                  height: 158,
                  child: Center(
                    child: Text(
                      'Failed to load articles',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                );
              }

              if (state is EducationArticlesLoaded) {
                // Get user type from auth
                String userType = 'student';
                try {
                  final authState = context.read<AuthCubit>().state;
                  if (authState is AuthAuthenticated) {
                    userType = authState.user.accountType;
                  }
                } catch (e) {
                  // Default to student
                }

                // Filter articles by user type and get first 2
                final userArticles = state.articles
                    .where((a) => a.targetAudience == userType)
                    .take(2)
                    .toList();

                if (userArticles.isEmpty) {
                  return const SizedBox(
                    height: 158,
                    child: Center(child: Text('No articles available')),
                  );
                }

                // Card colors list
                final cardColors = [
                  AppColors.orange1,
                  AppColors.electricLime3,
                ];

                // Card images list (use course images for cards)
                final cardImages = [
                  'assets/images/education/course1.png',
                  'assets/images/education/course2.png',
                ];

                return SizedBox(
                  height: 158,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    itemCount: userArticles.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final article = userArticles[index];
                      return EducationCard(
                        title: article.title,
                        badge1: '${article.readTime}min',
                        badge2: index == 0 ? 'New' : 'Popular',
                        badge3: index == 0 ? 'Must-read' : '',
                        backgroundColor: cardColors[index % cardColors.length],
                        imagePath: cardImages[index % cardImages.length],
                        isLiked: false,
                        onTap: () {
                          context.go('/learn/article/${article.id}');
                        },
                      );
                    },
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
