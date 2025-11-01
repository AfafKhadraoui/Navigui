import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navigui/commons/themes/style_simple/colors.dart';
import 'package:navigui/views/widgets/job/job_card.dart';
import 'package:navigui/views/widgets/cards/section_header.dart';
import 'package:navigui/routes/app_router.dart';

class PartTimeJobsSection extends StatelessWidget {
  const PartTimeJobsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: 'Part Time Jobs',
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
                  title: 'UX/UI\ndesigner',
                  location: 'Remote',
                  salary: '40,000 DZD/month',
                  backgroundColor: AppColors.electricLime,
                  imagePath: 'assets/images/jobs/job1.png',
                  isLiked: true,
                );
              } else {
                return JobCard(
                  title: 'Food\nDelivery',
                  location: 'Algiers',
                  salary: '20,000 DZD/month',
                  backgroundColor: AppColors.orange1,
                  imagePath: 'assets/images/jobs/job2.png',
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
