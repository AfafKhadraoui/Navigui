import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../commons/themes/style_simple/colors.dart';
import '../../../commons/themes/style_simple/styles.dart';
import '../../../data/models/job_post.dart';
import 'apply_job_screen.dart';
import 'saved_jobs_screen.dart';

class JobDetailsScreen extends StatefulWidget {
  final JobPost job;

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
                    widget.job.title,
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
                        // TODO: Add company name to JobPost or fetch from Employer
                        widget.job.category.toUpperCase().replaceAll('_', ' '),
                        style: const TextStyle(
                          fontFamily: 'Acme', // Text font
                          color: AppColors.grey6,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      if (widget.job.isUrgent)
                         Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.urgentRed.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.urgentRed),
                          ),
                          child: const Text(
                           'URGENT',
                            style: TextStyle(
                              fontFamily: 'Acme',
                              color: AppColors.urgentRed,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
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
                        widget.job.location ?? 'Remote',
                      ),
                      _buildInfoChip(
                        Icons.work_outline,
                        widget.job.jobType.displayName,
                      ),
                      _buildInfoChip(
                        Icons.access_time,
                        widget.job.postedTime,
                      ),
                      _buildInfoChip(
                        Icons.people_outline,
                        '${widget.job.numberOfPositions} position(s)',
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
                        widget.job.salaryText,
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
                  if (widget.job.deadlineText != 'No Deadline')
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
                            'Deadline: ${widget.job.deadlineText}',
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
            if (widget.job.contactPreference != null)
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
                        const Icon(Icons.contact_mail_outlined,
                            color: AppColors.lavenderPurple, size: 20),
                        const SizedBox(width: 12),
                        Text(
                          'Preference: ${widget.job.contactPreference!.name.toUpperCase()}',
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
                    widget.job.description,
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
            if (widget.job.requirements != null)
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
                  const SizedBox(height: 12),
                  Text(
                    widget.job.requirements!,
                    style: const TextStyle(
                      fontFamily: 'Acme', // Text font
                      color: AppColors.grey6,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Time & Duration Section
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Details',
                    style: TextStyle(
                      fontFamily: 'Aclonica', // Title font
                      color: AppColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  if (widget.job.timeCommitment != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time_outlined, color: AppColors.lavenderPurple, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Commitment: ${widget.job.timeCommitment}',
                            style: const TextStyle(
                              fontFamily: 'Acme',
                              color: AppColors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                  if (widget.job.duration != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          const Icon(Icons.timer_outlined, color: AppColors.lavenderPurple, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Duration: ${widget.job.duration}',
                            style: const TextStyle(
                              fontFamily: 'Acme',
                              color: AppColors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),


            const SizedBox(height: 24),
            
            // Apply Now Button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Create a compatible map for ApplyJobScreen for now
                    final jobMap = {
                      'id': widget.job.id,
                      'title': widget.job.title,
                      'company': widget.job.category,
                      'description': widget.job.description,
                      'location': widget.job.location ?? 'Remote',
                      'salary': widget.job.salaryText,
                      'type': widget.job.jobType.displayName,
                    };
                    
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ApplyJobScreen(job: jobMap),
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
}