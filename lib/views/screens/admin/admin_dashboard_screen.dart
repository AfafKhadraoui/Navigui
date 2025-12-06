import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../commons/themes/style_simple/colors.dart';
import '../../../logic/services/secure_storage_service.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  String _adminName = 'Admin';

  @override
  void initState() {
    super.initState();
    _loadAdminName();
  }

  Future<void> _loadAdminName() async {
    final secureStorage = SecureStorageService();
    final session = await secureStorage.getUserSession();
    if (mounted) {
      setState(() {
        _adminName = session['name'] ?? 'Admin';
      });
    }
  }

  Future<void> _refreshData() async {
    await _loadAdminName();
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        title: Text(
          'Admin Dashboard',
          style: GoogleFonts.aclonica(
            fontSize: 24,
            color: AppColors.orange2,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: AppColors.orange2),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: AppColors.orange2,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeCard(),
              const SizedBox(height: 24),
              _buildMetricsGrid(),
              const SizedBox(height: 24),
              _buildActivityChart(),
              const SizedBox(height: 24),
              _buildRecentActivities(),
              const SizedBox(height: 24),
              _buildPlatformHealth(),
              const SizedBox(height: 24),
              _buildQuickActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.grey4,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.orange2.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.orange2,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.admin_panel_settings,
                    color: AppColors.black, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, $_adminName',
                      style: GoogleFonts.acme(
                          fontSize: 20,
                          color: AppColors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Platform Status: All Systems Operational',
                      style: GoogleFonts.acme(
                          fontSize: 14, color: AppColors.grey6),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Last login: ${DateTime.now().toString().split('.')[0]}',
            style: GoogleFonts.acme(fontSize: 12, color: AppColors.grey6),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Platform Overview',
            style: GoogleFonts.aclonica(fontSize: 18, color: AppColors.white)),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
                child: _buildMetricCard('Total Users', '2,847', '+15.3%',
                    Icons.people_outline, AppColors.purple6)),
            const SizedBox(width: 12),
            Expanded(
                child: _buildMetricCard('Active Jobs', '1,234', '+8.7%',
                    Icons.work_outline, AppColors.electricLime)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
                child: _buildMetricCard('Applications', '5,621', '+22.1%',
                    Icons.assignment_outlined, AppColors.orange2)),
            const SizedBox(width: 12),
            Expanded(
                child: _buildMetricCard('Revenue', '\$48.2K', '+12.4%',
                    Icons.attach_money, AppColors.yellow1)),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(
      String title, String value, String change, IconData icon, Color color) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12)),
                child: Text(change,
                    style: GoogleFonts.acme(fontSize: 12, color: color)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(value,
              style:
                  GoogleFonts.aclonica(fontSize: 24, color: AppColors.white)),
          const SizedBox(height: 4),
          Text(title,
              style: GoogleFonts.acme(fontSize: 13, color: AppColors.grey6)),
        ],
      ),
    );
  }

  Widget _buildActivityChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: AppColors.grey4, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Activity Overview',
                  style: GoogleFonts.aclonica(
                      fontSize: 16, color: AppColors.white)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                    color: AppColors.grey5,
                    borderRadius: BorderRadius.circular(20)),
                child: Text('Last 7 days',
                    style:
                        GoogleFonts.acme(fontSize: 12, color: AppColors.grey6)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) {
                final heights = [
                  120.0,
                  150.0,
                  95.0,
                  180.0,
                  160.0,
                  140.0,
                  170.0
                ];
                final labels = [
                  'Mon',
                  'Tue',
                  'Wed',
                  'Thu',
                  'Fri',
                  'Sat',
                  'Sun'
                ];
                return _buildChartBar(heights[index], labels[index]);
              }),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Students', AppColors.purple6),
              const SizedBox(width: 20),
              _buildLegendItem('Employers', AppColors.electricLime),
              const SizedBox(width: 20),
              _buildLegendItem('Jobs', AppColors.orange2),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartBar(double height, String label) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              width: 32,
              height: height,
              decoration: BoxDecoration(
                color: AppColors.orange2,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(label,
              style: GoogleFonts.acme(fontSize: 11, color: AppColors.grey6)),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label,
            style: GoogleFonts.acme(fontSize: 12, color: AppColors.grey6)),
      ],
    );
  }

  Widget _buildRecentActivities() {
    final activities = [
      {
        'action': 'New user registered',
        'user': 'John Doe (Student)',
        'time': '5 min ago',
        'icon': Icons.person_add
      },
      {
        'action': 'Job posted',
        'user': 'TechCorp',
        'time': '12 min ago',
        'icon': Icons.work
      },
      {
        'action': 'Application submitted',
        'user': 'Jane Smith',
        'time': '23 min ago',
        'icon': Icons.assignment
      },
      {
        'action': 'Job approved',
        'user': 'StartupX',
        'time': '1 hour ago',
        'icon': Icons.check_circle
      },
      {
        'action': 'User reported',
        'user': 'Anonymous',
        'time': '2 hours ago',
        'icon': Icons.flag
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: AppColors.grey4, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Activities',
              style:
                  GoogleFonts.aclonica(fontSize: 16, color: AppColors.white)),
          const SizedBox(height: 16),
          ...activities.map((activity) => _buildActivityItem(
                activity['action'] as String,
                activity['user'] as String,
                activity['time'] as String,
                activity['icon'] as IconData,
              )),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
      String action, String user, String time, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: AppColors.orange2.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: AppColors.orange2, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(action,
                    style:
                        GoogleFonts.acme(fontSize: 14, color: AppColors.white)),
                const SizedBox(height: 2),
                Text(user,
                    style:
                        GoogleFonts.acme(fontSize: 12, color: AppColors.grey6)),
              ],
            ),
          ),
          Text(time,
              style: GoogleFonts.acme(fontSize: 11, color: AppColors.grey6)),
        ],
      ),
    );
  }

  Widget _buildPlatformHealth() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: AppColors.grey4, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Platform Health',
              style:
                  GoogleFonts.aclonica(fontSize: 16, color: AppColors.white)),
          const SizedBox(height: 16),
          _buildHealthIndicator('API Response Time', 98, AppColors.green1),
          const SizedBox(height: 12),
          _buildHealthIndicator('Database Performance', 95, AppColors.green1),
          const SizedBox(height: 12),
          _buildHealthIndicator('Server Uptime', 99.9, AppColors.green1),
          const SizedBox(height: 12),
          _buildHealthIndicator('User Satisfaction', 87, AppColors.yellow1),
        ],
      ),
    );
  }

  Widget _buildHealthIndicator(String label, double percentage, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: GoogleFonts.acme(fontSize: 13, color: AppColors.grey6)),
            Text('${percentage.toStringAsFixed(1)}%',
                style: GoogleFonts.acme(
                    fontSize: 13, color: color, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: percentage / 100,
          backgroundColor: AppColors.grey5,
          color: color,
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: AppColors.grey4, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick Actions',
              style:
                  GoogleFonts.aclonica(fontSize: 16, color: AppColors.white)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: _buildActionButton(
                      'Manage Users', Icons.people_outline, () {})),
              const SizedBox(width: 12),
              Expanded(
                  child: _buildActionButton(
                      'Review Jobs', Icons.work_outline, () {})),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: _buildActionButton(
                      'View Reports', Icons.analytics_outlined, () {})),
              const SizedBox(width: 12),
              Expanded(
                  child: _buildActionButton(
                      'Settings', Icons.settings_outlined, () {})),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.grey5,
        foregroundColor: AppColors.orange2,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.orange2.withOpacity(0.3)),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28),
          const SizedBox(height: 8),
          Text(label,
              style: GoogleFonts.acme(fontSize: 12),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
