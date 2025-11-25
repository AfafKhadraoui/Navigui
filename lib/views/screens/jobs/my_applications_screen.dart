import 'package:flutter/material.dart';
import '../../../commons/themes/style_simple/colors.dart';
import '../../../commons/themes/style_simple/styles.dart';

class MyApplicationsScreen extends StatefulWidget {
  const MyApplicationsScreen({super.key});

  @override
  State<MyApplicationsScreen> createState() => _MyApplicationsScreenState();
}

class _MyApplicationsScreenState extends State<MyApplicationsScreen> {
  String selectedFilter = 'All';

  // Sample applications data
  final List<Map<String, dynamic>> applications = [
    {
      'id': '1',
      'title': 'UX Designer',
      'company': 'Google',
      'location': 'Algiers, Algeria',
      'appliedDate': '2 days ago',
      'status': 'Pending',
      'salary': '50000 DA/mo',
      'type': 'Full-Time',
    },
    {
      'id': '2',
      'title': 'Content Writer',
      'company': 'Lan Hayiti',
      'location': 'Algiers, Algeria',
      'appliedDate': '5 days ago',
      'status': 'Accepted',
      'salary': '5000 DA',
      'type': 'Task',
      'message': 'The employer wants to hire you! Check your email for next steps.',
    },
    {
      'id': '3',
      'title': 'QA Engineer',
      'company': 'Microsoft',
      'location': 'Oran, Algeria',
      'appliedDate': '1 week ago',
      'status': 'Rejected',
      'salary': '45000 DA/mo',
      'type': 'Full-Time',
    },
    {
      'id': '4',
      'title': 'Mobile App Tester',
      'company': 'AppDev Solutions',
      'location': 'Setif, Algeria',
      'appliedDate': '3 days ago',
      'status': 'Pending',
      'salary': '4500 DA',
      'type': 'Task',
    },
  ];

  List<Map<String, dynamic>> get filteredApplications {
    if (selectedFilter == 'All') {
      return applications;
    }
    return applications.where((app) => app['status'] == selectedFilter).toList();
  }

