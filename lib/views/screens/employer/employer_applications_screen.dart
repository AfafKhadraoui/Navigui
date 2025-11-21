import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../commons/themes/style_simple/colors.dart';

/// Employer Applications Screen
/// View all applications received for posted jobs
class EmployerApplicationsScreen extends StatelessWidget {
  const EmployerApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Applications',
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
              Icons.assignment_outlined,
              size: 64,
              color: AppColors.electricLime,
            ),
            const SizedBox(height: 16),
            Text(
              'Applications Screen',
              style: GoogleFonts.aclonica(
                fontSize: 20,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Review applications from students',
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
