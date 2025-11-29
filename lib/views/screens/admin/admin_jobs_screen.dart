import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../commons/themes/style_simple/colors.dart';

class AdminJobsScreen extends StatefulWidget {
  const AdminJobsScreen({super.key});

  @override
  State<AdminJobsScreen> createState() => _AdminJobsScreenState();
}

class _AdminJobsScreenState extends State<AdminJobsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        title: Text('Job Moderation', style: GoogleFonts.aclonica(fontSize: 22, color: AppColors.orange2)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.orange2,
          labelColor: AppColors.orange2,
          unselectedLabelColor: AppColors.grey6,
          labelStyle: GoogleFonts.acme(fontSize: 15, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Approved'),
            Tab(text: 'Rejected'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildJobList('pending'),
          _buildJobList('approved'),
          _buildJobList('rejected'),
        ],
      ),
    );
  }

  Widget _buildJobList(String status) {
    final jobs = _getMockJobs(status);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        return _buildJobCard(jobs[index]);
      },
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey4,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.orange2.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.work, color: AppColors.orange2, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job['title'],
                      style: GoogleFonts.acme(fontSize: 16, color: AppColors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(job['company'], style: GoogleFonts.acme(fontSize: 13, color: AppColors.grey6)),
                  ],
                ),
              ),
              _buildStatusBadge(job['status']),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            job['description'],
            style: GoogleFonts.acme(fontSize: 13, color: AppColors.grey6),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.attach_money, size: 16, color: AppColors.yellow1),
              const SizedBox(width: 4),
              Text(job['salary'], style: GoogleFonts.acme(fontSize: 12, color: AppColors.yellow1)),
              const SizedBox(width: 16),
              Icon(Icons.location_on, size: 16, color: AppColors.grey6),
              const SizedBox(width: 4),
              Text(job['location'], style: GoogleFonts.acme(fontSize: 12, color: AppColors.grey6)),
              const SizedBox(width: 16),
              Icon(Icons.access_time, size: 16, color: AppColors.grey6),
              const SizedBox(width: 4),
              Text(job['posted'], style: GoogleFonts.acme(fontSize: 12, color: AppColors.grey6)),
            ],
          ),
          if (job['status'] == 'pending') ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _approveJob(job),
                    icon: const Icon(Icons.check_circle, size: 18),
                    label: Text('Approve', style: GoogleFonts.acme(fontSize: 13, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green1,
                      foregroundColor: AppColors.black,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _rejectJob(job),
                    icon: const Icon(Icons.cancel, size: 18),
                    label: Text('Reject', style: GoogleFonts.acme(fontSize: 13, fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.red1,
                      side: BorderSide(color: AppColors.red1),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'pending':
        color = AppColors.yellow1;
        break;
      case 'approved':
        color = AppColors.green1;
        break;
      case 'rejected':
        color = AppColors.red1;
        break;
      default:
        color = AppColors.grey6;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: GoogleFonts.acme(fontSize: 11, color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _approveJob(Map<String, dynamic> job) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.grey4,
        title: Text('Approve Job', style: GoogleFonts.aclonica(fontSize: 18, color: AppColors.green1)),
        content: Text(
          'Approve "${job['title']}" by ${job['company']}?',
          style: GoogleFonts.acme(fontSize: 14, color: AppColors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.acme(color: AppColors.grey6)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Job approved successfully', style: GoogleFonts.acme()),
                  backgroundColor: AppColors.green1,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.green1, foregroundColor: AppColors.black),
            child: Text('Approve', style: GoogleFonts.acme(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _rejectJob(Map<String, dynamic> job) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.grey4,
        title: Text('Reject Job', style: GoogleFonts.aclonica(fontSize: 18, color: AppColors.red1)),
        content: Text(
          'Reject "${job['title']}" by ${job['company']}? Please provide a reason.',
          style: GoogleFonts.acme(fontSize: 14, color: AppColors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.acme(color: AppColors.grey6)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Job rejected', style: GoogleFonts.acme()),
                  backgroundColor: AppColors.red1,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.red1, foregroundColor: AppColors.white),
            child: Text('Reject', style: GoogleFonts.acme(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getMockJobs(String status) {
    final allJobs = [
      {
        'title': 'Senior Flutter Developer',
        'company': 'TechCorp',
        'description': 'Looking for experienced Flutter developer to join our team...',
        'salary': '\$60k - \$80k',
        'location': 'Algiers',
        'posted': '2 hours ago',
        'status': 'pending',
      },
      {
        'title': 'UI/UX Designer',
        'company': 'DesignHub',
        'description': 'Creative designer needed for mobile app projects...',
        'salary': '\$45k - \$65k',
        'location': 'Oran',
        'posted': '5 hours ago',
        'status': 'pending',
      },
      {
        'title': 'Marketing Manager',
        'company': 'StartupX',
        'description': 'Lead our marketing efforts and grow our brand...',
        'salary': '\$50k - \$70k',
        'location': 'Constantine',
        'posted': '1 day ago',
        'status': 'approved',
      },
      {
        'title': 'Data Analyst',
        'company': 'DataCo',
        'description': 'Analyze data and provide insights for business decisions...',
        'salary': '\$55k - \$75k',
        'location': 'Algiers',
        'posted': '2 days ago',
        'status': 'approved',
      },
      {
        'title': 'Fake Job Posting',
        'company': 'Scam Company',
        'description': 'Suspicious job posting with unrealistic promises...',
        'salary': '\$200k',
        'location': 'Unknown',
        'posted': '3 days ago',
        'status': 'rejected',
      },
    ];

    return allJobs.where((job) => job['status'] == status).toList();
  }
}
