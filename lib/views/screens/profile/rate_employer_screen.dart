import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../commons/themes/style_simple/colors.dart';

/// Rate Employer Screen
/// Allows students to rate and review employers after completing a job
class RateEmployerScreen extends StatefulWidget {
  final String employerName;
  final String? employerId;

  const RateEmployerScreen({
    super.key,
    required this.employerName,
    this.employerId,
  });

  @override
  State<RateEmployerScreen> createState() => _RateEmployerScreenState();
}

class _RateEmployerScreenState extends State<RateEmployerScreen> {
  int _overallRating = 0;
  int _communicationRating = 0;
  int _paymentRating = 0;
  int _professionalismRating = 0;
  final _reviewController = TextEditingController();
  bool _wouldRecommend = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (_overallRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please provide an overall rating',
            style: GoogleFonts.aclonica(),
          ),
          backgroundColor: AppColors.red1,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // TODO: Submit review to backend
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isSubmitting = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Thank you for your feedback!',
            style: GoogleFonts.aclonica(),
          ),
          backgroundColor: AppColors.purple6,
        ),
      );
      
      Navigator.pop(context);
    }
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
          'Rate Employer',
          style: GoogleFonts.aclonica(
            fontSize: 20,
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Employer Info Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.grey4,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.electricLime, width: 2),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.grey5,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.electricLime),
                      ),
                      child: const Icon(
                        Icons.business,
                        color: AppColors.electricLime,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.employerName,
                            style: GoogleFonts.aclonica(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rate your experience',
                            style: GoogleFonts.aclonica(
                              fontSize: 14,
                              color: AppColors.grey6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Overall Rating
              _buildRatingSection(
                'Overall Rating',
                _overallRating,
                (rating) => setState(() => _overallRating = rating),
                isRequired: true,
              ),

              const SizedBox(height: 24),

              // Communication Rating
              _buildRatingSection(
                'Communication',
                _communicationRating,
                (rating) => setState(() => _communicationRating = rating),
              ),

              const SizedBox(height: 24),

              // Payment Rating
              _buildRatingSection(
                'Payment & Compensation',
                _paymentRating,
                (rating) => setState(() => _paymentRating = rating),
              ),

              const SizedBox(height: 24),

              // Professionalism Rating
              _buildRatingSection(
                'Professionalism',
                _professionalismRating,
                (rating) => setState(() => _professionalismRating = rating),
              ),

              const SizedBox(height: 32),

              // Would Recommend
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.grey4,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.grey5),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Would you recommend this employer?',
                        style: GoogleFonts.aclonica(
                          fontSize: 14,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    Switch(
                      value: _wouldRecommend,
                      onChanged: (value) => setState(() => _wouldRecommend = value),
                      activeColor: AppColors.purple6,
                      activeTrackColor: AppColors.purple6.withOpacity(0.5),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Review Text
              Text(
                'Write Your Review',
                style: GoogleFonts.aclonica(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.grey4,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.grey5),
                ),
                child: TextField(
                  controller: _reviewController,
                  maxLines: 6,
                  style: GoogleFonts.aclonica(
                    fontSize: 14,
                    color: AppColors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Share your experience working with this employer...',
                    hintStyle: GoogleFonts.aclonica(
                      color: AppColors.grey6,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.purple6,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: AppColors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Submit Review',
                          style: GoogleFonts.aclonica(
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

  Widget _buildRatingSection(
    String title,
    int rating,
    Function(int) onRatingChanged, {
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: GoogleFonts.aclonica(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: GoogleFonts.aclonica(
                  fontSize: 16,
                  color: AppColors.red1,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.grey4,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: rating > 0 ? AppColors.purple6 : AppColors.grey5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () => onRatingChanged(index + 1),
                child: Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  color: AppColors.yellow5,
                  size: 36,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
