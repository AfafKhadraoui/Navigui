import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../commons/themes/style_simple/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../logic/models/job_post.dart';
import '../../../mock/mock_data.dart';
import '../../../routes/app_router.dart';

class MyJobPostsScreen extends StatefulWidget {
  
  const MyJobPostsScreen({super.key});

  @override
  State<MyJobPostsScreen> createState() => _MyJobPostsScreenState();
}

class _MyJobPostsScreenState extends State<MyJobPostsScreen> {
  final MockData _mockData = MockData();
  List<JobPost> _jobs = [];
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mockData.initializeSampleData();
    _loadJobs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

 void _loadJobs() {
    setState(() {
      final allJobs = _mockData.getAllJobs();
      
      if (_searchQuery.isEmpty) {
        _jobs = allJobs;
      } else {
        _jobs = allJobs.where((job) {
          final query = _searchQuery.toLowerCase();
          return job.title.toLowerCase().contains(query) ||
                 job.company.toLowerCase().contains(query) ||
                 job.location.toLowerCase().contains(query) ||
                 job.description.toLowerCase().contains(query) ||
                 (job.categories?.any((cat) => 
                   cat.label.toLowerCase().contains(query)) ?? false);
        }).toList();
      }
    });
  }
  


  Future<void> _navigateToAddJob() async {
    await context.push(AppRouter.jobPostForm);
    _loadJobs();
  }

  Future<void> _navigateToJobDetail(JobPost job) async {
    await context.push('${AppRouter.jobPostDetail}/${job.id}', extra: job);
    _loadJobs();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'My Jobs',
          style: GoogleFonts.aclonica(
            fontSize: 24,
            color: AppColors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2F2F2F),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(
                          fontFamily: 'Acme',
                          color: Colors.white,
                          fontSize: 15,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search jobs...',
                          hintStyle: const TextStyle(
                            fontFamily: 'Acme',
                            color: Color(0xFF6C6C6C),
                            fontSize: 15,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xFF6C6C6C),
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Color(0xFF6C6C6C),
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchQuery = '';
                                    });
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Jobs Count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${_jobs.length} jobs found',
                  style: const TextStyle(
                    fontFamily: 'Acme',
                    fontSize: 14,
                    color: Color(0xFF6C6C6C),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Jobs List
            Expanded(
              child: _jobs.isEmpty
                  ? Center(
                      child: Text(
                        _searchQuery.isNotEmpty
                            ? 'No jobs found matching "$_searchQuery"'
                            : 'No job posts yet. Create your first one!',
                        style: const TextStyle(
                          fontFamily: 'Acme',
                          fontSize: 16,
                          color: AppColors.textDisabled,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                      itemCount: _jobs.length,
                      itemBuilder: (context, index) {
                        final job = _jobs[index];
                        return _JobPostCard(
                          job: job,
                          onTap: () => _navigateToJobDetail(job),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddJob,
        backgroundColor: const Color(0xFFABD600),
        elevation: 6,
        child: const Icon(
          Icons.add,
          color: Color(0xFF1A1A1A),
          size: 32,
        ),
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
          color: const Color(0xFF2F2F2F),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: job.isUrgent
                ? const Color(0xFFC63F47).withOpacity(0.3)
                : const Color(0xFF3D3D3D),
          ),
          gradient: job.isUrgent
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF2F2F2F),
                    const Color(0xFF3D2020),
                  ],
                )
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Company
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: const TextStyle(
                          fontFamily: 'Aclonica',
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${job.company} • ${job.location}',
                        style: const TextStyle(
                          fontFamily: 'Acme',
                          fontSize: 13,
                          color: Color(0xFFBFBFBF),
                        ),
                      ),
                    ],
                  ),
                ),
                if (job.isUrgent)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC63F47),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.white,
                          size: 12,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Urgent',
                          style: TextStyle(
                            fontFamily: 'Acme',
                            fontSize: 11,
                            color: Colors.white,
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
                color: Color(0xFFBFBFBF),
                height: 1.4,
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
                  backgroundColor: const Color(0xFFABD600),
                  textColor: const Color(0xFF1A1A1A),
                ),

                // Categories
                ...?job.categories?.take(2).map((cat) => _Tag(
                      label: cat.label,
                      backgroundColor: const Color(0xFF3D3D3D),
                      textColor: Colors.white,
                    )),

                // More categories
                if (job.categories != null && job.categories!.length > 2)
                  _Tag(
                    label: '+${job.categories!.length - 2} more',
                    backgroundColor: const Color(0xFF3D3D3D),
                    textColor: const Color(0xFF6C6C6C),
                  ),

                // Recurring
                if (job.isRecurring)
                  const _Tag(
                    label: 'Recurring',
                    backgroundColor: Color(0xFFABD600),
                    textColor: Color(0xFF1A1A1A),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Bottom Info
            Row(
              children: [
                // Applications count
                const Icon(
                  Icons.people_outline,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  '${job.applications}',
                  style: const TextStyle(
                    fontFamily: 'Acme',
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),

                // Saves count
                const Icon(
                  Icons.favorite_border,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  '${job.saves}',
                  style: const TextStyle(
                    fontFamily: 'Acme',
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),

                // Status
                _StatusBadge(status: job.status),
              ],
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
        backgroundColor = const Color(0xFFABD600);
        textColor = const Color(0xFF1A1A1A);
        break;
      case JobStatus.filled:
        backgroundColor = const Color(0xFF6C6C6C);
        textColor = Colors.white;
        break;
      case JobStatus.closed:
        backgroundColor = const Color(0xFFC63F47).withOpacity(0.2);
        textColor = const Color(0xFFC63F47);
        break;
      case JobStatus.draft:
        backgroundColor = const Color(0xFF6C6C6C).withOpacity(0.5);
        textColor = const Color(0xFFBFBFBF);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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