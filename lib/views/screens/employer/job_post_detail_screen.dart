import 'package:flutter/material.dart';
import '../../../data/models/job_post.dart';
import '../../../mock/mock_data.dart';
import '../../../logic/cubits/employer_job/employer_job_cubit.dart';
import '../../../core/dependency_injection.dart';
import 'job_post_form_screen.dart';

class JobPostDetailScreen extends StatefulWidget {
  final JobPost job;

  const JobPostDetailScreen({super.key, required this.job});

  @override
  State<JobPostDetailScreen> createState() => _JobPostDetailScreenState();
}

class _JobPostDetailScreenState extends State<JobPostDetailScreen> {
  final MockData _mockData = MockData();
  late JobPost _job;

  @override
  void initState() {
    super.initState();
    _job = widget.job;
  }

  Future<void> _navigateToEdit() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JobPostFormScreen(job: _job),
      ),
    );

    if (result == true) {
      final updatedJob = _mockData.getJobById(_job.id);
      if (updatedJob != null) {
        setState(() {
          _job = updatedJob;
        });
      }
    }
  }

  Future<void> _deleteJob() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2F2F2F),
        title: const Text(
          'Delete Job Post',
          style: TextStyle(
            fontFamily: 'Aclonica',
            color: Colors.white,
          ),
        ),
        content: const Text(
          'Are you sure you want to delete this job post? This action cannot be undone.',
          style: TextStyle(
            fontFamily: 'Acme',
            color: Color(0xFFBFBFBF),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Acme',
                color: Color(0xFF6C6C6C),
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(
                fontFamily: 'Acme',
                color: Color(0xFFC63F47),
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Get the cubit from service locator
      final cubit = getIt<EmployerJobCubit>();
      
      // Set employer ID from the job object
      cubit.setEmployerId(_job.employerId);
      
      // Delete the job via cubit
      await cubit.deleteJob(_job.id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Job deleted successfully'),
            backgroundColor: Color(0xFFABD600),
          ),
        );
        Navigator.pop(context, true);
      }
    }
  }

  void _changeStatus(JobStatus newStatus) {
    setState(() {
      _job = _job.copyWith(status: newStatus);
      _mockData.updateJob(_job);
    });
  }

