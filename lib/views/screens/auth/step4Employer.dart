import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../commons/themes/style_simple/colors.dart';
import '../../../routes/app_router.dart';
// copied buttons from step3 instead of using custom_button
import '../../widgets/common/signup_success_dialog.dart';

class Step4EmployerScreen extends StatefulWidget {
  const Step4EmployerScreen({super.key});

  @override
  State<Step4EmployerScreen> createState() => _Step4EmployerScreenState();
}

class _Step4EmployerScreenState extends State<Step4EmployerScreen> {
  final _industryController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _industryController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    // Navigate to success screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => SignupSuccessDialog(
          userName: 'kjhl', // TODO: Get actual name from signup data
          isStudent: false,
          onGoToDashboard: () {
            context.go(AppRouter.home); // Navigate to home
          },
          onStartOver: () {
            context.go(AppRouter.accountType); // Go back to account type
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.aclonica(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(25),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: GoogleFonts.aclonica(
              fontSize: 14,
              color: AppColors.white,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.aclonica(
                color: AppColors.grey6,
                fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Make the main content scrollable so fields and text won't overflow
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 40, bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with progress indicator
                      Text(
                        'Employer Sign Up',
                        style: GoogleFonts.aclonica(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            'Step 4 of 4',
                            style: GoogleFonts.aclonica(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: 4 / 4,
                          minHeight: 6,
                          backgroundColor: Colors.grey[800],
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFFD2FF1F),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Title
                      Center(
                        child: Text(
                          "You're almost there!",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.aclonica(
                            fontSize: 32,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Industry / Category
                      _buildTextField(
                        label: 'Industry / Category',
                        hint: 'e.g., Technology, Healthcare',
                        controller: _industryController,
                      ),

                      const SizedBox(height: 24),

                      // Business Address (Optional)
                      _buildTextField(
                        label: 'Business Address (Optional)',
                        hint: 'e.g., 123 Main St, City, Country',
                        controller: _addressController,
                      ),

                      const SizedBox(height: 12),

                      // Terms and Privacy (repeat here so visible when scrolled to top)
                      Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: GoogleFonts.aclonica(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            children: [
                              const TextSpan(text: 'By signing up, you agree to our '),
                              TextSpan(
                                text: 'Terms',
                                style: TextStyle(
                                  color: AppColors.electricLime,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              const TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                  color: AppColors.electricLime,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),

              // Buttons Row (copied from step3) — avoid using shared custom_button here
              Row(
                children: [
                  // Back Button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.electricLime,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(
                          color: AppColors.electricLime,
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Back',
                        style: GoogleFonts.aclonica(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Continue Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _handleContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.electricLime,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Continue',
                        style: GoogleFonts.aclonica(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Terms and Privacy (kept here for layout parity)
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.aclonica(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    children: [
                      const TextSpan(text: 'By signing up, you agree to our '),
                      TextSpan(
                        text: 'Terms',
                        style: TextStyle(
                          color: AppColors.electricLime,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: AppColors.electricLime,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
