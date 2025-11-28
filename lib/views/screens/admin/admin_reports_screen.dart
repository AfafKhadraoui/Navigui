import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../commons/themes/style_simple/colors.dart';

class AdminReportsScreen extends StatefulWidget {
  const AdminReportsScreen({super.key});

  @override
  State<AdminReportsScreen> createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen> {
  String _selectedPeriod = 'This Month';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        title: Text('Reports & Analytics', style: GoogleFonts.aclonica(fontSize: 22, color: AppColors.orange2)),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download, color: AppColors.orange2),
            onPressed: _exportReport,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPeriodSelector(),
            const SizedBox(height: 24),
            _buildOverviewCards(),
            const SizedBox(height: 24),
            _buildUserGrowthChart(),
            const SizedBox(height: 24),
            _buildRevenueChart(),
            const SizedBox(height: 24),
            _buildTopPerformers(),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.grey4,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildPeriodButton('Today'),
          _buildPeriodButton('This Week'),
          _buildPeriodButton('This Month'),
          _buildPeriodButton('This Year'),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(String label) {
    final isSelected = _selectedPeriod == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPeriod = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.orange2 : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.acme(
              fontSize: 13,
              color: isSelected ? AppColors.black : AppColors.grey6,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewCards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildOverviewCard('New Users', '347', '+24%', Icons.person_add, AppColors.purple6)),
            const SizedBox(width: 12),
            Expanded(child: _buildOverviewCard('New Jobs', '89', '+12%', Icons.work_outline, AppColors.electricLime)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildOverviewCard('Applications', '1,234', '+31%', Icons.assignment, AppColors.orange2)),
            const SizedBox(width: 12),
            Expanded(child: _buildOverviewCard('Revenue', '\$12.4K', '+18%', Icons.attach_money, AppColors.yellow1)),
          ],
        ),
      ],
    );
  }

  Widget _buildOverviewCard(String title, String value, String change, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey4,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(value, style: GoogleFonts.aclonica(fontSize: 22, color: AppColors.white)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: GoogleFonts.acme(fontSize: 12, color: AppColors.grey6)),
              Text(change, style: GoogleFonts.acme(fontSize: 12, color: color, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserGrowthChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.grey4,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('User Growth', style: GoogleFonts.aclonica(fontSize: 16, color: AppColors.white)),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(12, (index) {
                final heights = [80.0, 95.0, 110.0, 105.0, 130.0, 145.0, 150.0, 155.0, 160.0, 170.0, 175.0, 180.0];
                return _buildGrowthBar(heights[index], (index + 1).toString());
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrowthBar(double height, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 20,
          height: height,
          decoration: BoxDecoration(
            color: AppColors.purple6,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: GoogleFonts.acme(fontSize: 10, color: AppColors.grey6)),
      ],
    );
  }

  Widget _buildRevenueChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.grey4,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Revenue Trend', style: GoogleFonts.aclonica(fontSize: 16, color: AppColors.white)),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(8, (index) {
                final heights = [60.0, 75.0, 85.0, 95.0, 110.0, 120.0, 135.0, 150.0];
                return _buildRevenueBar(heights[index]);
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueBar(double height) {
    return Container(
      width: 30,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.yellow1,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  Widget _buildTopPerformers() {
    final topUsers = [
      {'name': 'Sarah Johnson', 'applications': 45, 'type': 'Student'},
      {'name': 'TechCorp', 'jobs': 23, 'type': 'Employer'},
      {'name': 'Ahmed Benali', 'applications': 38, 'type': 'Student'},
      {'name': 'StartupX', 'jobs': 19, 'type': 'Employer'},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.grey4,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Top Performers', style: GoogleFonts.aclonica(fontSize: 16, color: AppColors.white)),
          const SizedBox(height: 16),
          ...topUsers.map((user) => _buildPerformerItem(user)),
        ],
      ),
    );
  }

  Widget _buildPerformerItem(Map<String, dynamic> user) {
    final isEmployer = user['type'] == 'Employer';
    final metric = isEmployer ? '${user['jobs']} Jobs' : '${user['applications']} Applications';
    final color = isEmployer ? AppColors.electricLime : AppColors.purple6;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color.withOpacity(0.2),
            child: Text(user['name'][0], style: GoogleFonts.aclonica(fontSize: 16, color: color)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user['name'], style: GoogleFonts.acme(fontSize: 14, color: AppColors.white)),
                Text(user['type'], style: GoogleFonts.acme(fontSize: 12, color: AppColors.grey6)),
              ],
            ),
          ),
          Text(metric, style: GoogleFonts.acme(fontSize: 13, color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _exportReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Report exported successfully', style: GoogleFonts.acme()),
        backgroundColor: AppColors.green1,
      ),
    );
  }
}