  int _getStatusCount(String status) {
    if (status == 'All') return applications.length;
    return applications.where((app) => app['status'] == status).length;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return const Color(0xFFFFA500);
      case 'Accepted':
        return const Color(0xFF4CAF50);
      case 'Rejected':
        return const Color(0xFF5B9FEE);
      default:
        return AppColors.grey6;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Pending':
        return Icons.access_time;
      case 'Accepted':
        return Icons.check_circle;
      case 'Rejected':
        return Icons.info_outline;
      default:
        return Icons.help_outline;
    }
  }

  void _showWithdrawDialog(BuildContext context, Map<String, dynamic> application) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.grey4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Withdraw Application',
          style: TextStyle(
            fontFamily: 'Aclonica', // Title font
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to withdraw your application for ${application['title']} at ${application['company']}?',
          style: const TextStyle(
            fontFamily: 'Acme', // Text font
            color: AppColors.grey7,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Acme', // Text font
                color: AppColors.grey6,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                applications.removeWhere((app) => app['id'] == application['id']);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Application withdrawn successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.urgentRed,
              foregroundColor: AppColors.white,
            ),
            child: const Text(
              'Withdraw',
              style: TextStyle(fontFamily: 'Aclonica'), // Title font
            ),
          ),
        ],
      ),
    );
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
          'My Applications',
          style: TextStyle(
            fontFamily: 'Aclonica', // Title font
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter Tabs with Scroll
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(vertical: 16),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppStyles.spacingMD),
              children: [
                _buildFilterChip('All', _getStatusCount('All')),
                const SizedBox(width: 12),
                _buildFilterChip('Pending', _getStatusCount('Pending')),
                const SizedBox(width: 12),
                _buildFilterChip('Accepted', _getStatusCount('Accepted')),
                const SizedBox(width: 12),
                _buildFilterChip('Rejected', _getStatusCount('Rejected')),
              ],
            ),
          ),

          // Applications List
          Expanded(
            child: filteredApplications.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: AppStyles.spacingMD),
                    itemCount: filteredApplications.length,
                    itemBuilder: (context, index) {
                      final application = filteredApplications[index];
                      return _buildApplicationCard(context, application);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int count) {
    final isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.lavenderPurple : AppColors.grey4,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? AppColors.lavenderPurple : AppColors.grey5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Acme', // Text font
                color: isSelected ? AppColors.black : AppColors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.black.withOpacity(0.2) : AppColors.grey5,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontFamily: 'Acme', // Text font
                  color: isSelected ? AppColors.black : AppColors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationCard(BuildContext context, Map<String, dynamic> application) {
    final status = application['status'] as String;
    final canWithdraw = status == 'Pending';
    final statusColor = _getStatusColor(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.grey4,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Badge
          Row(
            children: [
              Icon(
                _getStatusIcon(status),
                color: statusColor,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                status,
                style: TextStyle(
                  fontFamily: 'Acme', // Text font
                  color: statusColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Job Title and Company
          Text(
            application['title'],
            style: const TextStyle(
              fontFamily: 'Aclonica', // Title font
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            application['company'],
            style: const TextStyle(
              fontFamily: 'Acme', // Text font
              color: AppColors.grey6,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 16),

          // Location and Applied Date
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: AppColors.lavenderPurple, size: 16),
              const SizedBox(width: 6),
              Text(
                application['location'],
                style: const TextStyle(
                  fontFamily: 'Acme', // Text font
                  color: AppColors.grey6,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 20),
              const Icon(Icons.calendar_today_outlined, color: AppColors.lavenderPurple, size: 16),
              const SizedBox(width: 6),
              Text(
                'Applied ${application['appliedDate']}',
                style: const TextStyle(
                  fontFamily: 'Acme', // Text font
                  color: AppColors.grey6,
                  fontSize: 13,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Salary
          Text(
            application['salary'],
            style: const TextStyle(
              fontFamily: 'Aclonica', // Title font for emphasis
              color: AppColors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Status-specific Actions and Messages
          if (status == 'Pending') ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showWithdrawDialog(context, application),
                icon: const Icon(Icons.delete_outline, size: 18),
                label: const Text(
                  'Withdraw',
                  style: TextStyle(fontFamily: 'Acme'), // Text font
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFFFA500),
                  side: const BorderSide(color: Color(0xFFFFA500)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
          ],

          if (status == 'Accepted') ...[
            const SizedBox(height: 16),
            // Congratulations Button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.15),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: const Color(0xFF4CAF50)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.celebration, color: Color(0xFF4CAF50), size: 18),
                  const SizedBox(width: 8),
                  const Text(
                    'Congratulations!',
                    style: TextStyle(
                      fontFamily: 'Aclonica', // Title font
                      color: Color(0xFF4CAF50),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            if (application['message'] != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3A2E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF2D5A3E)),
                ),
                child: Text(
                  application['message'],
                  style: const TextStyle(
                    fontFamily: 'Acme', // Text font
                    color: Color(0xFF8BC34A),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ],

          if (status == 'Rejected') ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2A3A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF2D4A6E)),
              ),
              child: const Text(
                'Unfortunately, you were not selected. Keep applying!',
                style: TextStyle(
                  fontFamily: 'Acme', // Text font
                  color: Color(0xFF90CAF9),
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.work_outline,
            size: 80,
            color: AppColors.grey6.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No ${selectedFilter != 'All' ? selectedFilter.toLowerCase() : ''} applications',
            style: const TextStyle(
              fontFamily: 'Aclonica', // Title font
              color: AppColors.grey6,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start applying to jobs to see them here',
            style: TextStyle(
              fontFamily: 'Acme', // Text font
              color: AppColors.grey7,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}