import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../commons/themes/style_simple/colors.dart';
import '../../../commons/themes/style_simple/styles.dart';
import '../../../logic/cubits/job/job_cubit.dart';
import '../../../logic/cubits/job/job_state.dart';
import '../../../data/models/job_post.dart';
import '../../../core/dependency_injection.dart';
import '../../../logic/cubits/saved_jobs/saved_jobs_cubit.dart';
import '../../../logic/cubits/saved_jobs/saved_jobs_state.dart';
import '../../../logic/services/secure_storage_service.dart';
import 'saved_jobs_screen.dart';
import 'apply_job_screen.dart';

class JobsPage extends StatefulWidget {
  const JobsPage({super.key});

  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _debounce;
  String? _userId; // Store user ID for saved jobs
  
  @override
  void initState() {
    super.initState();
    _loadUserId();
  }
  
  Future<void> _loadUserId() async {
    // Get user ID from secure storage
    final secureStorage = getIt<SecureStorageService>();
    final userId = await secureStorage.getUserId();
    setState(() {
      _userId = userId;
    });
    // Load saved jobs if user is logged in
    if (userId != null && mounted) {
      context.read<SavedJobsCubit>().loadSavedJobs(userId);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // Helper method to extract numeric salary from JobPost
  int _extractSalary(JobPost job) {
    return job.pay.toInt();
  }

  // Helper method to extract deadline days from JobPost
  int _extractDeadlineDays(JobPost job) {
    if (job.applicationDeadline == null) return 999;
    final daysUntilDeadline = job.applicationDeadline!.difference(DateTime.now()).inDays;
    return daysUntilDeadline > 0 ? daysUntilDeadline : 999;
  }

  // Apply client-side filtering and sorting
  List<JobPost> _applyFiltersAndSort(List<JobPost> jobs, JobLoaded state) {
    var filtered = jobs;

    // Apply search filter using LOCAL state, not cubit state
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((job) {
        final title = job.title.toLowerCase();
        final description = job.description.toLowerCase();
        final query = searchQuery.toLowerCase();
        
        // Split into words and check if any word starts with the query
        final titleWords = title.split(' ');
        final descWords = description.split(' ');
        
        // Match if any word in title or description starts with the search query
        return titleWords.any((word) => word.startsWith(query)) || 
               descWords.any((word) => word.startsWith(query));
      }).toList();
    }

    // Apply category filter
    if (state.categoryFilter != null && state.categoryFilter != 'All') {
      if (state.categoryFilter == 'Part Time') {
        filtered = filtered.where((job) => job.jobType == JobType.partTime).toList();
      } else if (state.categoryFilter == 'Tasks') {
        filtered = filtered.where((job) => job.jobType == JobType.quickTask).toList();
      }
    }

    // Apply sorting
    if (state.sortBy == 'Highest Pay') {
      filtered.sort((a, b) {
        final aSalary = _extractSalary(a);
        final bSalary = _extractSalary(b);
        return bSalary.compareTo(aSalary);
      });
    } else if (state.sortBy == 'Closest Deadline') {
      filtered.sort((a, b) {
        final aDays = _extractDeadlineDays(a);
        final bDays = _extractDeadlineDays(b);
        return aDays.compareTo(bDays);
      });
    }
    // 'Most Recent' is default order from database

    return filtered;
  }

  // Build filter chip widget
  Widget _buildFilterChip(String label, JobCubit cubit, JobLoaded state) {
    final isSelected = (state.categoryFilter ?? 'All') == label;
    return GestureDetector(
      onTap: () {
        cubit.filterByCategory(label);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.lavenderPurple : AppColors.grey4,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.lavenderPurple : AppColors.grey5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Acme',
            color: isSelected ? AppColors.white : AppColors.grey6,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<JobCubit>()..loadJobs()),
        // SavedJobsCubit is provided globally in main.dart, so we don't provider it here
        // to ensure we share the same state instance.
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          title: const Text(
            'Career',
            style: TextStyle(
              fontFamily: 'Aclonica',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          leading: BlocBuilder<SavedJobsCubit, SavedJobsState>(
            builder: (context, state) {
              final bool hasSavedJobs = state is SavedJobsLoaded && state.savedJobs.isNotEmpty;
              return IconButton(
                icon: Icon(
                  hasSavedJobs ? Icons.favorite : Icons.favorite_border,
                  color: hasSavedJobs ? AppColors.urgentRed : AppColors.white,
                ),
                onPressed: () {
                  if (_userId != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SavedJobsScreen(userId: _userId!),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please login to view saved jobs'),
                        backgroundColor: AppColors.urgentRed,
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
        body: BlocBuilder<JobCubit, JobState>(
          builder: (context, state) {
            if (state is JobLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.lavenderPurple,
                ),
              );
            }

            if (state is JobError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: AppColors.urgentRed,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading jobs',
                      style: const TextStyle(
                        fontFamily: 'Aclonica',
                        color: AppColors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: const TextStyle(
                        fontFamily: 'Acme',
                        color: AppColors.grey6,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        context.read<JobCubit>().refreshJobs();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.lavenderPurple,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is! JobLoaded) {
              return const SizedBox();
            }

            final cubit = context.read<JobCubit>();
            final filteredJobs = _applyFiltersAndSort(state.jobs, state);

            return Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppStyles.spacingMD, AppStyles.spacingMD, AppStyles.spacingMD, 8),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    onChanged: (value) {
                      // Cancel previous timer
                      if (_debounce?.isActive ?? false) _debounce!.cancel();
                      
                      // Set new timer - only update state after user stops typing
                      _debounce = Timer(const Duration(milliseconds: 300), () {
                        setState(() {
                          searchQuery = value;
                        });
                      });
                    },
                    style: const TextStyle(
                      fontFamily: 'Acme',
                      color: AppColors.white,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search jobs, companies...',
                      hintStyle: const TextStyle(
                        fontFamily: 'Acme',
                        color: AppColors.grey6,
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(Icons.search, color: AppColors.grey6, size: 20),
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: AppColors.grey6, size: 20),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  searchQuery = '';
                                });
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: AppColors.grey4,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: AppColors.grey5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: AppColors.grey5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: AppColors.lavenderPurple, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ),

                // Filters and Sort
                Padding(
                  padding: const EdgeInsets.all(AppStyles.spacingMD),
                  child: Row(
                    children: [
                      // Sort Dropdown
                      Expanded(
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.grey4,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: AppColors.grey5),
                          ),
                          child: DropdownButton<String>(
                            value: state.sortBy ?? 'Most Recent',
                            dropdownColor: AppColors.grey4,
                            underline: const SizedBox(),
                            isExpanded: true,
                            isDense: true,
                            style: const TextStyle(
                              fontFamily: 'Aclonica',
                              color: AppColors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors.white,
                              size: 20,
                            ),
                            items: ['Most Recent', 'Highest Pay', 'Closest Deadline']
                                .map((value) => DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                cubit.sortJobs(value);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Filter Tabs
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppStyles.spacingMD),
                  child: Row(
                    children: [
                      _buildFilterChip('All', cubit, state),
                      const SizedBox(width: 8),
                      _buildFilterChip('Part Time', cubit, state),
                      const SizedBox(width: 8),
                      _buildFilterChip('Tasks', cubit, state),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Job Count
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppStyles.spacingMD),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${filteredJobs.length} jobs found',
                      style: const TextStyle(
                        fontFamily: 'Acme',
                        color: AppColors.grey6,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Jobs List
                Expanded(
                  child: filteredJobs.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.work_outline,
                                size: 64,
                                color: AppColors.grey6,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No jobs found',
                                style: TextStyle(
                                  fontFamily: 'Aclonica',
                                  color: AppColors.white,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Try adjusting your filters',
                                style: TextStyle(
                                  fontFamily: 'Acme',
                                  color: AppColors.grey6,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            await cubit.refreshJobs();
                          },
                          color: AppColors.lavenderPurple,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: AppStyles.spacingMD),
                            itemCount: filteredJobs.length,
                            itemBuilder: (context, index) {
                              return _buildJobCard(filteredJobs[index]);
                            },
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildJobCard(JobPost job) {
    return BlocBuilder<SavedJobsCubit, SavedJobsState>(
      builder: (context, savedState) {
        final isSaved = savedState is SavedJobsLoaded && savedState.isJobSaved(job.id);
        
        return GestureDetector(
      onTap: () {
        // Navigate to job details
        // Navigator.push(context, MaterialPageRoute(builder: (_) => JobDetailScreen(job: job)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.grey4,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.grey5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: const TextStyle(
                          fontFamily: 'Aclonica',
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        job.category,
                        style: const TextStyle(
                          fontFamily: 'Acme',
                          color: AppColors.grey6,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                if (job.isUrgent)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.urgentRed,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.warning_rounded, color: AppColors.white, size: 14),
                        SizedBox(width: 4),
                        Text(
                          'Urgent',
                          style: TextStyle(
                            fontFamily: 'Acme',
                            color: AppColors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
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
              job.briefDescription ?? job.description,
              style: const TextStyle(
                fontFamily: 'Acme',
                color: AppColors.grey7,
                fontSize: 14,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 12),

            // Location and Time
            Row(
              children: [
                const Icon(Icons.location_on_outlined, color: AppColors.grey6, size: 16),
                const SizedBox(width: 4),
                Text(
                  job.location ?? 'Remote',
                  style: const TextStyle(
                    fontFamily: 'Acme',
                    color: AppColors.grey6,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.access_time, color: AppColors.grey6, size: 16),
                const SizedBox(width: 4),
                Text(
                  job.postedTime,
                  style: const TextStyle(
                    fontFamily: 'Acme',
                    color: AppColors.grey6,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Deadline
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined, color: AppColors.grey6, size: 16),
                const SizedBox(width: 4),
                Text(
                  job.deadlineText,
                  style: const TextStyle(
                    fontFamily: 'Acme',
                    color: AppColors.grey6,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Footer Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Salary
                Text(
                  job.salaryText,
                  style: const TextStyle(
                    fontFamily: 'Aclonica',
                    color: AppColors.lavenderPurple,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Job Type Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.lavenderPurple,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    job.jobType.displayName,
                    style: const TextStyle(
                      fontFamily: 'Acme',
                      color: AppColors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Action Buttons
            Row(
              children: [
                // Heart/Favorite Button
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.grey5,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (_userId != null) {
                        context.read<SavedJobsCubit>().toggleSaveJob(job.id, _userId!);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isSaved ? 'Job removed from saved' : 'Job saved successfully',
                              style: const TextStyle(fontFamily: 'Aclonica'),
                            ),
                            backgroundColor: AppColors.lavenderPurple,
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                    icon: Icon(
                      isSaved ? Icons.favorite : Icons.favorite_border,
                    ),
                    color: isSaved ? AppColors.urgentRed : AppColors.white,
                    iconSize: 24,
                  ),
                ),
                const SizedBox(width: 12),
                // Apply Now Button
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // Convert JobPost to Map for ApplyJobScreen compatibility
                      final jobMap = {
                        'id': job.id,
                        'title': job.title,
                        'company': job.category,
                        'description': job.description,
                        'location': job.location ?? 'Remote',
                        'salary': job.salaryText,
                        'type': job.jobType.displayName,
                      };
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ApplyJobScreen(job: jobMap),
                        ),
                      );
                    },
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.lavenderPurple,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'Apply Now',
                          style: TextStyle(
                            fontFamily: 'Aclonica',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
        );
      },
    );
  }
}