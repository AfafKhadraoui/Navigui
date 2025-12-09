import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../commons/themes/style_simple/colors.dart';
import '../../../data/models/applications_model.dart';

class ApplicantProfileScreen extends StatelessWidget {
  final Application application;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const ApplicantProfileScreen({
    super.key,
    required this.application,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Applicant Profile',
          style: GoogleFonts.aclonica(
            fontSize: 22,
            color: AppColors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header Card
            Container(
              decoration: BoxDecoration(
                color: AppColors.grey3,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _getStatusColor(application.status),
                  width: 2,
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              application.studentName,
                              style: GoogleFonts.aclonica(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                            Text(
                              '${application.university} • ${application.major}',
                              style: GoogleFonts.acme(
                                fontSize: 14,
                                color: AppColors.grey6,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(application.status)
                              .withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          application.status.label,
                          style: GoogleFonts.acme(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: _getStatusColor(application.status),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Contact Info
                  _buildContactInfo(),
                  const SizedBox(height: 16),

                  // Application Date
                  _buildInfoRow(
                    Icons.calendar_today_outlined,
                    'Applied On',
                    DateFormat('MMMM d, yyyy • h:mm a')
                        .format(application.appliedDate),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Experience Section
            _buildSection(
              title: 'Experience',
              content: application.experience,
            ),
            const SizedBox(height: 20),

            // Skills Section
            _buildSkillsSection(),
            const SizedBox(height: 20),

            // Cover Letter Section
            _buildSection(
              title: 'Cover Letter',
              content: application.coverLetter,
            ),
            const SizedBox(height: 20),

            // CV and Attachments
            if (application.cvAttached)
              _buildSection(
                title: 'Attachments',
                content: 'CV Attached',
                icon: Icons.attach_file,
              ),

            const SizedBox(height: 24),

            // Action Buttons
            if (application.status == ApplicationStatus.pending)
              _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.email_outlined, 'Email', application.email),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(color: AppColors.grey5),
          ),
          _buildInfoRow(Icons.phone_outlined, 'Phone', application.phone),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.electricLime),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.acme(
                fontSize: 11,
                color: AppColors.grey6,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.acme(
                fontSize: 13,
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: AppColors.electricLime),
              const SizedBox(width: 8),
            ],
            Text(
              title,
              style: GoogleFonts.aclonica(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.grey3,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.grey5),
          ),
          padding: const EdgeInsets.all(12),
          child: Text(
            content,
            style: GoogleFonts.acme(
              fontSize: 13,
              color: AppColors.grey6,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Skills',
          style: GoogleFonts.aclonica(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: application.skills
              .map(
                (skill) => Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.electricLime.withOpacity(0.2),
                    border: Border.all(color: AppColors.electricLime),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    skill,
                    style: GoogleFonts.acme(
                      fontSize: 12,
                      color: AppColors.electricLime,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onReject,
            icon: const Icon(Icons.close),
            label: const Text('Reject'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onAccept,
            icon: const Icon(Icons.check),
            label: const Text('Accept'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.pending:
        return const Color(0xFFFFA500);
      case ApplicationStatus.accepted:
        return const Color(0xFF4CAF50);
      case ApplicationStatus.rejected:
        return const Color(0xFFE53935);
    }
  }
}