String _getStatusDescription() {
  // Draft posts are never visible to students
  if (_job.isDraft == true) {
    return 'Job is saved as draft and not visible to students';
  }

  switch (_job.status) {
    case JobStatus.active:
      return 'Job is visible and accepting applications';

    case JobStatus.closed:
      return 'Job is closed and no longer accepting applications';
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context, true),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: _navigateToEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Color(0xFFC63F47)),
            onPressed: _deleteJob,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2F2F2F),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: _job.isUrgent
                      ? const Color(0xFFC63F47).withValues(alpha: 0.3)
                      : const Color(0xFF3D3D3D),
                ),
                gradient: _job.isUrgent
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
                  Text(
                    _job.title,
                    style: const TextStyle(
                      fontFamily: 'Aclonica',
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _job.location ?? 'Location not specified',
                    style: const TextStyle(
                      fontFamily: 'Acme',
                      fontSize: 15,
                      color: Color(0xFFBFBFBF),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color(0xFFABD600),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _job.location ?? '',
                        style: const TextStyle(
                          fontFamily: 'Acme',
                          fontSize: 14,
                          color: Color(0xFFBFBFBF),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Category Chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildSmallChip(
                        _job.jobType.label,
                        const Color(0xFFABD600),
                        const Color(0xFF1A1A1A),
                      ),
                      _buildSmallChip(
                        _job.category,
                        const Color(0xFF2F2F2F),
                        Colors.white,
                      ),
                      if (_job.isUrgent)
                        _buildSmallChip(
                          'Active',
                          const Color(0xFFABD600),
                          const Color(0xFF1A1A1A),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Description
                  Text(
                    _job.description,
                    style: const TextStyle(
                      fontFamily: 'Acme',
                      fontSize: 14,
                      color: Color(0xFFBFBFBF),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Salary Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFABD600),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.attach_money,
                          color: Color(0xFF1A1A1A),
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '\$${_job.pay.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontFamily: 'Acme',
                            fontSize: 15,
                            color: Color(0xFF1A1A1A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // View All Applications Button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF9B7FD8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.people,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'View All Applications (${_job.applicantsCount})',
                    style: const TextStyle(
                      fontFamily: 'Acme',
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Statistics Row
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    '${_job.applicantsCount}',
                    'Applications',
                    const Color(0xFF2F2F2F),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    '${_job.numberOfPositions}',
                    'Positions',
                    const Color(0xFF2F2F2F),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    '${_job.savesCount}',
                    'Saves',
                    const Color(0xFF2F2F2F),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Job Details Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2F2F2F),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Job Details',
                    style: TextStyle(
                      fontFamily: 'Aclonica',
                      fontSize: 16,
                      color: Color(0xFFABD600),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailItem(
                    Icons.location_on,
                    'Location',
                    _job.location ?? '',
                  ),
                  const SizedBox(height: 12),
                  _buildDetailItem(
                    Icons.work_outline,
                    'Job Type',
                    _job.jobType.label,
                  ),
                  const SizedBox(height: 12),
                  _buildDetailItem(
                    Icons.access_time,
                    'Time Commitment',
                    _job.timeCommitment ?? 'Not specified',
                  ),
                  const SizedBox(height: 12),
                  if (_job.languages.isNotEmpty)
                    _buildDetailItem(
                      Icons.language,
                      'Languages Required',
                      _job.languages.join(', '),
                    ),
                  if (_job.languages.isNotEmpty) const SizedBox(height: 12),
                  if (_job.requiresCv)
                    _buildDetailItem(
                      Icons.description,
                      'Requirements',
                      'CV Required',
                    ),
                  if (_job.requiresCv) const SizedBox(height: 12),
                  _buildDetailItem(
                    Icons.attach_money,
                    'Payment Details',
                    '\$${_job.pay.toStringAsFixed(2)}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Job Status Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2F2F2F),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Job Status',
                    style: TextStyle(
                      fontFamily: 'Aclonica',
                      fontSize: 16,
                      color: Color(0xFFABD600),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Current: ',
                            style: TextStyle(
                              fontFamily: 'Acme',
                              fontSize: 14,
                              color: Color(0xFFBFBFBF),
                            ),
                          ),
                          Text(
                            _job.status.label,
                            style: const TextStyle(
                              fontFamily: 'Acme',
                              fontSize: 14,
                              color: Color(0xFFABD600),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: _showStatusChangeDialog,
                        child: const Text(
                          'Change',
                          style: TextStyle(
                            fontFamily: 'Acme',
                            fontSize: 14,
                            color: Color(0xFFABD600),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _getStatusDescription(),
                    style: const TextStyle(
                      fontFamily: 'Acme',
                      fontSize: 13,
                      color: Color(0xFF6C6C6C),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStatusChangeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2F2F2F),
        title: const Text(
          'Change Job Status',
          style: TextStyle(
            fontFamily: 'Aclonica',
            color: Colors.white,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: JobStatus.values.map((status) {
            return RadioListTile<JobStatus>(
              value: status,
              groupValue: _job.status,
              activeColor: const Color(0xFFABD600),
              onChanged: (value) {
                if (value != null) {
                  _changeStatus(value);
                  Navigator.pop(context);
                }
              },
              title: Text(
                status.label,
                style: TextStyle(
                  fontFamily: 'Acme',
                  color: _job.status == status
                      ? const Color(0xFFABD600)
                      : Colors.white,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color backgroundColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF3D3D3D),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Aclonica',
              fontSize: 24,
              color: Color(0xFF9B7FD8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Acme',
              fontSize: 12,
              color: Color(0xFFBFBFBF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: const Color(0xFFABD600),
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Acme',
                  fontSize: 13,
                  color: Color(0xFF6C6C6C),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Acme',
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSmallChip(String label, Color backgroundColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Acme',
          fontSize: 12,
          color: textColor,
        ),
      ),
    );
  }

  int _getDaysSincePosted() {
    return DateTime.now().difference(_job.createdDate).inDays;
  }
}
