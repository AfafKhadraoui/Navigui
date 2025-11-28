import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../commons/themes/style_simple/colors.dart';
import '../../../models/job_post.dart';

class JobApplicationsScreen extends StatelessWidget {
  final JobPost jobPost;

  const JobApplicationsScreen({
    super.key,
    required this.jobPost,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Applications for ${jobPost.title}',
          style: GoogleFonts.aclonica(
            fontSize: 22,
            color: AppColors.white,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.assignment_ind_outlined,
              size: 64,
              color: AppColors.electricLime,
            ),
            const SizedBox(height: 16),
            Text(
              'Applications for ${jobPost.title}',
              style: GoogleFonts.aclonica(
                fontSize: 20,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'List of students that applied to this job',
              style: GoogleFonts.acme(
                fontSize: 14,
                color: AppColors.grey6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
