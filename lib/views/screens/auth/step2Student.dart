import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../commons/themes/style_simple/colors.dart';
import 'step3Student.dart';

class Step2StudentScreen extends StatefulWidget {
  const Step2StudentScreen({super.key});

  @override
  State<Step2StudentScreen> createState() => _Step2StudentScreenState();
}

class _Step2StudentScreenState extends State<Step2StudentScreen> {
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _universityController = TextEditingController();
  final _facultyController = TextEditingController();
  
  String? _selectedYear;
  
  final List<String> _yearOptions = [
    'First Year',
    'Second Year',
    'Third Year',
    'Fourth Year',
    'Fifth Year',
    'Master\'s - First Year',
    'Master\'s - Second Year',
    'PhD',
    'Associate Degree',
    'Bachelor\'s Degree',
    'Master\'s Degree',
    'Doctoral Degree',
  ];

  @override
  void dispose() {
    _phoneController.dispose();
    _locationController.dispose();
    _fullNameController.dispose();
    _universityController.dispose();
    _facultyController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType? keyboardType,
    bool obscureText = false,
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
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(25),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            style: GoogleFonts.aclonica(
              fontSize: 14,
              color: AppColors.white,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.aclonica(
                color: AppColors.grey6,
                fontSize: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: const BorderSide(
                  color: Color(0xFF9288EE),
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
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
                          'Step 2 of 5',
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
                        value: 2 / 5,
                        minHeight: 6,
                        backgroundColor: Colors.grey[800],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF9288EE),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),
                
                // Phone Number
                _buildTextField(
                  label: 'Phone number',
                  hint: '+213 456 7890 xxx',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                ),
                
                const SizedBox(height: 20),
                
                // Location
                _buildTextField(
                  label: 'Location',
                  hint: 'City, Country',
                  controller: _locationController,
                ),
                
                const SizedBox(height: 20),
                
                // Full Name
                _buildTextField(
                  label: 'Full Name',
                  hint: 'John Doe',
                  controller: _fullNameController,
                ),
                
                const SizedBox(height: 20),
                
                // University
                _buildTextField(
                  label: 'University',
                  hint: 'e.g., ENSIA, ESI, USTHB, ENS...etc',
                  controller: _universityController,
                ),
                
                const SizedBox(height: 20),
                
                // Faculty / Major
                _buildTextField(
                  label: 'Faculty / Major',
                  hint: 'e.g., Computer Science',
                  controller: _facultyController,
                ),
                
                const SizedBox(height: 20),
                
                // Year of Study - Dropdown
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Year of Study',
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
                          value: _selectedYear,
                          isExpanded: true,
                          hint: Text(
                            'Select your year',
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
                          items: _yearOptions.map((String year) {
                            return DropdownMenuItem<String>(
                              value: year,
                              child: Text(year, style: TextStyle(color: AppColors.white)),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedYear = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
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
                          foregroundColor: Color(0xFF9288EE),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(
                            color: Color(0xFF9288EE),
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Step3StudentScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9288EE),
                          foregroundColor: Colors.white,
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
                            color: Color(0xFF9288EE),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                            color: Color(0xFF9288EE),
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
