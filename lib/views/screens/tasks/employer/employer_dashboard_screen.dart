// lib/views/screens/tasks/employer/my_job_posts_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../commons/themes/style_simple/colors.dart';
import '../../../../data/models/job_post.dart';
import '../../../../logic/cubits/employer_job/employer_job_cubit.dart';
import '../../../../logic/cubits/employer_job/employer_job_state.dart';
import '../../../../core/dependency_injection.dart';
import '../../../../routes/app_router.dart';

class EmployerDashboardScreen extends StatefulWidget {
  const EmployerDashboardScreen({super.key});

  @override
  State<EmployerDashboardScreen> createState() =>
      _EmployerDashboardScreenState();
}

class _EmployerDashboardScreenState extends State<EmployerDashboardScreen> {
  late EmployerJobCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<EmployerJobCubit>();
    // TODO: Get actual employer ID from auth state
    _cubit.setEmployerId('1');
    _cubit.loadMyJobs();
  }

  Future<void> _navigateToAddJob() async {
    await context.push(AppRouter.jobPostForm);
    // Reload jobs after returning
    if (mounted) {
      _cubit.loadMyJobs();
    }
  }

  Future<void> _navigateToJobDetail(JobPost job) async {
    await context.push('${AppRouter.jobPostDetail}/${job.id}', extra: job);
    // Reload jobs after returning
    if (mounted) {
      _cubit.loadMyJobs();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<EmployerJobCubit, EmployerJobState>(
        bloc: _cubit,
        builder: (context, state) {
          List<JobPost> jobs = [];
          bool isLoading = false;
          String? errorMessage;

          if (state is EmployerJobLoading) {
            isLoading = true;
          } else if (state is EmployerJobsLoaded) {
            jobs = state.jobs;
          } else if (state is EmployerJobError) {
            errorMessage = state.message;
          }

          return SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: AppColors.textPrimary),
                        onPressed: () => context.pop(),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'My Job Posts',
                          style: TextStyle(
                            fontFamily: 'Aclonica',
                            fontSize: 24,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: _navigateToAddJob,
                        backgroundColor: AppColors.primary,
                        elevation: 0,
                        child: const Icon(
                          Icons.add,
                          color: AppColors.textOnPrimary,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                ),

                // Jobs List or Loading/Error
                Expanded(
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        )
                      : errorMessage != null
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                    size: 48,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Error: $errorMessage',
                                    style: const TextStyle(
                                      fontFamily: 'Acme',
                                      fontSize: 14,
                                      color: Colors.red,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          : jobs.isEmpty
                              ? Center(
                                  child: Text(
                                    'No job posts yet. Create your first one!',
                                    style: TextStyle(
                                      fontFamily: 'Acme',
                                      fontSize: 16,
                                      color: AppColors.textDisabled,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                                  itemCount: jobs.length,
                                  itemBuilder: (context, index) {
                                    final job = jobs[index];
                                    return _JobPostCard(
                                      job: job,
                                      onTap: () => _navigateToJobDetail(job),
                                    );
                                  },
                                ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _JobPostCard extends StatelessWidget {
  final JobPost job;
  final VoidCallback onTap;

  const _JobPostCard({
    required this.job,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: job.isUrgent
                ? AppColors.error.withOpacity(0.3)
                : AppColors.border,
          ),
          gradient: job.isUrgent
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.surface,
                    const Color(0xFF3D2020),
                  ],
                )
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Urgent Badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              job.title,
                              style: const TextStyle(
                                fontFamily: 'Aclonica',
                                fontSize: 18,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          if (job.isUrgent) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: AppColors.textPrimary,
                                    size: 12,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Urgent',
                                    style: TextStyle(
                                      fontFamily: 'Acme',
                                      fontSize: 11,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        job.location ?? 'Location not specified',
                        style: const TextStyle(
                          fontFamily: 'Acme',
                          fontSize: 14,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              job.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Acme',
                fontSize: 13,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 16),

            // Tags
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // Job Type
                _Tag(
                  label: job.jobType.label,
                  backgroundColor: AppColors.primaryDark,
                  textColor: AppColors.textOnPrimary,
                ),

                // Category
                _Tag(
                  label: job.category,
                  backgroundColor: AppColors.surfaceLight,
                  textColor: AppColors.textPrimary,
                ),

                // Recurring
                if (job.isRecurring)
                  const _Tag(
                    label: 'Recurring',
                    backgroundColor: AppColors.surfaceLight,
                    textColor: AppColors.primaryDark,
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Bottom Info
            Container(
              padding: const EdgeInsets.only(top: 12),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppColors.border,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Applications count
                  const Icon(
                    Icons.people_outline,
                    color: AppColors.primaryDark,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${job.applicantsCount}',
                    style: const TextStyle(
                      fontFamily: 'Acme',
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Salary
                  Text(
                    '\$${job.pay.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontFamily: 'Acme',
                      fontSize: 14,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const Spacer(),

                  // Status
                  _StatusBadge(status: job.status),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const _Tag({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Acme',
          fontSize: 13,
          color: textColor,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final JobStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case JobStatus.active:
        backgroundColor = AppColors.primaryDark.withOpacity(0.2);
        textColor = AppColors.primaryDark;
        break;
      case JobStatus.filled:
        backgroundColor = AppColors.grey2;
        textColor = AppColors.textPrimary;
        break;
      case JobStatus.closed:
        backgroundColor = AppColors.error.withOpacity(0.2);
        textColor = AppColors.error;
        break;
      case JobStatus.draft:
        backgroundColor = AppColors.grey2.withOpacity(0.5);
        textColor = AppColors.textTertiary;
        break;
      case JobStatus.expired:
        backgroundColor = AppColors.grey2.withOpacity(0.3);
        textColor = AppColors.textSecondary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontFamily: 'Acme',
          fontSize: 12,
          color: textColor,
        ),
      ),
    );
  }
}
