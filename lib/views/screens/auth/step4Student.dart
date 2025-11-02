import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../commons/themes/style_simple/colors.dart';
import 'step5Student.dart';

class Step4StudentScreen extends StatefulWidget {
  const Step4StudentScreen({super.key});

  @override
  State<Step4StudentScreen> createState() => _Step4StudentScreenState();
}

class _Step4StudentScreenState extends State<Step4StudentScreen> {
  final _skillsController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  void dispose() {
    _skillsController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.aclonica(
            fontSize: 16,
            color: AppColors.white,
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
            maxLines: maxLines,
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: const BorderSide(
                  color: Color(0xFF9288EE),
                  width: 1.5,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 24,
                vertical: maxLines > 1 ? 16 : 16,
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
              const SizedBox(height: 40),
              
              // Header with progress indicator
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Student Sign Up',
                    style: GoogleFonts.aclonica(
                        fontSize: 20,
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        'step 4 out of 5',
                        style: GoogleFonts.aclonica(
                          fontSize: 12,
                          color: AppColors.grey6,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: 4 / 5,
                      minHeight: 6,
                      backgroundColor: Colors.grey[800],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF9288EE),
                      ),
                    ),
                  ),
                ],
              ),
              
              const Spacer(),
              
              // Title
              Text(
                "You're almost there!",
                textAlign: TextAlign.center,
                style: GoogleFonts.aclonica(
                  fontSize: 32,
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 60),
              
              // Skills / Interests
              _buildTextField(
                label: 'Skills / Interests',
                hint: 'e.g., Graphic Design, Marketing',
                controller: _skillsController,
              ),
              
              const SizedBox(height: 24),
              
              // Bio (Optional)
              _buildTextField(
                label: 'Bio (Optional)',
                hint: 'Tell us about yourself...',
                controller: _bioController,
                maxLines: 4,
              ),
              
              const Spacer(),
              
              // Buttons Row
              Row(
                children: [
                  // Back Button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(
                            color: Color(0xFF9288EE),
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Step5StudentScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9288EE),
                        foregroundColor: AppColors.white,
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
              
              // Terms and Privacy
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.aclonica(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    children: const [
                      TextSpan(text: 'By signing up, you agree to our '),
                      TextSpan(
                        text: 'Terms',
                        style: TextStyle(
                          color: Color(0xFF9288EE),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: Color(0xFF9288EE),
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
