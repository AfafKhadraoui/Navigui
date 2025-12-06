import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/cubits/employer_profile/employer_profile_cubit.dart';
import '../../../logic/cubits/employer_profile/employer_profile_state.dart';
import '../../../logic/cubits/auth/auth_cubit.dart';
import '../../../logic/cubits/auth/auth_state.dart';
import '../../../commons/themes/style_simple/colors.dart';
import '../../../core/dependency_injection.dart';

/// Edit Employer Profile Screen
/// Allows employers to edit their business information
/// Pre-populates fields with current data from database
class EditEmployerProfileScreen extends StatelessWidget {
  const EditEmployerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final authState = context.read<AuthCubit>().state;
        final userId = authState is AuthAuthenticated ? authState.user.id : null;
        final cubit = getIt<EmployerProfileCubit>();
        if (userId != null) {
          cubit.loadProfile(userId);
        }
        return cubit;
      },
      child: const _EditEmployerProfileView(),
    );
  }
}

class _EditEmployerProfileView extends StatefulWidget {
  const _EditEmployerProfileView();

  @override
  State<_EditEmployerProfileView> createState() => _EditEmployerProfileViewState();
}

class _EditEmployerProfileViewState extends State<_EditEmployerProfileView> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for text fields
  late final TextEditingController _businessNameController;
  late final TextEditingController _businessTypeController;
  late final TextEditingController _industryController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationController;
  late final TextEditingController _addressController;
  late final TextEditingController _websiteController;

  @override
  void initState() {
    super.initState();
    _businessNameController = TextEditingController();
    _businessTypeController = TextEditingController();
    _industryController = TextEditingController();
    _descriptionController = TextEditingController();
    _locationController = TextEditingController();
    _addressController = TextEditingController();
    _websiteController = TextEditingController();
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _businessTypeController.dispose();
    _industryController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _addressController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  void _populateFields(state) {
    if (state is EmployerProfileLoaded) {
      final profile = state.profile;
      setState(() {
        _businessNameController.text = profile.businessName;
        _businessTypeController.text = profile.businessType;
        _industryController.text = profile.industry;
        _descriptionController.text = profile.description ?? '';
        _locationController.text = profile.location ?? '';
        _addressController.text = profile.address ?? '';
        _websiteController.text = profile.websiteUrl ?? '';
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final authState = context.read<AuthCubit>().state;
    if (authState is! AuthAuthenticated) return;

    await context.read<EmployerProfileCubit>().updateProfile(
      userId: authState.user.id,
      businessName: _businessNameController.text,
      businessType: _businessTypeController.text,
      industry: _industryController.text,
      description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
      location: _locationController.text.isEmpty ? null : _locationController.text,
      address: _addressController.text.isEmpty ? null : _addressController.text,
      websiteUrl: _websiteController.text.isEmpty ? null : _websiteController.text,
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
          'Edit Business Profile',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<EmployerProfileCubit, EmployerProfileState>(
        listener: (context, state) {
          if (state is EmployerProfileLoaded) {
            _populateFields(state);
          }
          if (state is EmployerProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          }
          if (state is EmployerProfileError) {
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
          if (state is EmployerProfileLoaded && _businessNameController.text.isEmpty) {
            // Use post-frame callback to avoid calling setState during build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _populateFields(state);
            });
          }

          if (state is EmployerProfileLoading) {
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
                    controller: _businessNameController,
                    label: 'Business Name',
                    hint: 'Enter your business name',
                    required: true,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _businessTypeController,
                    label: 'Business Type',
                    hint: 'e.g., LLC, Corporation, Startup',
                    required: true,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _industryController,
                    label: 'Industry',
                    hint: 'e.g., Technology, Retail, Healthcare',
                    required: true,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _descriptionController,
                    label: 'Business Description',
                    hint: 'Tell us about your business',
                    maxLines: 4,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _locationController,
                    label: 'Location',
                    hint: 'City, Country',
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _addressController,
                    label: 'Full Address',
                    hint: 'Street address, building number',
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _websiteController,
                    label: 'Website',
                    hint: 'https://yourbusiness.com',
                  ),
                  const SizedBox(height: 32),
                  
                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: state is EmployerProfileLoading ? null : _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: state is EmployerProfileLoading
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
