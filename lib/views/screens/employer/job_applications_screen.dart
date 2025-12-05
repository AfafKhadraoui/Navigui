import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../commons/themes/style_simple/colors.dart';
import '../../../data/models/job_post.dart';

class JobApplicationsScreen extends StatelessWidget {
  final JobPost jobPost;

  const JobApplicationsScreen({
    super.key,
    required this.jobPost,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Applications for ${jobPost.title}',
          style: GoogleFonts.aclonica(
            fontSize: 22,
            color: AppColors.white,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.assignment_ind_outlined,
              size: 64,
              color: AppColors.electricLime,
            ),
            const SizedBox(height: 16),
            Text(
              'Applications for ${jobPost.title}',
              style: GoogleFonts.aclonica(
                fontSize: 20,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'List of students that applied to this job',
              style: GoogleFonts.acme(
                fontSize: 14,
                color: AppColors.grey6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateJobDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CreateJobDialog(),
    );
  }
}

class CreateJobDialog extends StatefulWidget {
  const CreateJobDialog({super.key});

  @override
  State<CreateJobDialog> createState() => _CreateJobDialogState();
}

class _CreateJobDialogState extends State<CreateJobDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _requirementsController = TextEditingController();
  final _salaryController = TextEditingController();
  final _locationController = TextEditingController();
  
  String _selectedCategory = 'Technology';
  String _selectedJobType = 'Full-time';
  bool _isUrgent = false;
  bool _requireCV = true;

  final List<String> _categories = [
    'Technology',
    'Marketing',
    'Design',
    'Sales',
    'Customer Service',
    'Education',
    'Healthcare',
    'Finance',
    'Other',
  ];

  final List<String> _jobTypes = [
    'Full-time',
    'Part-time',
    'Contract',
    'Internship',
    'Freelance',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _requirementsController.dispose();
    _salaryController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey6,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Post New Job',
                      style: GoogleFonts.aclonica(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              
              // Form Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Dropdown
                        _buildSectionTitle('Category'),
                        const SizedBox(height: 8),
                        _buildDropdown(
                          value: _selectedCategory,
                          items: _categories,
                          onChanged: (value) {
                            setState(() => _selectedCategory = value!);
                          },
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Job Title
                        _buildSectionTitle('Job Title'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _titleController,
                          hint: 'e.g., Mobile App Developer',
                          icon: Icons.work_outline,
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Job Type
                        _buildSectionTitle('Job Type'),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _jobTypes.map((type) {
                            final isSelected = _selectedJobType == type;
                            return GestureDetector(
                              onTap: () {
                                setState(() => _selectedJobType = type);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.electricLime
                                      : AppColors.grey4,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.electricLime
                                        : AppColors.grey5,
                                  ),
                                ),
                                child: Text(
                                  type,
                                  style: GoogleFonts.aclonica(
                                    fontSize: 12,
                                    color: isSelected
                                        ? AppColors.black
                                        : AppColors.white,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Description
                        _buildSectionTitle('Description'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _descriptionController,
                          hint: 'Describe the job responsibilities...',
                          icon: Icons.description_outlined,
                          maxLines: 4,
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Requirements
                        _buildSectionTitle('Requirements'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _requirementsController,
                          hint: 'List required skills and qualifications...',
                          icon: Icons.checklist,
                          maxLines: 3,
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Salary Range
                        _buildSectionTitle('Salary Range'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _salaryController,
                          hint: 'e.g., 50,000 - 80,000 DZD/month',
                          icon: Icons.payments_outlined,
                          keyboardType: TextInputType.text,
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Location
                        _buildSectionTitle('Location'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _locationController,
                          hint: 'e.g., Algiers, Algeria',
                          icon: Icons.location_on_outlined,
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Additional Options
                        _buildSectionTitle('Additional Options'),
                        const SizedBox(height: 12),
                        
                        _buildSwitchTile(
                          title: 'Mark as Urgent',
                          subtitle: 'Highlight this job posting',
                          value: _isUrgent,
                          onChanged: (value) {
                            setState(() => _isUrgent = value);
                          },
                        ),
                        
                        const SizedBox(height: 8),
                        
                        _buildSwitchTile(
                          title: 'Require CV',
                          subtitle: 'Applicants must attach their CV',
                          value: _requireCV,
                          onChanged: (value) {
                            setState(() => _requireCV = value);
                          },
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  // TODO: Save as draft
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Saved in drafts',
                                        style: GoogleFonts.aclonica(),
                                      ),
                                      backgroundColor: AppColors.grey4,
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.electricLime,
                                  side: const BorderSide(
                                    color: AppColors.electricLime,
                                    width: 2,
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'Save Draft',
                                  style: GoogleFonts.aclonica(fontSize: 16),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    // TODO: Submit job posting
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Job posted successfully!',
                                          style: GoogleFonts.aclonica(),
                                        ),
                                        backgroundColor: AppColors.electricLime,
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.electricLime,
                                  foregroundColor: AppColors.black,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Post Job',
                                  style: GoogleFonts.aclonica(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.aclonica(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.electricLime,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
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
        prefixIcon: Icon(icon, color: AppColors.electricLime, size: 20),
        filled: true,
        fillColor: AppColors.grey4,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.grey5, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.electricLime, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.grey4,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey5, width: 1),
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
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required void Function(bool) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey4,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey5, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.aclonica(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.aclonica(
                    fontSize: 12,
                    color: AppColors.grey6,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.electricLime,
            activeTrackColor: AppColors.electricLime.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}
