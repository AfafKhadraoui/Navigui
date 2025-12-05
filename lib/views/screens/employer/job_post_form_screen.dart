import 'package:flutter/material.dart';
import '../../../data/models/job_post.dart';
import '../../../mock/mock_data.dart';

class JobPostFormScreen extends StatefulWidget {
  final JobPost? job; // If provided, we're editing

  const JobPostFormScreen({super.key, this.job});

  @override
  State<JobPostFormScreen> createState() => _JobPostFormScreenState();
}

class _JobPostFormScreenState extends State<JobPostFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final MockData _mockData = MockData();

  // Form controllers
  late final TextEditingController _titleController;
  late final TextEditingController _companyController;
  late final TextEditingController _locationController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _paymentAmountController;
  late final TextEditingController _hoursPerWeekController;
  late final TextEditingController _numberOfPositionsController;

  // Form state
  late JobType _selectedJobType;
  late String _selectedCategory;
  late List<String> _selectedLanguages;
  late bool _cvRequired;
  late PaymentType _selectedPaymentType;
  late bool _isUrgent;
  late bool _isRecurring;
  late JobStatus _selectedStatus;
  DateTime? _specificDate;
  List<String> _selectedDays = [];

  @override
  void initState() {
    super.initState();

    // Initialize with existing data or defaults
    final job = widget.job;

    _titleController = TextEditingController(text: job?.title ?? '');
    _locationController = TextEditingController(text: job?.location ?? '');
    _descriptionController =
        TextEditingController(text: job?.description ?? '');
    _paymentAmountController = TextEditingController(
      text: job?.pay.toString() ?? '',
    );
    _hoursPerWeekController = TextEditingController(text: '');
    _numberOfPositionsController = TextEditingController(
      text: job?.numberOfPositions.toString() ?? '1',
    );

    _selectedJobType = job?.jobType ?? JobType.partTime;
    _selectedCategory = job?.category ?? 'Other';
    _selectedLanguages = job?.languages ?? [];
    _cvRequired = job?.requiresCv ?? false;
    _selectedPaymentType = job?.paymentType ?? PaymentType.monthly;
    _isUrgent = job?.isUrgent ?? false;
    _isRecurring = job?.isRecurring ?? false;
    _selectedStatus = job?.status ?? JobStatus.active;
    _specificDate = job?.startDate;
    _selectedDays = [];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _paymentAmountController.dispose();
    _hoursPerWeekController.dispose();
    _numberOfPositionsController.dispose();
    super.dispose();
  }

  void _saveJobPost() {
    if (_formKey.currentState!.validate()) {
      final newJob = JobPost(
        id: widget.job?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        employerId: '1',
        title: _titleController.text,
        location: _locationController.text,
        description: _descriptionController.text,
        category: _selectedCategory,
        pay: double.parse(_paymentAmountController.text),
        paymentType: _selectedPaymentType,
        applicantsCount: widget.job?.applicantsCount ?? 0,
        jobType: _selectedJobType,
        requirements: _selectedLanguages.isNotEmpty
            ? 'Languages: ${_selectedLanguages.join(", ")}${_cvRequired ? ", CV Required" : ""}'
            : (_cvRequired ? 'CV Required' : null),
        requiresCv: _cvRequired,
        timeCommitment: _hoursPerWeekController.text.isNotEmpty
            ? '${_hoursPerWeekController.text} hours/week'
            : null,
        startDate: _specificDate,
        languages: _selectedLanguages,
        isRecurring: _isRecurring,
        isUrgent: _isUrgent,
        numberOfPositions: int.parse(_numberOfPositionsController.text),
        status: _selectedStatus,
        createdDate: widget.job?.createdDate ?? DateTime.now(),
      );

      if (widget.job != null) {
        _mockData.updateJob(newJob);
      } else {
        _mockData.addJob(newJob);
      }

      Navigator.pop(context, true);
    }
  }

  String _getSalaryString() {
    final amount = double.tryParse(_paymentAmountController.text) ?? 0;
    final typeStr = _selectedPaymentType.toString().split('.').last;
    return '\$${amount.toStringAsFixed(2)} / $typeStr';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.job != null ? 'Edit Job Post' : 'Create Job Post',
          style: const TextStyle(
            fontFamily: 'Aclonica',
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saveJobPost,
            child: const Text(
              'Save',
              style: TextStyle(
                fontFamily: 'Acme',
                fontSize: 16,
                color: Color(0xFFABD600),
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Title
            _buildTextField(
              controller: _titleController,
              label: 'Job Title',
              hint: 'e.g., UX Designer',
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),

            // Company
            _buildTextField(
              controller: _companyController,
              label: 'Company',
              hint: 'Your company name',
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),

            // Location
            _buildTextField(
              controller: _locationController,
              label: 'Location',
              hint: 'e.g., Algiers, Algeria',
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 16),

            // Description
            _buildTextField(
              controller: _descriptionController,
              label: 'Description',
              hint: 'Describe the job requirements and responsibilities',
              maxLines: 4,
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 24),

            // Job Type
            _buildSectionTitle('Job Type'),
            const SizedBox(height: 12),
            _buildJobTypeSelector(),
            const SizedBox(height: 24),

            // Categories
            _buildSectionTitle('Categories (Optional)'),
            const SizedBox(height: 12),
            _buildCategoriesSelector(),
            const SizedBox(height: 24),

            // Payment
            _buildSectionTitle('Payment'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildTextField(
                    controller: _paymentAmountController,
                    label: 'Amount',
                    hint: '0',
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdown<PaymentType>(
                    label: 'Type',
                    value: _selectedPaymentType,
                    items: PaymentType.values,
                    itemLabel: (type) => type.label,
                    onChanged: (value) {
                      setState(() => _selectedPaymentType = value!);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Languages Required
            _buildSectionTitle('Languages Required'),
            const SizedBox(height: 12),
            _buildLanguagesSelector(),
            const SizedBox(height: 24),

            // Time Commitment (for Part-Time)
            if (_selectedJobType == JobType.partTime) ...[
              _buildSectionTitle('Time Commitment'),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _hoursPerWeekController,
                label: 'Hours per Week',
                hint: '20',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _buildDaysSelector(),
              const SizedBox(height: 24),
            ],

            // Specific Date (for Quick Task)
            if (_selectedJobType == JobType.quickTask) ...[
              _buildSectionTitle('Task Date'),
              const SizedBox(height: 12),
              _buildDatePicker(),
              const SizedBox(height: 24),
            ],

            // Number of Positions
            _buildTextField(
              controller: _numberOfPositionsController,
              label: 'Number of Positions',
              hint: '1',
              keyboardType: TextInputType.number,
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: 24),

            // Options
            _buildSectionTitle('Options'),
            const SizedBox(height: 12),
            _buildSwitchTile(
              'CV Required',
              _cvRequired,
              (value) => setState(() => _cvRequired = value),
            ),
            _buildSwitchTile(
              'Mark as Urgent',
              _isUrgent,
              (value) => setState(() => _isUrgent = value),
            ),
            _buildSwitchTile(
              'Recurring Task',
              _isRecurring,
              (value) => setState(() => _isRecurring = value),
            ),
            const SizedBox(height: 24),

            // Status
            _buildSectionTitle('Status'),
            const SizedBox(height: 12),
            _buildDropdown<JobStatus>(
              label: 'Job Status',
              value: _selectedStatus,
              items: JobStatus.values,
              itemLabel: (status) => status.label,
              onChanged: (value) {
                setState(() => _selectedStatus = value!);
              },
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Aclonica',
        fontSize: 16,
        color: Colors.white,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Acme',
            fontSize: 14,
            color: Color(0xFF6C6C6C),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontFamily: 'Acme',
            fontSize: 16,
            color: Colors.white,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontFamily: 'Acme',
              fontSize: 16,
              color: Colors.grey[700],
            ),
            filled: true,
            fillColor: const Color(0xFF2F2F2F),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<T> items,
    required String Function(T) itemLabel,
    required void Function(T?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Acme',
            fontSize: 14,
            color: Color(0xFF6C6C6C),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF2F2F2F),
            borderRadius: BorderRadius.circular(15),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              dropdownColor: const Color(0xFF2F2F2F),
              style: const TextStyle(
                fontFamily: 'Acme',
                fontSize: 16,
                color: Colors.white,
              ),
              items: items.map((item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(itemLabel(item)),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildJobTypeSelector() {
    return Row(
      children: JobType.values.map((type) {
        final isSelected = _selectedJobType == type;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedJobType = type),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFABD600)
                      : const Color(0xFF2F2F2F),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    type.label,
                    style: TextStyle(
                      fontFamily: 'Acme',
                      fontSize: 14,
                      color:
                          isSelected ? const Color(0xFF1A1A1A) : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCategoriesSelector() {
    const categories = [
      'Photography',
      'Translation',
      'Graphic Design',
      'Video Editing',
      'Content Writing',
      'Tutoring',
      'Event Staff',
      'Data Entry',
      'Social Media',
      'Customer Service',
      'Sales',
      'Marketing',
      'IT Support',
      'Design',
      'Other'
    ];
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      decoration: InputDecoration(
        labelText: 'Category',
        filled: true,
        fillColor: const Color(0xFF2F2F2F),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      dropdownColor: const Color(0xFF2F2F2F),
      style: const TextStyle(color: Colors.white),
      items: categories.map((category) {
        return DropdownMenuItem(
          value: category,
          child: Text(category),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedCategory = value;
          });
        }
      },
    );
  }

  Widget _buildLanguagesSelector() {
    final availableLanguages = [
      'English',
      'French',
      'Arabic',
      'Spanish',
      'German'
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: availableLanguages.map((language) {
        final isSelected = _selectedLanguages.contains(language);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedLanguages.remove(language);
              } else {
                _selectedLanguages.add(language);
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFABD600)
                  : const Color(0xFF2F2F2F),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              language,
              style: TextStyle(
                fontFamily: 'Acme',
                fontSize: 13,
                color: isSelected ? const Color(0xFF1A1A1A) : Colors.white,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDaysSelector() {
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: days.map((day) {
        final isSelected = _selectedDays.contains(day);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedDays.remove(day);
              } else {
                _selectedDays.add(day);
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFABD600)
                  : const Color(0xFF2F2F2F),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              day.substring(0, 3),
              style: TextStyle(
                fontFamily: 'Acme',
                fontSize: 13,
                color: isSelected ? const Color(0xFF1A1A1A) : Colors.white,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _specificDate ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null) {
          setState(() => _specificDate = date);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2F2F2F),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _specificDate != null
                  ? '${_specificDate!.day}/${_specificDate!.month}/${_specificDate!.year}'
                  : 'Select Date',
              style: TextStyle(
                fontFamily: 'Acme',
                fontSize: 16,
                color: _specificDate != null ? Colors.white : Colors.grey[700],
              ),
            ),
            const Icon(Icons.calendar_today,
                color: Color(0xFFABD600), size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String label,
    bool value,
    void Function(bool) onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2F2F2F),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Acme',
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFFABD600),
          ),
        ],
      ),
    );
  }
}
