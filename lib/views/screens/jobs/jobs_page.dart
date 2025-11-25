import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../commons/themes/style_simple/colors.dart';
import '../../../commons/themes/style_simple/styles.dart';
import 'saved_jobs_screen.dart';
import 'job_detail_screen.dart';
import 'apply_job_screen.dart';

class JobsPage extends StatefulWidget {
  const JobsPage({super.key});

  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  String selectedFilter = 'All';
  String sortBy = 'Most Recent';
  
  // Track favorited jobs
  Set<String> favoritedJobIds = {};

  // Sample job data
  final List<Map<String, dynamic>> jobs = [
    {
      'id': '1',
      'title': 'Graphic Design Task',
      'company': 'Creative Studio',
      'description':
          'Design promotional materials for upcoming event. Quick turnaround needed.',
      'location': 'Oran, Algeria',
      'phone': '+213 555 678 901',
      'postedTime': 'Just now',
      'deadline': '2 days left',
      'salary': '8000 DA',
      'type': 'Task',
      'isUrgent': true,
      'rating': 4.5,
      'positions': 1,
      'email': 'jobs@creativestudio.dz',
      'requirements': {
        'skills': ['Graphic Design', 'Adobe Photoshop', 'Illustration'],
        'experience': '1-2 years in graphic design',
        'languages': ['English', 'French'],
        'timeCommitment': '10 hours per week',
        'availability': ['Weekdays', 'Flexible'],
      },
      'fullDescription':
          'We\'re looking for a talented graphic designer to create promotional materials for our upcoming event. You\'ll be responsible for designing posters, social media graphics, and digital banners that capture attention and drive engagement.',
    },
    {
      'id': '2',
      'title': 'Content Writer',
      'company': 'Lan Hayiti',
      'description':
          'We are looking for a talented Content Writer experienced in crafting compelling content...',
      'location': 'Algiers, Algeria',
      'phone': '+213 555 456 789',
      'postedTime': '1 day ago',
      'deadline': '3 days left',
      'salary': '5000 DA',
      'type': 'Task',
      'isUrgent': true,
      'rating': 4.2,
      'positions': 2,
      'email': 'contact@lanhayiti.dz',
      'requirements': {
        'skills': ['Content Writing', 'SEO', 'Research'],
        'experience': '2-3 years in content writing',
        'languages': ['English', 'Arabic', 'French'],
        'timeCommitment': '15 hours per week',
        'availability': ['Weekdays', 'Weekends'],
      },
      'fullDescription':
          'We\'re seeking a creative content writer to join our team. You\'ll create engaging blog posts, articles, and web content that resonates with our audience and drives traffic to our platforms.',
    },
    {
      'id': '3',
      'title': 'Social Media Manager',
      'company': 'TechStart',
      'description':
          'Manage social media accounts, create engaging content, and grow our online presence...',
      'location': 'Algiers, Algeria',
      'phone': '+213 555 567 890',
      'postedTime': '5 days ago',
      'deadline': '2 weeks left',
      'salary': '40000 DA/mo',
      'type': 'Part-Time',
      'isUrgent': false,
      'rating': 4.7,
      'positions': 1,
      'email': 'jobs@techstart.dz',
      'requirements': {
        'skills': [
          'Social Media Marketing',
          'Content Creation',
          'Analytics',
          'Canva'
        ],
        'experience': '2-3 years in social media management',
        'languages': ['English', 'French', 'Arabic'],
        'timeCommitment': '20 hours per week',
        'availability': ['Weekdays', 'Weekends', 'Flexible'],
      },
      'fullDescription':
          'We\'re looking for a creative and strategic Social Media Manager to join our marketing team. You\'ll be responsible for managing our social media presence across multiple platforms, creating engaging content, and analyzing performance metrics.\n\nThis role requires someone who understands the Algerian market and can create content that resonates with our local audience while maintaining our global brand identity.',
    },
    {
      'id': '4',
      'title': 'Mobile App Tester',
      'company': 'AppDev Solutions',
      'description':
          'Test mobile applications and report bugs. No coding required.',
      'location': 'Setif, Algeria',
      'phone': '+213 555 890 123',
      'postedTime': '6 days ago',
      'deadline': '3 weeks left',
      'salary': '4500 DA',
      'type': 'Task',
      'isUrgent': false,
      'rating': 4.0,
      'positions': 3,
      'email': 'testing@appdev.dz',
      'requirements': {
        'skills': ['Manual Testing', 'Bug Reporting', 'Attention to Detail'],
        'experience': 'No experience required',
        'languages': ['English'],
        'timeCommitment': '5 hours per week',
        'availability': ['Weekdays', 'Flexible'],
      },
      'fullDescription':
          'Join our testing team to help ensure our mobile applications are bug-free and user-friendly. You\'ll test various features, identify issues, and provide detailed feedback to our development team.',
    },
  ];

