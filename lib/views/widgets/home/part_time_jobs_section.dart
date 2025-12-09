import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigui/commons/themes/style_simple/colors.dart';
import 'package:navigui/views/widgets/job/job_card.dart';
import 'package:navigui/views/widgets/cards/section_header.dart';
import 'package:navigui/routes/app_router.dart';
import 'package:navigui/logic/cubits/job/job_cubit.dart';
import 'package:navigui/logic/cubits/job/job_state.dart';
import 'package:navigui/logic/cubits/saved_jobs/saved_jobs_cubit.dart';
import 'package:navigui/logic/cubits/saved_jobs/saved_jobs_state.dart';
import 'package:navigui/data/models/job_post.dart';
import 'package:navigui/logic/services/secure_storage_service.dart';
import 'package:navigui/core/dependency_injection.dart';

class PartTimeJobsSection extends StatefulWidget {
  const PartTimeJobsSection({super.key});

  @override
  State<PartTimeJobsSection> createState() => _PartTimeJobsSectionState();
}

class _PartTimeJobsSectionState extends State<PartTimeJobsSection> {
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final secureStorage = getIt<SecureStorageService>();
    final userId = await secureStorage.getUserId();
    if (mounted) {
      setState(() {
        _userId = userId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: 'Part Time Jobs',
          onExploreTap: () {
            context.go(AppRouter.jobs);
            // Optionally set filter in JobCubit before navigating
            context.read<JobCubit>().filterByCategory('Part Time');
          },
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 158,
          child: BlocBuilder<JobCubit, JobState>(
            builder: (context, jobState) {
              if (jobState is JobLoading) {
                return const Center(child: CircularProgressIndicator(color: AppColors.electricLime));
              }

              if (jobState is JobLoaded) {
                // Filter for Part Time jobs
                final partTimeJobs = jobState.jobs.where((job) {
                  // Check exact type or if category string contains "Part Time" as fallback
                  return job.jobType == JobType.partTime || job.category.toLowerCase().contains('part time');
                }).toList();

                // Sort: Urgent first, then by date (descending)
                partTimeJobs.sort((a, b) {
                  if (a.isUrgent && !b.isUrgent) return -1;
                  if (!a.isUrgent && b.isUrgent) return 1;
                  // If urgency is same, sort by date (newest first)
                  return b.postedTime.compareTo(a.postedTime); // String comparison might be rough, but let's assume ISO or similar, or just rely on DB order if already sorted
                });
                
                // Limit to top 5
                final displayJobs = partTimeJobs.take(5).toList();

                if (displayJobs.isEmpty) {
                  return Center(
                    child: Text(
                      'No part-time jobs available',
                      style: TextStyle(color: AppColors.grey2, fontFamily: 'Acme'),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  itemCount: displayJobs.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final job = displayJobs[index];
                    
                    // Determine background color based on index or random for aesthetics
                    final bgColor = index % 2 == 0 ? AppColors.electricLime : AppColors.orange1;
                    
                    return BlocBuilder<SavedJobsCubit, SavedJobsState>(
                      builder: (context, savedState) {
                        final isSaved = savedState is SavedJobsLoaded && savedState.isJobSaved(job.id);
                        
                        return JobCard(
                          title: job.title,
                          location: job.location ?? 'Remote',
                          salary: job.salaryText,
                          backgroundColor: bgColor,
                          imagePath: 'assets/images/jobs/job${(index % 2) + 1}.png', // Placeholder logic for asset
                          isLiked: isSaved,
                          onLike: () {
                            if (_userId != null) {
                              context.read<SavedJobsCubit>().toggleSaveJob(job.id, _userId!);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please login to save jobs')),
                              );
                            }
                          },
                          onTap: () {
                             context.pushNamed('jobDetails', extra: job, pathParameters: {'id': job.id});
                          },
                        );
                      },
                    );
                  },
                );
              }

              return const SizedBox(); // Initial or Error state
            },
          ),
        ),
      ],
    );
  }
}
