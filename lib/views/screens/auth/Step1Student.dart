import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../commons/themes/style_simple/colors.dart';
import '../../../routes/app_router.dart';
import '../../../logic/services/signup_data_service.dart';
import '../../../utils/form_validators.dart';

class Step1StudentScreen extends StatefulWidget {
  const Step1StudentScreen({super.key});

  @override
  State<Step1StudentScreen> createState() => _Step1StudentScreenState();
}

class _Step1StudentScreenState extends State<Step1StudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  void _handleContinue() async {
    if (_formKey.currentState!.validate()) {
      // Save email and password to temporary storage
      final signupService = SignupDataService();
      await signupService.saveMultipleData({
        SignupDataService.keyEmail: _emailController.text.trim(),
        SignupDataService.keyPassword: _passwordController.text,
        SignupDataService.keyAccountType: 'student',
      });
      
      // Proceed to next step
      if (context.mounted) {
        context.go(AppRouter.studentStep2);
      }
    }
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
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        'Step 1 of 5',
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
                      value: 1 / 5,
                      minHeight: 6,
                      backgroundColor: Colors.grey[800],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF9288EE),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Form with Email and Password fields
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Email
                    TextFormField(
                validator: FormValidators.validateEmail,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: GoogleFonts.aclonica(
                  fontSize: 14,
                  color: AppColors.white,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.surface,
                  hintText: 'student@example.com',
                  hintStyle: GoogleFonts.aclonica(
                    color: AppColors.grey6,
                    fontSize: 14,
                  ),
                  errorStyle: GoogleFonts.aclonica(
                    fontSize: 12,
                    color: Colors.red,
                    height: 0.8,
                  ),
                  errorMaxLines: 2,
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
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 2,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                ),
                    ),

                    const SizedBox(height: 16),

                    // Password
                    TextFormField(
                validator: FormValidators.validatePassword,
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: GoogleFonts.aclonica(
                  fontSize: 14,
                  color: AppColors.white,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.surface,
                  hintText: '••••••••••',
                  hintStyle: GoogleFonts.aclonica(
                    color: AppColors.grey6,
                    fontSize: 14,
                  ),
                  errorStyle: GoogleFonts.aclonica(
                    fontSize: 12,
                    color: Colors.red,
                    height: 0.8,
                  ),
                  errorMaxLines: 2,
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
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 2,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.grey6,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Buttons Row (Back + Continue)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.go(AppRouter.accountType),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF9288EE),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(
                          color: Color(0xFF9288EE),
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      ),
                      child: Text('Back', style: GoogleFonts.aclonica(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: ElevatedButton(
                      // onPressed: () {
                      //   Navigator.push(context, MaterialPageRoute(builder: (c) => const Step2StudentScreen()));
                      // },
                      onPressed: _handleContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9288EE),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        elevation: 0,
                      ),
                      child: Text('Continue', style: GoogleFonts.aclonica(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.aclonica(fontSize: 12, color: Colors.grey),
                    children: [
                      const TextSpan(text: 'By signing up, you agree to our '),
                      TextSpan(text: 'Terms', style: TextStyle(color: AppColors.purple6, decoration: TextDecoration.underline)),
                      const TextSpan(text: ' and '),
                      TextSpan(text: 'Privacy Policy', style: TextStyle(color: AppColors.purple6, decoration: TextDecoration.underline)),
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