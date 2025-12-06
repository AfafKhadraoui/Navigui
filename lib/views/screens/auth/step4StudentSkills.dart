import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../commons/themes/style_simple/colors.dart';
import '../../../routes/app_router.dart';
import '../../../logic/cubits/auth/auth_cubit.dart';
import '../../../logic/cubits/auth/auth_state.dart';
import '../../../logic/services/signup_data_service.dart';
// using inline buttons here to avoid importing shared custom_button
import '../../widgets/common/signup_success_dialog.dart';

class Step4StudentSkillsScreen extends StatefulWidget {
  const Step4StudentSkillsScreen({super.key});

  @override
  State<Step4StudentSkillsScreen> createState() => _Step4StudentSkillsScreenState();
}

class _Step4StudentSkillsScreenState extends State<Step4StudentSkillsScreen> {
  // Selected skills
  final Set<String> _selectedSkills = {};
  
  // Selected languages
  final Set<String> _selectedLanguages = {};

  // Available skills
  final List<String> _skills = [
    'Graphic Design',
    'Content Writing',
    'Photography',
    'Video Editing',
    'Social Media',
    'Translation',
    'Tutoring',
    'Data Entry',
    'Customer Service',
    'Web Development',
    'Event Planning',
    'Marketing',
    'Accounting',
    'Sales',
    'Administrative',
    'Project Management',
    'Research',
    'Teaching',
  ];

  // Available languages
  final List<String> _languages = [
    'Arabic',
    'French',
    'English',
    'Spanish',
    'Tamazight',
    'German',
  ];

  void _toggleSkill(String skill) {
    setState(() {
      if (_selectedSkills.contains(skill)) {
        _selectedSkills.remove(skill);
      } else {
        _selectedSkills.add(skill);
      }
    });
  }

  void _toggleLanguage(String language) {
    setState(() {
      if (_selectedLanguages.contains(language)) {
        _selectedLanguages.remove(language);
      } else {
        _selectedLanguages.add(language);
      }
    });
  }

  void _handleContinue() async {
    print('🔵 Continue button pressed!');
    
    // Validate that at least one skill or language is selected
    if (_selectedSkills.isEmpty && _selectedLanguages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one skill or language'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }
    
    try {
      // Save skills and languages to temporary storage
      final signupService = SignupDataService();
      await signupService.saveMultipleData({
        SignupDataService.keySkills: _selectedSkills.toList(),
        SignupDataService.keyLanguages: _selectedLanguages.toList(),
      });
      print('✅ Saved skills and languages');
      
      // Get all collected signup data
      final signupData = await signupService.getStudentSignupData();
      
      // Debug: Print what data we have
      print('=== SIGNUP DATA ===');
      print('Email: ${signupData['email']}');
      print('Password: ${signupData['password']}');
      print('Name: ${signupData['name']}');
      print('Phone: ${signupData['phoneNumber']}');
      print('Location: ${signupData['location']}');
      print('==================');
      
      // Validate required fields
      if (signupData['email'] == null || 
          signupData['password'] == null || 
          signupData['name'] == null || 
          signupData['phoneNumber'] == null || 
          signupData['location'] == null) {
        throw Exception('Missing required signup data. Please go back and complete all previous steps.');
      }
      
      // Create user account with AuthCubit (uses DatabaseAuthRepository)
      if (context.mounted) {
        await context.read<AuthCubit>().signup(
          email: signupData['email'] as String,
          password: signupData['password'] as String,
          name: signupData['name'] as String,
          phoneNumber: signupData['phoneNumber'] as String,
          location: signupData['location'] as String,
          accountType: 'student',
        );
      }
      
      // Clear temporary signup data
      await signupService.clearAllData();
      
      // Navigate to success screen
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => SignupSuccessDialog(
            userName: signupData['name'] as String,
            isStudent: true,
            onGoToDashboard: () {
              Navigator.of(dialogContext).pop();
              context.go(AppRouter.home);
            },
            onStartOver: () {
              Navigator.of(dialogContext).pop();
              context.go(AppRouter.accountType);
            },
          ),
        );
      }
    } catch (e) {
      // Show error
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Widget _buildSkillChip(String skill) {
    final isSelected = _selectedSkills.contains(skill);
    
    return GestureDetector(
      onTap: () => _toggleSkill(skill),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.purple6 : Colors.transparent,
          border: Border.all(
            color: AppColors.white,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              const Icon(
                Icons.check,
                color: Colors.white,
                size: 18,
              ),
            if (isSelected) const SizedBox(width: 6),
            Text(
              skill,
              style: GoogleFonts.aclonica(
                fontSize: 14,
                color: Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageChip(String language) {
    final isSelected = _selectedLanguages.contains(language);
    
    return GestureDetector(
      onTap: () => _toggleLanguage(language),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.purple6 : Colors.transparent,
          border: Border.all(
            color: AppColors.white,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              const Icon(
                Icons.check,
                color: Colors.white,
                size: 18,
              ),
            if (isSelected) const SizedBox(width: 6),
            Text(
              language,
              style: GoogleFonts.aclonica(
                fontSize: 14,
                color: Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              
              // Header with progress indicator
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
                    'Step 4 of 5',
                    style: GoogleFonts.aclonica(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: 4 / 5,
                  minHeight: 6,
                  backgroundColor: Colors.grey[800],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.purple6,
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Skills Section
                      Text(
                        'Skills',
                        style: GoogleFonts.aclonica(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Select all that apply',
                        style: GoogleFonts.aclonica(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Skills chips
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: _skills.map((skill) => _buildSkillChip(skill)).toList(),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Languages Section
                      Text(
                        'Languages',
                        style: GoogleFonts.aclonica(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Select all that you speak',
                        style: GoogleFonts.aclonica(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Language chips
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: _languages.map((lang) => _buildLanguageChip(lang)).toList(),
                      ),
                      
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              
              // Buttons Row (copied inline from step3 style)
              Row(
                children: [
                  // Back Button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.purple6,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(
                          color: AppColors.purple6,
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
                        backgroundColor: AppColors.purple6,
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
              
              const SizedBox(height: 16),
              
              // Terms and Privacy
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.aclonica(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                    children: [
                      const TextSpan(text: 'By signing up, you agree to our '),
                      TextSpan(
                        text: 'Terms',
                        style: TextStyle(
                          color: AppColors.purple6,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: AppColors.purple6,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
