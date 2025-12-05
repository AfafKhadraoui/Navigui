import 'package:flutter/material.dart';
import '../../../commons/themes/style_simple/colors.dart';
import '../../../commons/themes/style_simple/styles.dart';
import '../../../utils/mock_data.dart';
import '../../../data/models/job_model.dart';

/// Urgent Jobs Section Widget
/// Purpose: Display jobs that require immediate attention (isUrgent = true)
///
/// Features to implement:
/// - Load urgent jobs using MockData.getUrgentJobs()
/// - Display first 3 urgent jobs in vertical list
/// - Red-themed cards to emphasize urgency
/// - Show: job title, category, location, pay
/// - "URGENT" badge in section header
/// - Navigate to job details on card tap
/// - Hide entire section if no urgent jobs
/// - "See All" button to navigate to all urgent jobs
///
/// UI Requirements:
/// - Red tinted background (error.withOpacity(0.05))
/// - Red border on cards
/// - Red icon background
/// - Clock icon to indicate time sensitivity
/// - ListTile format for compact display
/// - Loading state
class UrgentJobsSection extends StatefulWidget {
  const UrgentJobsSection({super.key});

  @override
  State<UrgentJobsSection> createState() => _UrgentJobsSectionState();
}

class _UrgentJobsSectionState extends State<UrgentJobsSection> {
  // TODO: Add state variables
  // List<JobModel> _urgentJobs = [];
  // bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // TODO: Load urgent jobs from MockData
    // Call _loadUrgentJobs() method
  }

  // TODO: Implement _loadUrgentJobs() method
  // - Use MockData.getUrgentJobs() to get filtered jobs
  // - Take first 3 jobs
  // - Update state with setState()

  @override
  Widget build(BuildContext context) {
    // TODO: Show loading if _isLoading
    // TODO: Return SizedBox.shrink() if _urgentJobs.isEmpty (hide section)

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TODO: Add section header with "Urgent Jobs" title and "URGENT" badge

        // TODO: Add vertical ListView.builder
        // - shrinkWrap: true
        // - physics: NeverScrollableScrollPhysics
        // - Red-themed cards with ListTile
        // - Show clock icon, job title, category, location, pay
      ],
    );
  }
}
