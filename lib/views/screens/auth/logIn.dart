import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../commons/themes/style_simple/colors.dart';
import 'package:go_router/go_router.dart';
import '../../../routes/app_router.dart';
import '../../../logic/services/auth_service.dart';

class LoginScreen2 extends StatefulWidget {
  const LoginScreen2({super.key});

  @override
  State<LoginScreen2> createState() => _LoginScreen2State();
}

class _LoginScreen2State extends State<LoginScreen2> {
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),

              // Title
              Text(
                'Log in to your account',
                style: GoogleFonts.aclonica(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 50),

              // Email Label
              Text(
                'Email',
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
                    hintText: '••••••••••',
                    hintStyle: GoogleFonts.aclonica(
                      color: AppColors.grey6,
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

              // Login Button
              ElevatedButton(
                onPressed: () async {
                  // DEMO: Login with role based on email
                  // If email contains 'employer' -> employer role
                  // Otherwise -> student role
                  final email = _emailController.text.trim();

                  final authService = context.read<AuthService>();
                  final success = await authService.login(
                    email,
                    _passwordController.text,
                  );

                  if (success && mounted) {
                    // Navigate to home - it will show correct interface based on role
                    context.go(AppRouter.home);
                  }
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
                  'Log in',
                  style: GoogleFonts.aclonica(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Sign Up Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "don't have an account? ",
                    style: GoogleFonts.acme(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.go(AppRouter.accountType);
                    },
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.acme(
                        fontSize: 14,
                        color: const Color(0xFFD2FF1F),
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: const Color(0xFFD2FF1F),
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
