import 'package:flutter/material.dart';
import '../../../commons/themes/style_simple/colors.dart';
import '../../../commons/themes/style_simple/styles.dart';
import 'job_detail_screen.dart';

class SavedJobsScreen extends StatefulWidget {
  const SavedJobsScreen({super.key});

  @override
  State<SavedJobsScreen> createState() => _SavedJobsScreenState();
}

class _SavedJobsScreenState extends State<SavedJobsScreen> {
  // Sample saved jobs data
  List<Map<String, dynamic>> savedJobs = [
    {
      'id': '1',
      'title': 'Junior UI Designer',
      'company': 'Sky',
      'location': 'Constantine, Algeria',
      'postedTime': '3 days ago',
      'deadline': '2 weeks left',
      'salary': '30000 DA/mo',
      'type': 'Full-Time',
      'description': 'We are looking for a talented UI Designer...',
      'phone': '+213 555 678 901',
      'email': 'jobs@sky.dz',
      'isUrgent': false,
      'rating': 4.5,
      'positions': 1,
    },
    {
      'id': '2',
      'title': 'Data Entry Specialist',
      'company': 'InfoSys Algeria',
      'location': 'Annaba, Algeria',
      'postedTime': '4 days ago',
      'deadline': '3 weeks left',
      'salary': '3000 DA',
      'type': 'Task',
      'description': 'Looking for detail-oriented data entry specialist...',
      'phone': '+213 555 789 012',
      'email': 'jobs@infosys.dz',
      'isUrgent': false,
      'rating': 4.0,
      'positions': 2,
    },
  ];

  void _removeSavedJob(String jobId) {
    setState(() {
      savedJobs.removeWhere((job) => job['id'] == jobId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Job removed from saved'),
        backgroundColor: AppColors.urgentRed,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Map<String, dynamic> job) {
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
          'Are you sure you want to remove "${job['title']}" from your saved jobs?',
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
              _removeSavedJob(job['id']);
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
          IconButton(
            icon: const Icon(Icons.favorite, color: AppColors.lavenderPurple),
            onPressed: () {},
          ),
        ],
      ),
      body: savedJobs.isEmpty
          ? _buildEmptyState()
          : Column(
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
            ),
    );
  }

  Widget _buildSavedJobCard(BuildContext context, Map<String, dynamic> job) {
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
          // Job Title and Company
          Text(
            job['title'],
            style: const TextStyle(
              fontFamily: 'Aclonica', // Title font
              color: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            job['company'],
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
                job['location'],
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
                job['postedTime'],
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
                job['deadline'],
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
                job['salary'],
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
                          builder: (context) => JobDetailsScreen(job: job),
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