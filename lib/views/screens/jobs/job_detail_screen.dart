import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../commons/themes/style_simple/colors.dart';
import '../../../commons/themes/style_simple/styles.dart';
import 'apply_job_screen.dart';
import 'saved_jobs_screen.dart';

class JobDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> job;

  const JobDetailsScreen({
    super.key,
    required this.job,
  });

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Job Details',
          style: TextStyle(
            fontFamily: 'Aclonica', // Title font
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? AppColors.urgentRed : AppColors.white,
            ),
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Job Header Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.grey4,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.grey5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Company
                  Text(
                    widget.job['title'],
                    style: const TextStyle(
                      fontFamily: 'Aclonica', // Title font
                      color: AppColors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        widget.job['company'],
                        style: const TextStyle(
                          fontFamily: 'Acme', // Text font
                          color: AppColors.grey6,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.star,
                          color: AppColors.yellow1, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        widget.job['rating'].toString(),
                        style: const TextStyle(
                          fontFamily: 'Acme', // Text font
                          color: AppColors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Info Chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildInfoChip(
                        Icons.location_on_outlined,
                        widget.job['location'],
                      ),
                      _buildInfoChip(
                        Icons.work_outline,
                        widget.job['type'],
                      ),
                      _buildInfoChip(
                        Icons.access_time,
                        widget.job['postedTime'],
                      ),
                      _buildInfoChip(
                        Icons.people_outline,
                        '${widget.job['positions']} position',
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Salary
                  Row(
                    children: [
                      const Icon(Icons.payments_outlined,
                          color: AppColors.lavenderPurple, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        widget.job['salary'],
                        style: const TextStyle(
                          fontFamily: 'Aclonica', // Title font for emphasis
                          color: AppColors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Deadline Banner
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.urgentRed.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: AppColors.urgentRed.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.event,
                            color: AppColors.urgentRed, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Deadline: ${widget.job['deadline']}',
                          style: const TextStyle(
                            fontFamily: 'Acme', // Text font
                            color: AppColors.urgentRed,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Contact Information
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2D1B3D),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF4A2D5C)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contact Information',
                    style: TextStyle(
                      fontFamily: 'Aclonica', // Title font
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.phone_outlined,
                          color: AppColors.lavenderPurple, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        widget.job['phone'],
                        style: const TextStyle(
                          fontFamily: 'Acme', // Text font
                          color: AppColors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.email_outlined,
                          color: AppColors.lavenderPurple, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        widget.job['email'],
                        style: const TextStyle(
                          fontFamily: 'Acme', // Text font
                          color: AppColors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Description Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontFamily: 'Aclonica', // Title font
                      color: AppColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.job['fullDescription'],
                    style: const TextStyle(
                      fontFamily: 'Acme', // Text font
                      color: AppColors.grey7,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Requirements Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Requirements',
                    style: TextStyle(
                      fontFamily: 'Aclonica', // Title font
                      color: AppColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Skills Required
                  const Text(
                    'Skills Required',
                    style: TextStyle(
                      fontFamily: 'Acme', // Text font
                      color: AppColors.grey6,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        (widget.job['requirements']['skills'] as List<String>)
                            .map((skill) => _buildSkillChip(skill))
                            .toList(),
                  ),

                  const SizedBox(height: 16),

                  // Experience
                  const Text(
                    'Experience',
                    style: TextStyle(
                      fontFamily: 'Acme', // Text font
                      color: AppColors.grey6,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.job['requirements']['experience'],
                    style: const TextStyle(
                      fontFamily: 'Acme', // Text font
                      color: AppColors.white,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Languages
                  const Text(
                    'Languages',
                    style: TextStyle(
                      fontFamily: 'Acme', // Text font
                      color: AppColors.grey6,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (widget.job['requirements']['languages']
                            as List<String>)
                        .map((lang) => _buildLanguageChip(lang))
                        .toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Time Commitment Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Time Commitment',
                    style: TextStyle(
                      fontFamily: 'Aclonica', // Title font
                      color: AppColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.access_time_outlined,
                          color: AppColors.lavenderPurple, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        widget.job['requirements']['timeCommitment'],
                        style: const TextStyle(
                          fontFamily: 'Acme', // Text font
                          color: AppColors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (widget.job['requirements']['availability']
                            as List<String>)
                        .map((day) => _buildAvailabilityChip(day))
                        .toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            // Action Buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Share Button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Share functionality
                      },
                      icon: const Icon(Icons.share_outlined, size: 20),
                      label: const Text(
                        'Share',
                        style: TextStyle(fontFamily: 'Acme'), // Text font
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.white,
                        side: const BorderSide(color: AppColors.grey5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Contact Button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Contact functionality
                      },
                      icon: const Icon(Icons.message_outlined, size: 20),
                      label: const Text(
                        'Contact',
                        style: TextStyle(fontFamily: 'Acme'), // Text font
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.white,
                        side: const BorderSide(color: AppColors.grey5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Report Button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Report functionality
                      },
                      icon: const Icon(Icons.flag_outlined, size: 20),
                      label: const Text(
                        'Report',
                        style: TextStyle(fontFamily: 'Acme'), // Text font
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.white,
                        side: const BorderSide(color: AppColors.grey5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Apply Now Button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ApplyJobScreen(job: widget.job),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lavenderPurple,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Apply Now',
                    style: TextStyle(
                      fontFamily: 'Aclonica', // Title font for buttons
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.grey5,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.lavenderPurple, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Acme', // Text font
              color: AppColors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String skill) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.lavenderPurple.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lavenderPurple.withOpacity(0.5)),
      ),
      child: Text(
        skill,
        style: const TextStyle(
          fontFamily: 'Acme', // Text font
          color: AppColors.lavenderPurple,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildLanguageChip(String language) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.grey5,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        language,
        style: const TextStyle(
          fontFamily: 'Acme', // Text font
          color: AppColors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildAvailabilityChip(String day) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.grey5,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        day,
        style: const TextStyle(
          fontFamily: 'Acme', // Text font
          color: AppColors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}