import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navigui/commons/themes/style_simple/colors.dart';
import 'package:navigui/views/widgets/cards/education_card.dart';
import 'package:navigui/views/widgets/cards/section_header.dart';
import 'package:navigui/routes/app_router.dart';

class EducationalContentSection extends StatelessWidget {
  const EducationalContentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: 'Learn&Grow',
          onExploreTap: () {
            context.go(AppRouter.learn);
          },
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 158,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: 2,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              if (index == 0) {
                return EducationCard(
                  title: 'Your first \njob',
                  badge1: '10min',
                  badge2: 'New',
                  badge3: 'Must-read',
                  backgroundColor: AppColors.orange1,
                  imagePath: 'assets/images/education/course1.png',
                  isLiked: true,
                  onTap: () {
                    context.go('/learn/article/your-first-job');
                  },
                );
              } else {
                return EducationCard(
                  title: 'Know your rights',
                  badge1: '5min',
                  badge2: 'Popular',
                  badge3: '',
                  backgroundColor: AppColors.electricLime3,
                  imagePath: 'assets/images/education/course2.png',
                  isLiked: false,
                  onTap: () {
                    context.go('/learn/article/know-your-rights');
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
