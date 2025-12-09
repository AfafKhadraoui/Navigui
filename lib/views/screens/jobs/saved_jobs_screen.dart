import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../commons/themes/style_simple/colors.dart';
import '../../../commons/themes/style_simple/styles.dart';
import '../../../logic/cubits/saved_jobs/saved_jobs_cubit.dart';
import '../../../logic/cubits/saved_jobs/saved_jobs_state.dart';
import '../../../data/models/job_post.dart';
import 'job_detail_screen.dart';

class SavedJobsScreen extends StatefulWidget {
  final String userId;

  const SavedJobsScreen({
    super.key,
    required this.userId,
  });

  @override
  State<SavedJobsScreen> createState() => _SavedJobsScreenState();
}

class _SavedJobsScreenState extends State<SavedJobsScreen> {

  @override
  void initState() {
    super.initState();
    // Load saved jobs if not already loaded or if keys are empty
    final cubit = context.read<SavedJobsCubit>();
    if (cubit.state is SavedJobsInitial) {
       cubit.loadSavedJobs(widget.userId);
    } 
  }

  Map<String, dynamic> _jobToDisplayMap(JobPost job) {
    return {
      'id': job.id,
      'title': job.title,
      'company': job.category,
      'location': job.location ?? 'Remote',
      'postedTime': job.postedTime,
      'deadline': job.deadlineText,
      'salary': job.salaryText,
      'type': job.jobType.displayName,
      'fullDescription': job.description,
      'phone': 'Contact Employer', // Placeholder as not in JobPost main table
      'email': 'Contact Employer', // Placeholder
      'rating': 4.5, // Placeholder
      'positions': job.numberOfPositions,
      'requirements': {
        'skills': ['See Description'], // Placeholder
        'experience': job.requirements ?? 'Not specified',
        'languages': job.languages,
        'timeCommitment': job.timeCommitment ?? 'Not specified',
        'availability': ['Flexible'], // Placeholder
      }
    };
  }

  void _showDeleteDialog(BuildContext context, JobPost job) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.grey4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Remove Saved Job',
          style: TextStyle(
            fontFamily: 'Aclonica', // Title font
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to remove "${job.title}" from your saved jobs?',
          style: const TextStyle(
            fontFamily: 'Acme', // Text font
            color: AppColors.grey7,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Acme', // Text font
                color: AppColors.grey6,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Toggle will unsave since it is already saved
              context.read<SavedJobsCubit>().toggleSaveJob(job.id, widget.userId);
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Job removed from saved'),
                  backgroundColor: AppColors.urgentRed,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.urgentRed,
              foregroundColor: AppColors.white,
            ),
            child: const Text(
              'Remove',
              style: TextStyle(fontFamily: 'Aclonica'), // Title font
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Saved Jobs',
          style: TextStyle(
            fontFamily: 'Aclonica', // Title font
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        actions: [
          BlocBuilder<SavedJobsCubit, SavedJobsState>(
            builder: (context, state) {
              int count = 0;
              if (state is SavedJobsLoaded) {
                count = state.savedJobs.length;
              }
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Text(
                    '$count items',
                    style: const TextStyle(
                      fontFamily: 'Acme',
                      color: AppColors.lavenderPurple,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<SavedJobsCubit, SavedJobsState>(
        listener: (context, state) {
          if (state is SavedJobsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is SavedJobsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.lavenderPurple),
            );
          }

          if (state is SavedJobsLoaded) {
            final savedJobs = state.savedJobs;
            
            if (savedJobs.isEmpty) {
              return _buildEmptyState();
            }

            return Column(
              children: [
                // Job Count
                Padding(
                  padding: const EdgeInsets.all(AppStyles.spacingMD),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${savedJobs.length} saved job${savedJobs.length != 1 ? 's' : ''}',
                      style: const TextStyle(
                        fontFamily: 'Acme', // Text font
                        color: AppColors.grey6,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                // Saved Jobs List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: AppStyles.spacingMD),
                    itemCount: savedJobs.length,
                    itemBuilder: (context, index) {
                      final job = savedJobs[index];
                      return _buildSavedJobCard(context, job);
                    },
                  ),
                ),
              ],
            );
          }
          
          if (state is SavedJobsError) {
             return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.urgentRed, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading saved jobs',
                      style: const TextStyle(color: AppColors.white, fontFamily: 'Aclonica'),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => context.read<SavedJobsCubit>().loadSavedJobs(widget.userId),
                      child: const Text('Retry'),
                    )
                  ],
                ),
             );
          }

          // Initial or other
          return const Center(child: CircularProgressIndicator(color: AppColors.lavenderPurple));
        },
      ),
    );
  }

  Widget _buildSavedJobCard(BuildContext context, JobPost job) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.grey4,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Job Title and Company (using Category as substitute for company if needed)
          Text(
            job.title,
            style: const TextStyle(
              fontFamily: 'Aclonica', // Title font
              color: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            job.category,
            style: const TextStyle(
              fontFamily: 'Acme', // Text font
              color: AppColors.grey6,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 14),

          // Location and Posted Time
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: AppColors.lavenderPurple, size: 16),
              const SizedBox(width: 6),
              Text(
                job.location ?? 'Remote',
                style: const TextStyle(
                  fontFamily: 'Acme', // Text font
                  color: AppColors.grey6,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 20),
              const Icon(Icons.access_time, color: AppColors.lavenderPurple, size: 16),
              const SizedBox(width: 6),
              Text(
                job.postedTime,
                style: const TextStyle(
                  fontFamily: 'Acme', // Text font
                  color: AppColors.grey6,
                  fontSize: 13,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Deadline
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, color: AppColors.lavenderPurple, size: 16),
              const SizedBox(width: 6),
              Text(
                job.deadlineText,
                style: const TextStyle(
                  fontFamily: 'Acme', // Text font
                  color: AppColors.grey6,
                  fontSize: 13,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Salary and Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                job.salaryText,
                style: const TextStyle(
                  fontFamily: 'Aclonica', // Title font for emphasis
                  color: AppColors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  // Delete Button
                  IconButton(
                    onPressed: () => _showDeleteDialog(context, job),
                    icon: const Icon(Icons.delete_outline),
                    color: AppColors.grey6,
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.grey5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // View Details Button
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JobDetailsScreen(job: _jobToDisplayMap(job)),
                        ),
                      );
                    },
                    icon: const Icon(Icons.arrow_forward),
                    color: AppColors.white,
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.grey5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: AppColors.grey6.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No saved jobs yet',
            style: TextStyle(
              fontFamily: 'Aclonica', // Title font
              color: AppColors.grey6,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start saving jobs to see them here',
            style: TextStyle(
              fontFamily: 'Acme', // Text font
              color: AppColors.grey7,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
