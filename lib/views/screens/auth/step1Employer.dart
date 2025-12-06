import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'step2Employer.dart';
import '../../../utils/form_validators.dart';
import '../../../logic/services/signup_data_service.dart';

class Step1EmployerScreen extends StatefulWidget {
  const Step1EmployerScreen({super.key});

  @override
  State<Step1EmployerScreen> createState() => _Step1EmployerScreenState();
}

class _Step1EmployerScreenState extends State<Step1EmployerScreen> {
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
        SignupDataService.keyPassword: _passwordController.text.trim(),
        SignupDataService.keyAccountType: 'employer',
      });
      
      // Proceed to next step
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Step2EmployerScreen(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
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
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                
                // Email TextField (white background + black text)
                TextFormField(
                  controller: _emailController,
                  validator:FormValidators.validateEmail ,
                  keyboardType: TextInputType.emailAddress,
                  style: GoogleFonts.aclonica(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'careerplace@gmail.com',
                    hintStyle: GoogleFonts.aclonica(
                      color: Colors.grey,
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
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
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
                
                // Password TextField (white background + black text)
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  validator:  FormValidators.validatePassword,
                  style: GoogleFonts.aclonica(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: '••••••••',
                    hintStyle: GoogleFonts.aclonica(
                      color: Colors.grey,
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
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Continue Button
                ElevatedButton(
                  onPressed: _handleContinue,
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
      ),
    );
  }
}