  List<Map<String, dynamic>> get filteredJobs {
    var filtered = jobs;

    if (selectedFilter == 'Part Time') {
      filtered = filtered.where((job) => job['type'] == 'Part-Time').toList();
    } else if (selectedFilter == 'Tasks') {
      filtered = filtered.where((job) => job['type'] == 'Task').toList();
    }

    if (sortBy == 'Most Recent') {
      // Already in order
    }

    return filtered;
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
        title: const Text(
          'Career',
          style: TextStyle(
            fontFamily: 'Aclonica',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            favoritedJobIds.isEmpty ? Icons.favorite_border : Icons.favorite,
            color: favoritedJobIds.isEmpty ? AppColors.white : AppColors.urgentRed,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SavedJobsScreen(),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters and Sort
          Padding(
            padding: const EdgeInsets.all(AppStyles.spacingMD),
            child: Row(
              children: [
                // Filter Button
                Expanded(
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.grey4,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: AppColors.grey5),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.filter_list, color: AppColors.white, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Filters',
                          style: TextStyle(
                            fontFamily: 'Aclonica',
                            color: AppColors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(width: 16),
                
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
                      value: sortBy,
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
                        setState(() {
                          sortBy = value!;
                        });
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
                _buildFilterChip('All'),
                const SizedBox(width: 8),
                _buildFilterChip('Part Time'),
                const SizedBox(width: 8),
                _buildFilterChip('Tasks'),
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
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppStyles.spacingMD),
              itemCount: filteredJobs.length,
              itemBuilder: (context, index) {
                final job = filteredJobs[index];
                return _buildJobCard(context, job);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.lavenderPurple : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.lavenderPurple : AppColors.grey5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Acme',
            color: isSelected ? AppColors.black : AppColors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildJobCard(BuildContext context, Map<String, dynamic> job) {
    final isFavorited = favoritedJobIds.contains(job['id']);
    
    return GestureDetector(
      onTap: () {
        // Navigate to Job Details when card is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JobDetailsScreen(job: job),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: job['isUrgent'] ? const Color(0xFF2D1B3D) : AppColors.grey4,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: job['isUrgent'] ? const Color(0xFF4A2D5C) : AppColors.grey5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job['title'],
                        style: const TextStyle(
                          fontFamily: 'Aclonica',
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        job['company'],
                        style: const TextStyle(
                          fontFamily: 'Acme',
                          color: AppColors.grey6,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                if (job['isUrgent'])
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.urgentRed,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.warning_rounded,
                            color: AppColors.white, size: 14),
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
              job['description'],
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
                const Icon(Icons.location_on_outlined,
                    color: AppColors.grey6, size: 16),
                const SizedBox(width: 4),
                Text(
                  job['location'],
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
                  job['postedTime'],
                  style: const TextStyle(
                    fontFamily: 'Acme',
                    color: AppColors.grey6,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
            // Phone and Deadline
            Row(
              children: [
                const Icon(Icons.phone_outlined,
                    color: AppColors.grey6, size: 16),
                const SizedBox(width: 4),
                Text(
                  job['phone'],
                  style: const TextStyle(
                    fontFamily: 'Acme',
                    color: AppColors.grey6,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.calendar_today_outlined,
                    color: AppColors.grey6, size: 16),
                const SizedBox(width: 4),
                Text(
                  job['deadline'],
                  style: const TextStyle(
                    fontFamily: 'Acme',
                    color: AppColors.grey6,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Salary and Type
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  job['salary'],
                  style: const TextStyle(
                    fontFamily: 'Aclonica',
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.lavenderPurple,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    job['type'],
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
                      setState(() {
                        if (isFavorited) {
                          favoritedJobIds.remove(job['id']);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Job removed from saved',style: TextStyle(fontFamily: 'Aclonica'),),
                              backgroundColor:  AppColors.lavenderPurple,
                              duration: Duration(seconds: 1),
                            ),
                          );
                        } else {
                          favoritedJobIds.add(job['id']);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Job saved successfully',style: TextStyle(fontFamily: 'Aclonica'),),
                              backgroundColor:  AppColors.lavenderPurple,
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }
                      });
                    },
                    icon: Icon(
                      isFavorited ? Icons.favorite : Icons.favorite_border,
                    ),
                    color: isFavorited ? AppColors.urgentRed : AppColors.white,
                    iconSize: 24,
                  ),
                ),
                const SizedBox(width: 12),
                // Apply Now Button
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ApplyJobScreen(job: job),
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
  }
}