import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../commons/themes/style_simple/colors.dart';
import '../../../commons/themes/style_simple/styles.dart';
import '../../../routes/app_router.dart';

/// Login Screen - User authentication (NO BOTTOM BAR!)

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Implement login form
    // TODO: Add email and password fields
    // TODO: Add login button
    // TODO: Add forgot password link
    // TODO: Add navigation to signup
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login Screen',
              style: AppStyles.headlineLarge,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // After login success:
                context.go(AppRouter.home); // Goes to home WITH bottom bar!
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 16,
                ),
              ),
              child: const Text('Login (Demo)'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.go(AppRouter.register),
              child: const Text('Register instead'),
            ),
            // TextButton(
            //   onPressed: () => context.go(AppRouter.welcome),
            //   child: const Text('Back to Welcome'),
            // ),
          ],
        ),
      ),
    );
  }
}
