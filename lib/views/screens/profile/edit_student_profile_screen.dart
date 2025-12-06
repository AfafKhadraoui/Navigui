import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/cubits/student_profile/student_profile_cubit.dart';
import '../../../logic/cubits/student_profile/student_profile_state.dart';
import '../../../logic/cubits/auth/auth_cubit.dart';
import '../../../logic/cubits/auth/auth_state.dart';
import '../../../commons/themes/style_simple/colors.dart';
import '../../../core/dependency_injection.dart';
import '../../../data/repositories/user/user_repo_abstract.dart';

/// Edit Student Profile Screen
/// Allows students to edit all their profile information
/// Pre-populates fields with current data from database
class EditStudentProfileScreen extends StatelessWidget {
  const EditStudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final authState = context.read<AuthCubit>().state;
        final userId = authState is AuthAuthenticated ? authState.user.id : null;
        final cubit = getIt<StudentProfileCubit>();
        if (userId != null) {
          cubit.loadProfile(userId);
        }
        return cubit;
      },
      child: const _EditStudentProfileView(),
    );
  }
}

class _EditStudentProfileView extends StatefulWidget {
  const _EditStudentProfileView();

  @override
  State<_EditStudentProfileView> createState() => _EditStudentProfileViewState();
}

class _EditStudentProfileViewState extends State<_EditStudentProfileView> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for text fields
  late final TextEditingController _nameController;
  late final TextEditingController _universityController;
  late final TextEditingController _facultyController;
  late final TextEditingController _majorController;
  late final TextEditingController _yearController;
  late final TextEditingController _bioController;
  late final TextEditingController _availabilityController;
  late final TextEditingController _transportationController;
  late final TextEditingController _experienceController;
  late final TextEditingController _websiteController;
  late final TextEditingController _skillsController;
  
  bool _isPhonePublic = true;
  String _profileVisibility = 'public';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _universityController = TextEditingController();
    _facultyController = TextEditingController();
    _majorController = TextEditingController();
    _yearController = TextEditingController();
    _bioController = TextEditingController();
    _availabilityController = TextEditingController();
    _transportationController = TextEditingController();
    _experienceController = TextEditingController();
    _websiteController = TextEditingController();
    _skillsController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _universityController.dispose();
    _facultyController.dispose();
    _majorController.dispose();
    _yearController.dispose();
    _bioController.dispose();
    _availabilityController.dispose();
    _transportationController.dispose();
    _experienceController.dispose();
    _websiteController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  void _populateFields(state) {
    if (state is StudentProfileLoaded) {
      final profile = state.profile;
      final authState = context.read<AuthCubit>().state;
      final userName = authState is AuthAuthenticated ? authState.user.name : '';
      
      setState(() {
        _nameController.text = userName;
        _universityController.text = profile.university;
        _facultyController.text = profile.faculty;
        _majorController.text = profile.major;
        _yearController.text = profile.yearOfStudy;
        _bioController.text = profile.bio ?? '';
        _availabilityController.text = profile.availability ?? '';
        _transportationController.text = profile.transportation ?? '';
        _experienceController.text = profile.previousExperience ?? '';
        _websiteController.text = profile.websiteUrl ?? '';
        _skillsController.text = profile.skills.join(', ');
        _isPhonePublic = profile.isPhonePublic;
        _profileVisibility = profile.profileVisibility;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final authState = context.read<AuthCubit>().state;
    if (authState is! AuthAuthenticated) return;

    final skills = _skillsController.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    // Update user name if changed
    if (_nameController.text.isNotEmpty && _nameController.text != authState.user.name) {
      final userRepo = getIt<UserRepository>();
      await userRepo.updateUser(
        userId: authState.user.id,
        name: _nameController.text,
      );
    }

    // Update student profile
    await context.read<StudentProfileCubit>().updateProfile(
      userId: authState.user.id,
      university: _universityController.text,
      faculty: _facultyController.text,
      major: _majorController.text,
      yearOfStudy: _yearController.text,
      bio: _bioController.text.isEmpty ? null : _bioController.text,
      skills: skills,
      availability: _availabilityController.text.isEmpty ? null : _availabilityController.text,
      transportation: _transportationController.text.isEmpty ? null : _transportationController.text,
      previousExperience: _experienceController.text.isEmpty ? null : _experienceController.text,
      websiteUrl: _websiteController.text.isEmpty ? null : _websiteController.text,
      isPhonePublic: _isPhonePublic,
      profileVisibility: _profileVisibility,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<StudentProfileCubit, StudentProfileState>(
        listener: (context, state) {
          if (state is StudentProfileLoaded) {
            _populateFields(state);
          }
          if (state is StudentProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          }
          if (state is StudentProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          // Populate fields from current state if loaded
          if (state is StudentProfileLoaded && _universityController.text.isEmpty) {
            // Use post-frame callback to avoid calling setState during build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _populateFields(state);
            });
          }

          if (state is StudentProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    controller: _nameController,
                    label: 'Full Name',
                    hint: 'Enter your full name',
                    required: true,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _universityController,
                    label: 'University',
                    hint: 'Enter your university name',
                    required: true,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _facultyController,
                    label: 'Faculty',
                    hint: 'e.g., Engineering, Business',
                    required: true,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _majorController,
                    label: 'Major',
                    hint: 'e.g., Computer Science',
                    required: true,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _yearController,
                    label: 'Year of Study',
                    hint: 'e.g., Third Year',
                    required: true,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _bioController,
                    label: 'Bio',
                    hint: 'Tell us about yourself',
                    maxLines: 4,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _skillsController,
                    label: 'Skills',
                    hint: 'Enter skills separated by commas (e.g., Flutter, Dart, Firebase)',
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _availabilityController,
                    label: 'Availability',
                    hint: 'e.g., Part-time, Weekends',
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _transportationController,
                    label: 'Transportation',
                    hint: 'e.g., Car, Public Transport',
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _experienceController,
                    label: 'Previous Experience',
                    hint: 'Describe your work experience',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _websiteController,
                    label: 'Website/Portfolio',
                    hint: 'https://yourportfolio.com',
                  ),
                  const SizedBox(height: 24),
                  
                  // Phone Public Toggle
                  SwitchListTile(
                    title: const Text(
                      'Make phone number public',
                      style: TextStyle(color: AppColors.white),
                    ),
                    value: _isPhonePublic,
                    onChanged: (value) => setState(() => _isPhonePublic = value),
                    activeColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Profile Visibility
                  Text(
                    'Profile Visibility',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _profileVisibility,
                    dropdownColor: AppColors.grey4,
                    style: const TextStyle(color: AppColors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.grey4,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'public', child: Text('Public')),
                      DropdownMenuItem(value: 'private', child: Text('Private')),
                      DropdownMenuItem(value: 'connections_only', child: Text('Connections Only')),
                    ],
                    onChanged: (value) => setState(() => _profileVisibility = value ?? 'public'),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: state is StudentProfileLoading ? null : _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: state is StudentProfileLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: AppColors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Save Changes',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          required ? '$label *' : label,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: AppColors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.white.withOpacity(0.5)),
            filled: true,
            fillColor: AppColors.grey4,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
          ),
          validator: required
              ? (value) => value == null || value.isEmpty ? 'This field is required' : null
              : null,
        ),
      ],
    );
  }
}
