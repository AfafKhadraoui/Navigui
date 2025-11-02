import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../commons/themes/style_simple/colors.dart';
import 'step2Employer.dart';

class Step1EmployerScreen extends StatefulWidget {
  const Step1EmployerScreen({super.key});

  @override
  State<Step1EmployerScreen> createState() => _Step1EmployerScreenState();
}

class _Step1EmployerScreenState extends State<Step1EmployerScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                        'Step 1 of 4',
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
                      value: 1 / 4,
                      minHeight: 6,
                      backgroundColor: Colors.grey[800],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFD2FF1F),
                      ),
                    ),
                  ),
                ],
              ),
              
              const Spacer(),
              
              // Title
              Text(
                'get ready for the gag',
                style: GoogleFonts.aclonica(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Email Address Label
              Text(
                'Email Address',
                style: GoogleFonts.aclonica(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Email TextField (dark surface + white text)
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: GoogleFonts.aclonica(
                    fontSize: 14,
                    color: AppColors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: 'careerplace@gmail.com',
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
              
              const SizedBox(height: 24),
              
              // Password Label
              Text(
                'Password',
                style: GoogleFonts.aclonica(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Password TextField (dark surface + white text)
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: GoogleFonts.aclonica(
                    fontSize: 14,
                    color: AppColors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: '••••••••',
                    hintStyle: GoogleFonts.aclonica(
                      color: AppColors.grey6,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.grey6,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Continue Button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Step2EmployerScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD2FF1F),
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
                          color: Color(0xFFD2FF1F),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: Color(0xFFD2FF1F),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
