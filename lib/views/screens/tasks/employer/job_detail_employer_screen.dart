import 'package:flutter/material.dart';
import '../../../../data/models/job_post.dart';
import '../../employer/create_job_screen.dart';

class JobDetailEmployerScreen extends StatefulWidget {
  final JobPost job;

  const JobDetailEmployerScreen({super.key, required this.job});

  @override
  State<JobDetailEmployerScreen> createState() =>
      _JobDetailEmployerScreenState();
}

class _JobDetailEmployerScreenState extends State<JobDetailEmployerScreen> {
  late JobPost _job;

  @override
  void initState() {
    super.initState();
    _job = widget.job;
  }

  Future<void> _navigateToEdit() async {
    // TODO: Implement job editing
    // Navigate to CreateJobScreen once it's fully implemented
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Job editing coming soon')),
    );
  }

  Future<void> _deleteJob() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2F2F2F),
        title: const Text(
          'Delete Job Post',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        content: const Text(
          'Are you sure you want to delete this job post? This action cannot be undone.',
          style: TextStyle(
            color: Color(0xFFBFBFBF),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Color(0xFF6C6C6C),
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Color(0xFFC63F47),
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      // TODO: Delete job from backend
      Navigator.pop(context, true);
    }
  }

  void _changeStatus(JobStatus newStatus) {
    setState(() {
      _job = _job.copyWith(status: newStatus);
    });
    // TODO: Update job status in backend
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
        title: const Text(
          'Job Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFFABD600)),
            onPressed: _navigateToEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Color(0xFFC63F47)),
            onPressed: _deleteJob,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _job.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _job.location ?? 'Location not specified',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFFBFBFBF),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_job.isUrgent)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC63F47),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error_outline,
                            color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'Urgent',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),

            // Status Change
            _buildStatusSelector(),
            const SizedBox(height: 24),

            // Applications Count
            _buildInfoCard(
              'Applications Received',
              '${_job.applicantsCount} students applied',
              Icons.people_outline,
              const Color(0xFFABD600),
            ),
            const SizedBox(height: 16),

            // Salary
            _buildInfoCard(
              'Salary',
              '\$${_job.pay.toStringAsFixed(2)}',
              Icons.attach_money,
              const Color(0xFFABD600),
            ),
            const SizedBox(height: 24),

            // Description
            _buildSection(
              'Description',
              _job.description,
            ),
            const SizedBox(height: 24),

            // Job Type
            _buildSectionTitle('Job Type'),
            const SizedBox(height: 12),
            _buildChip(
              _job.jobType.label,
              const Color(0xFFABD600),
              const Color(0xFF1A1A1A),
            ),
            const SizedBox(height: 24),

            // Category
            _buildSectionTitle('Category'),
            const SizedBox(height: 12),
            _buildChip(
              _job.category,
              const Color(0xFF3D3D3D),
              Colors.white,
            ),
            const SizedBox(height: 24),

            // Languages Required
            if (_job.languages.isNotEmpty) ...[
              _buildSectionTitle('Languages Required'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _job.languages
                    .map(
                      (lang) => _buildChip(
                        lang,
                        const Color(0xFF2F2F2F),
                        Colors.white,
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 24),
            ],

            // Time Commitment
            _buildSectionTitle('Time Commitment'),
            const SizedBox(height: 12),
            _buildDetailRow(
              'Commitment',
              _job.timeCommitment ?? 'Not specified',
            ),
            if (_job.startDate != null)
              _buildDetailRow(
                'Start Date',
                '${_job.startDate!.day}/${_job.startDate!.month}/${_job.startDate!.year}',
              ),
            const SizedBox(height: 24),

            // Additional Details
            _buildSectionTitle('Additional Details'),
            const SizedBox(height: 12),
            _buildDetailRow(
              'Number of Positions',
              '${_job.numberOfPositions}',
            ),
            if (_job.requiresCv) _buildDetailRow('CV Required', 'Yes'),
            if (_job.isRecurring) _buildDetailRow('Recurring', 'Yes'),
            _buildDetailRow(
              'Posted On',
              '${_job.createdDate.day}/${_job.createdDate.month}/${_job.createdDate.year}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Status',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: JobStatus.values.map((status) {
            final isSelected = _job.status == status;
            Color backgroundColor;
            Color textColor;

            switch (status) {
              case JobStatus.active:
                backgroundColor = isSelected
                    ? const Color(0xFFABD600)
                    : const Color(0xFFABD600).withOpacity(0.2);
                textColor = isSelected
                    ? const Color(0xFF1A1A1A)
                    : const Color(0xFFABD600);
                break;
              case JobStatus.closed:
                backgroundColor = isSelected
                    ? const Color(0xFFC63F47)
                    : const Color(0xFFC63F47).withOpacity(0.2);
                textColor = isSelected ? Colors.white : const Color(0xFFC63F47);
                break;
            }

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => _changeStatus(status),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(8),
                      border: isSelected
                          ? Border.all(color: textColor, width: 2)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        status.label,
                        style: TextStyle(
                          fontSize: 13,
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2F2F2F),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6C6C6C),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        const SizedBox(height: 12),
        Text(
          content,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFFBFBFBF),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Colors.white,
      ),
    );
  }

  Widget _buildChip(String label, Color backgroundColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6C6C6C),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
