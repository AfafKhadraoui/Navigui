import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../commons/themes/style_simple/colors.dart';

/// Employer Jobs Screen
/// Shows list of posted jobs + ability to post new ones
class EmployerJobsScreen extends StatelessWidget {
  const EmployerJobsScreen({super.key});

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.work_outline,
              size: 64,
              color: AppColors.electricLime,
            ),
            const SizedBox(height: 16),
            Text(
              'Employer Jobs Screen',
              style: GoogleFonts.aclonica(
                fontSize: 20,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'View and manage your posted jobs',
              style: GoogleFonts.acme(
                fontSize: 14,
                color: AppColors.grey6,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to create job screen
        },
        backgroundColor: AppColors.electricLime,
        icon: const Icon(Icons.add, color: Colors.black),
        label: Text(
          'Post Job',
          style: GoogleFonts.aclonica(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
