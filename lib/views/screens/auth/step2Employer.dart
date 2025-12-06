import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../commons/themes/style_simple/colors.dart';
import '../../../utils/form_validators.dart';
import 'step3Employer.dart';
import '../../../logic/services/signup_data_service.dart';

class Step2EmployerScreen extends StatefulWidget {
  const Step2EmployerScreen({super.key});

  @override
  State<Step2EmployerScreen> createState() => _Step2EmployerScreenState();
}

class _Step2EmployerScreenState extends State<Step2EmployerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String? _selectedType;
  
  final List<String> _typeOptions = [
    'Startup',
    'Small Business',
    'Medium Enterprise',
    'Large Corporation',
    'Non-Profit Organization',
    'Educational Institution',
    'Government Agency',
    'Freelancer',
    'Individual',
  ];

  void _handleContinue() async {
    if (_formKey.currentState!.validate()) {
      // Additional type validation since dropdown doesn't use validator directly
      if (_selectedType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please select your business type',
              style: GoogleFonts.aclonica(),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      // Save data to temporary storage
      final signupService = SignupDataService();
      await signupService.saveMultipleData({
        SignupDataService.keyName: _nameController.text.trim(),
        SignupDataService.keyPhoneNumber: _phoneController.text.trim(),
        SignupDataService.keyLocation: _locationController.text.trim(),
        SignupDataService.keyBusinessType: _selectedType!,
        SignupDataService.keyDescription: _descriptionController.text.trim(),
      });
      
      // All validations passed, proceed to next step
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Step3EmployerScreen(),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _locationController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    String? Function(String?)? validator,
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
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: GoogleFonts.aclonica(
            fontSize: 14,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hint,
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 24,
              vertical: maxLines > 1 ? 16 : 16,
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
        child: SingleChildScrollView(
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
                          'Step 2 of 4',
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
                        value: 2 / 4,
                        minHeight: 6,
                        backgroundColor: Colors.grey[800],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFFD2FF1F),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),
                
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Phone Number
                      _buildTextField(
                        label: 'Phone number',
                        hint: '+213 xx xxx xxxx',
                        controller: _phoneController,
                        validator: FormValidators.validatePhoneAlgeria,
                        keyboardType: TextInputType.phone,
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Location
                      _buildTextField(
                        label: 'Location',
                        hint: 'City, Country',
                        controller: _locationController,
                        validator: FormValidators.validateLocation,
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Business/Individual Name
                      _buildTextField(
                        label: 'Business/ Individual Name',
                        hint: 'John Doe/ Company Inc.',
                        controller: _nameController,
                        validator: FormValidators.validateBusinessName,
                      ),
                
                const SizedBox(height: 20),
                
                // Type - Dropdown
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Type',
                      style: GoogleFonts.aclonica(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedType,
                          isExpanded: true,
                          hint: Text(
                            'Select Type',
                            style: GoogleFonts.aclonica(
                              color: AppColors.grey6,
                              fontSize: 14,
                            ),
                          ),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.grey,
                          ),
                          style: GoogleFonts.aclonica(
                            fontSize: 14,
                            color: AppColors.white,
                          ),
                          dropdownColor: AppColors.surface,
                          items: _typeOptions.map((String type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type, style: TextStyle(color: AppColors.white)),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedType = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                
                      const SizedBox(height: 20),
                      
                      // Brief Description (Optional)
                      _buildTextField(
                        label: 'Brief Description (Optional)',
                        hint: 'Describe your business or yourself',
                        controller: _descriptionController,
                        validator: FormValidators.validateDescription,
                        maxLines: 4,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
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
                          foregroundColor: const Color(0xFFD2FF1F),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(
                            color: Color(0xFFD2FF1F),
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
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
