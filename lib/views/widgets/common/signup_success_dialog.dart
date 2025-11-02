import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../commons/themes/style_simple/colors.dart';

class SignupSuccessDialog extends StatelessWidget {
  final String userName;
  final bool isStudent;
  final VoidCallback onGoToDashboard;
  final VoidCallback onStartOver;

  const SignupSuccessDialog({
    super.key,
    required this.userName,
    required this.isStudent,
    required this.onGoToDashboard,
    required this.onStartOver,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = isStudent ? AppColors.purple6 : AppColors.electricLime;
    final buttonTextColor = isStudent ? AppColors.white : AppColors.black;
    
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              
              // Success icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: themeColor,
                ),
                child: Icon(
                  Icons.check,
                  color: isStudent ? AppColors.white : AppColors.black,
                  size: 60,
                ),
              ),
            
            const SizedBox(height: 24),
            
            // Welcome message
            Text(
              'Welcome, $userName!',
              textAlign: TextAlign.center,
              style: GoogleFonts.aclonica(
                fontSize: 24,
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Success message
            Text(
              'Your account has been created successfully',
              textAlign: TextAlign.center,
              style: GoogleFonts.aclonica(
                fontSize: 14,
                color: AppColors.grey6,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Additional info
            Text(
              isStudent
                  ? "You're ready to start finding amazing opportunities and gaining experience!"
                  : "You're ready to start posting jobs and finding talented students!",
              textAlign: TextAlign.center,
              style: GoogleFonts.aclonica(
                fontSize: 12,
                color: AppColors.grey6,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Primary action only: full-width button (Start Finding Jobs / Post Your First Job)
            SizedBox(
              width: double.infinity,
              height: 64,
              child: ElevatedButton(
                onPressed: onGoToDashboard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  foregroundColor: buttonTextColor,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  isStudent ? 'Start Finding Jobs' : 'Post Your First Job',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  softWrap: true,
                  style: GoogleFonts.aclonica(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // What's Next section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF121212),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "What's Next?",
                      style: GoogleFonts.aclonica(
                      fontSize: 16,
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (isStudent) ...[
                    _buildNextStepItem('Browse available job opportunities'),
                    _buildNextStepItem('Apply to positions that match your skills'),
                    _buildNextStepItem('Build your portfolio with real experience'),
                  ] else ...[
                    _buildNextStepItem('Post your first job to start finding talent'),
                    _buildNextStepItem('Review applications from qualified students'),
                    _buildNextStepItem('Build your reputation with student reviews'),
                  ],
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Demo mode info
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF121212),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Demo Mode - Testing the flow?',
                    style: GoogleFonts.aclonica(
                      fontSize: 11,
                      color: const Color(0xFF9E9E9E),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 8),
            
            // (Removed duplicate small "Start Over" button — primary actions are in the button row above)
            const SizedBox(height: 20),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildNextStepItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isStudent ? AppColors.purple6 : AppColors.electricLime,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
                text,
                style: GoogleFonts.aclonica(
                  fontSize: 12,
                  color: AppColors.grey6,
                ),
              ),
          ),
        ],
      ),
    );
  }
}
