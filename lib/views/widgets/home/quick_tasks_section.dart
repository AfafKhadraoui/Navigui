import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navigui/commons/themes/style_simple/colors.dart';
import 'package:navigui/views/widgets/job/job_card.dart';
import 'package:navigui/views/widgets/cards/section_header.dart';
import 'package:navigui/routes/app_router.dart';

class QuickTasksSection extends StatelessWidget {
  const QuickTasksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: 'Quick Tasks',
          onExploreTap: () {
            context.go(AppRouter.jobs);
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
                return JobCard(
                  title: 'English\nTranslation',
                  location: 'Remote',
                  salary: '5000 DZD',
                  backgroundColor: AppColors.purple2,
                  imagePath: 'assets/images/tasks/task1.png',
                  isLiked: true,
                );
              } else {
                return JobCard(
                  title: 'Voice Over\nRecording',
                  location: 'Remote',
                  salary: '2000 DZD',
                  backgroundColor: AppColors.yellow2,
                  imagePath: 'assets/images/tasks/task2.png',
                  isLiked: false,
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
