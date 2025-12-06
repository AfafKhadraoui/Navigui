import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../routes/app_router.dart';
import '../../../data/databases/tables/users_table.dart';
import '../../../logic/cubits/auth/auth_cubit.dart';
import '../../../data/models/user_model.dart';

class LoginScreen2 extends StatefulWidget {
  const LoginScreen2({super.key});

  @override
  State<LoginScreen2> createState() => _LoginScreen2State();
}

class _LoginScreen2State extends State<LoginScreen2> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(flex: 2),

                // Title
                Text(
                  'Log in to your account',
                  textAlign: TextAlign.center,
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextField(
                    controller: _emailController,
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
                      ),
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: GoogleFonts.aclonica(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: '••••••••••',
                      hintStyle: GoogleFonts.aclonica(
                        color: Colors.grey,
                      ),
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
                ),

                const SizedBox(height: 16),

                // Error message
                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: GoogleFonts.aclonica(
                        fontSize: 12,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                const SizedBox(height: 24),

                // Login Button
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();

                          if (email.isEmpty || password.isEmpty) {
                            setState(() {
                              _errorMessage = 'Please enter email and password';
                            });
                            return;
                          }

                          setState(() {
                            _isLoading = true;
                            _errorMessage = null;
                          });

                          try {
                            // Validate credentials against database
                            final user =
                                await UsersTable.validateUser(email, password);

                            if (user != null) {
                              // Save user info to SharedPreferences
                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setString('user_id', user['id']);
                              await prefs.setString(
                                  'user_email', user['email']);
                              await prefs.setString('user_name', user['name']);
                              await prefs.setString(
                                  'account_type', user['account_type']);

                              // Update last login
                              await UsersTable.updateLastLogin(user['id']);

                              // Update AuthCubit with logged in user
                              if (mounted) {
                                final userModel = UserModel(
                                  id: user['id'],
                                  email: user['email'],
                                  accountType: user['account_type'],
                                  name: user['name'],
                                  phoneNumber: user['phone_number'] ?? '',
                                  location: user['location'] ?? '',
                                  profilePicture: user['profile_picture_url'],
                                  isEmailVerified:
                                      user['is_email_verified'] == 1,
                                  isActive: user['is_active'] == 1,
                                  createdAt: DateTime.parse(user['created_at']),
                                  updatedAt: user['updated_at'] != null
                                      ? DateTime.parse(user['updated_at'])
                                      : null,
                                );

                                context.read<AuthCubit>().login(userModel);
                              }

                              // Navigate to home
                              if (mounted) {
                                context.go(AppRouter.home);
                              }
                            } else {
                              setState(() {
                                _errorMessage = 'Invalid email or password';
                                _isLoading = false;
                              });
                            }
                          } catch (e) {
                            setState(() {
                              _errorMessage = 'Login failed: ${e.toString()}';
                              _isLoading = false;
                            });
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isLoading ? Colors.grey : const Color(0xFFD2FF1F),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black),
                          ),
                        )
                      : Text(
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
      ),
    );
  }
}
