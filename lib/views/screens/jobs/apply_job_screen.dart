import 'package:flutter/material.dart';
import '../../../commons/themes/style_simple/colors.dart';
import '../../../commons/themes/style_simple/styles.dart';
import 'ApplicationSuccessScreen.dart';

class ApplyJobScreen extends StatefulWidget {
  final Map<String, dynamic> job;

  const ApplyJobScreen({super.key, required this.job});

  @override
  State<ApplyJobScreen> createState() => _ApplyJobScreenState();
}

class _ApplyJobScreenState extends State<ApplyJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _portfolioController = TextEditingController();
  final _motivationController = TextEditingController();

  String? _selectedAvailability;
  String? _resumeFileName;
  List<String> _portfolioFiles = [];

  final List<String> _availabilityOptions = [
    'Immediately',
    'Within 1 week',
    'Within 2 weeks',
    'Within 1 month',
    'Flexible',
  ];

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _portfolioController.dispose();
    _motivationController.dispose();
    super.dispose();
  }

  void _submitApplication() {
    if (_formKey.currentState!.validate()) {
      if (_selectedAvailability == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please confirm your availability'),
            backgroundColor: AppColors.urgentRed,
          ),
        );
        return;
      }

      // Navigate to success screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ApplicationSuccessScreen(job: widget.job),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Apply for job',
          style: TextStyle(
            fontFamily: 'Aclonica',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppStyles.spacingMD),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Job Info Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.grey4,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.grey5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.job['title'],
                      style: const TextStyle(
                        fontFamily: 'Aclonica',
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.job['company']} - ${widget.job['location']}',
                      style: const TextStyle(
                        fontFamily: 'Acme',
                        color: AppColors.grey6,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Info Banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3A5F),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF2B5A8E)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Color(0xFF5B9FEE),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your profile information will be automatically attached to this application',
                        style: TextStyle(
                          fontFamily: 'Acme',
                          color: AppColors.white.withOpacity(0.9),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Full Name
              _buildLabel('Full Name*'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _fullNameController,
                hintText: 'Enter your full name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Email Address
              _buildLabel('Email Address*'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _emailController,
                hintText: 'your.email@example.com',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Phone Number
              _buildLabel('Phone Number*'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _phoneController,
                hintText: '+213 555 000 000',
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Portfolio URL
              _buildLabel('Portfolio URL (Optional)'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _portfolioController,
                hintText: 'https://yourportfolio.com',
                keyboardType: TextInputType.url,
              ),

              const SizedBox(height: 20),

              // Resume Upload
              _buildLabel('Resume/CV (Optional)'),
              const SizedBox(height: 8),
              _buildUploadButton(
                onTap: () async {
                  // Simulate file picking
                  setState(() {
                    _resumeFileName = 'resume_example.pdf';
                  });
                },
                text: _resumeFileName ?? 'Upload your resume',
                subtitle: 'PDF, DOC, DOCX (Max 5MB)',
                hasFile: _resumeFileName != null,
              ),

              const SizedBox(height: 20),

              // Additional Documents
              _buildLabel('Additional Documents/Portfolio (Optional)'),
              const SizedBox(height: 8),
              _buildUploadButton(
                onTap: () async {
                  // Simulate file picking
                  setState(() {
                    _portfolioFiles.add('portfolio_file_${_portfolioFiles.length + 1}.pdf');
                  });
                },
                text: _portfolioFiles.isEmpty
                    ? 'Add portfolio files'
                    : '${_portfolioFiles.length} file(s) selected',
                subtitle: null,
                hasFile: _portfolioFiles.isNotEmpty,
              ),

              if (_portfolioFiles.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _portfolioFiles.map((file) {
                    return Chip(
                      label: Text(
                        file,
                        style: const TextStyle(
                          fontFamily: 'Aclonica',
                          color: AppColors.white,
                          fontSize: 12,
                        ),
                      ),
                      deleteIcon: const Icon(
                        Icons.close,
                        size: 16,
                        color: AppColors.white,
                      ),
                      onDeleted: () {
                        setState(() {
                          _portfolioFiles.remove(file);
                        });
                      },
                      backgroundColor: AppColors.grey5,
                    );
                  }).toList(),
                ),
              ],

              const SizedBox(height: 20),

              // Motivation
              _buildLabel('Why are you interested in this position?*'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _motivationController,
                hintText: 'Tell us why you\'re a great fit for this role...',
                maxLines: 6,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please tell us why you\'re interested';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Availability
              _buildLabel('Confirm Your Availability*'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.grey4,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.grey5),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedAvailability,
                    hint: const Text(
                      'Select your availability',
                      style: TextStyle(
                        fontFamily: 'Aclonica',
                        color: AppColors.grey6,
                        fontSize: 14,
                      ),
                    ),
                    isExpanded: true,
                    dropdownColor: AppColors.grey4,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.white,
                    ),
                    style: const TextStyle(
                      fontFamily: 'Aclonica',
                      color: AppColors.white,
                      fontSize: 14,
                    ),
                    items: _availabilityOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedAvailability = newValue;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitApplication,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lavenderPurple,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Submit Application',
                    style: TextStyle(
                      fontFamily: 'Aclonica',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Aclonica',
        color: AppColors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(
        fontFamily: 'Aclonica',
        color: AppColors.white,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontFamily: 'Aclonica',
          color: AppColors.grey6,
          fontSize: 14,
        ),
        filled: true,
        fillColor: AppColors.grey4,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.grey5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.grey5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lavenderPurple),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.urgentRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.urgentRed),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildUploadButton({
    required String text,
    String? subtitle,
    required VoidCallback onTap,
    required bool hasFile,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.grey4,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasFile ? AppColors.lavenderPurple : AppColors.grey5,
            width: hasFile ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              hasFile ? Icons.check_circle_outline : Icons.upload_file,
              color: hasFile ? AppColors.lavenderPurple : AppColors.grey6,
              size: 32,
            ),
            const SizedBox(height: 12),
            Text(
              text,
              style: TextStyle(
                fontFamily: 'Aclonica',
                color: hasFile ? AppColors.white : AppColors.grey6,
                fontSize: 14,
                fontWeight: hasFile ? FontWeight.w600 : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontFamily: 'Aclonica',
                  color: AppColors.grey7,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}