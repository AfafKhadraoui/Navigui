import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../commons/themes/style_simple/colors.dart';

/// Employer Profile Creation Screen
/// Lime green theme (#D2FF1F) for employer
class CreateEmployerProfileScreen extends StatefulWidget {
  const CreateEmployerProfileScreen({super.key});

  @override
  State<CreateEmployerProfileScreen> createState() => _CreateEmployerProfileScreenState();
}

class _CreateEmployerProfileScreenState extends State<CreateEmployerProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _companyNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _websiteController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String _selectedIndustry = 'Technology';
  String _selectedCompanySize = '1-10 employees';
  
  final List<String> _industries = [
    'Technology',
    'Healthcare',
    'Education',
    'Finance',
    'Retail',
    'Manufacturing',
    'Food & Beverage',
    'Hospitality',
    'Marketing',
    'Other',
  ];
  
  final List<String> _companySizes = [
    '1-10 employees',
    '11-50 employees',
    '51-200 employees',
    '201-500 employees',
    '500+ employees',
  ];

  @override
  void dispose() {
    _companyNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
        title: Text(
          'Create Employer Profile',
          style: GoogleFonts.aclonica(
            fontSize: 20,
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Company Logo Section
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.electricLime,
                            width: 3,
                          ),
                          color: AppColors.grey4,
                        ),
                        child: const Icon(
                          Icons.business,
                          size: 60,
                          color: AppColors.grey6,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            // TODO: Implement image picker
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.electricLime,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.black,
                                width: 3,
                              ),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: AppColors.black,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Company Information Section
                _buildSectionTitle('Company Information'),
                const SizedBox(height: 16),
                
                _buildTextField(
                  controller: _companyNameController,
                  label: 'Company Name',
                  hint: 'Enter company name',
                  icon: Icons.business_outlined,
                ),
                
                const SizedBox(height: 16),
                
                _buildTextField(
                  controller: _emailController,
                  label: 'Company Email',
                  hint: 'contact@company.com',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                
                const SizedBox(height: 16),
                
                _buildTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  hint: '+213 XXX XXX XXX',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                
                const SizedBox(height: 16),
                
                _buildTextField(
                  controller: _websiteController,
                  label: 'Website',
                  hint: 'https://www.company.com',
                  icon: Icons.language,
                  keyboardType: TextInputType.url,
                  isRequired: false,
                ),
                
                const SizedBox(height: 24),
                
                // Industry & Size Section
                _buildSectionTitle('Business Details'),
                const SizedBox(height: 16),
                
                _buildDropdown(
                  label: 'Industry',
                  value: _selectedIndustry,
                  items: _industries,
                  onChanged: (value) {
                    setState(() {
                      _selectedIndustry = value!;
                    });
                  },
                ),
                
                const SizedBox(height: 16),
                
                _buildDropdown(
                  label: 'Company Size',
                  value: _selectedCompanySize,
                  items: _companySizes,
                  onChanged: (value) {
                    setState(() {
                      _selectedCompanySize = value!;
                    });
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Location Section
                _buildSectionTitle('Location'),
                const SizedBox(height: 16),
                
                _buildTextField(
                  controller: _cityController,
                  label: 'City',
                  hint: 'e.g., Algiers, Oran',
                  icon: Icons.location_city,
                ),
                
                const SizedBox(height: 16),
                
                _buildTextField(
                  controller: _addressController,
                  label: 'Address',
                  hint: 'Enter full address',
                  icon: Icons.location_on_outlined,
                  maxLines: 2,
                ),
                
                const SizedBox(height: 24),
                
                // Description Section
                _buildSectionTitle('Company Description'),
                const SizedBox(height: 16),
                
                _buildTextField(
                  controller: _descriptionController,
                  label: 'About Your Company',
                  hint: 'Tell students about your company, culture, and values...',
                  icon: Icons.description_outlined,
                  maxLines: 5,
                ),
                
                const SizedBox(height: 32),
                
                // Create Profile Button
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // TODO: Create employer profile
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.electricLime,
                      foregroundColor: AppColors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Create Profile',
                      style: GoogleFonts.aclonica(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Cancel Button
                SizedBox(
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.electricLime,
                      side: const BorderSide(
                        color: AppColors.electricLime,
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.aclonica(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.aclonica(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.electricLime,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool isRequired = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.aclonica(
                fontSize: 14,
                color: AppColors.white,
              ),
            ),
            if (!isRequired)
              Text(
                ' (Optional)',
                style: GoogleFonts.aclonica(
                  fontSize: 12,
                  color: AppColors.grey6,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: GoogleFonts.aclonica(
            fontSize: 14,
            color: AppColors.white,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.aclonica(
              fontSize: 14,
              color: AppColors.grey6,
            ),
            prefixIcon: Icon(icon, color: AppColors.electricLime),
            filled: true,
            fillColor: AppColors.grey4,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.grey5,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.electricLime,
                width: 2,
              ),
            ),
          ),
          validator: (value) {
            if (isRequired && (value == null || value.isEmpty)) {
              return 'This field is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.aclonica(
            fontSize: 14,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.grey4,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.grey5,
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: AppColors.electricLime),
              dropdownColor: AppColors.grey4,
              style: GoogleFonts.aclonica(
                fontSize: 14,
                color: AppColors.white,
              ),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
