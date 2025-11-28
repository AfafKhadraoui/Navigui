import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../commons/themes/style_simple/colors.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        title: Text('User Management', style: GoogleFonts.aclonica(fontSize: 22, color: AppColors.orange2)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.orange2,
          labelColor: AppColors.orange2,
          unselectedLabelColor: AppColors.grey6,
          labelStyle: GoogleFonts.acme(fontSize: 15, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'All Users'),
            Tab(text: 'Students'),
            Tab(text: 'Employers'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildUserList('all'),
                _buildUserList('student'),
                _buildUserList('employer'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.grey4,
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            style: GoogleFonts.acme(color: AppColors.white),
            decoration: InputDecoration(
              hintText: 'Search users...',
              hintStyle: GoogleFonts.acme(color: AppColors.grey6),
              prefixIcon: const Icon(Icons.search, color: AppColors.orange2),
              filled: true,
              fillColor: AppColors.grey5,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All'),
                _buildFilterChip('Active'),
                _buildFilterChip('Inactive'),
                _buildFilterChip('Suspended'),
                _buildFilterChip('Reported'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label, style: GoogleFonts.acme(fontSize: 13)),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = label;
          });
        },
        selectedColor: AppColors.orange2,
        backgroundColor: AppColors.grey5,
        labelStyle: TextStyle(color: isSelected ? AppColors.black : AppColors.grey6),
        checkmarkColor: AppColors.black,
      ),
    );
  }

  Widget _buildUserList(String type) {
    final users = _getMockUsers(type);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        return _buildUserCard(users[index]);
      },
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey4,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: user['type'] == 'student' ? AppColors.purple6 : AppColors.electricLime,
                child: Text(
                  user['name'][0],
                  style: GoogleFonts.aclonica(fontSize: 20, color: AppColors.black),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            user['name'],
                            style: GoogleFonts.acme(fontSize: 16, color: AppColors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        _buildStatusBadge(user['status']),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(user['email'], style: GoogleFonts.acme(fontSize: 13, color: AppColors.grey6)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: user['type'] == 'student' ? AppColors.purple6.withOpacity(0.2) : AppColors.electricLime.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            user['type'] == 'student' ? 'Student' : 'Employer',
                            style: GoogleFonts.acme(
                              fontSize: 11,
                              color: user['type'] == 'student' ? AppColors.purple6 : AppColors.electricLime,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Joined ${user['joined']}',
                          style: GoogleFonts.acme(fontSize: 11, color: AppColors.grey6),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActionButton('View Profile', Icons.person_outline, () {
                  _showUserDetails(user);
                }),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionButton('Suspend', Icons.block, () {
                  _showSuspendDialog(user);
                }, color: AppColors.red1),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.more_vert, color: AppColors.grey6),
                onPressed: () {
                  _showUserOptionsMenu(context, user);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'active':
        color = AppColors.green1;
        break;
      case 'suspended':
        color = AppColors.red1;
        break;
      case 'reported':
        color = AppColors.orange2;
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

  Widget _buildActionButton(String label, IconData icon, VoidCallback onPressed, {Color? color}) {
    final buttonColor = color ?? AppColors.orange2;
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label, style: GoogleFonts.acme(fontSize: 12)),
      style: OutlinedButton.styleFrom(
        foregroundColor: buttonColor,
        side: BorderSide(color: buttonColor.withOpacity(0.5)),
        padding: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showUserDetails(Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.grey4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('User Details', style: GoogleFonts.aclonica(fontSize: 20, color: AppColors.orange2)),
              const SizedBox(height: 20),
              _buildDetailRow('Name', user['name']),
              _buildDetailRow('Email', user['email']),
              _buildDetailRow('Type', user['type'] == 'student' ? 'Student' : 'Employer'),
              _buildDetailRow('Status', user['status']),
              _buildDetailRow('Joined', user['joined']),
              _buildDetailRow('Applications', '${user['applications']}'),
              _buildDetailRow('Reports', '${user['reports']}'),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange2,
                    foregroundColor: AppColors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Close', style: GoogleFonts.acme(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.acme(fontSize: 14, color: AppColors.grey6)),
          Text(value, style: GoogleFonts.acme(fontSize: 14, color: AppColors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showSuspendDialog(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.grey4,
          title: Text('Suspend User', style: GoogleFonts.aclonica(fontSize: 18, color: AppColors.red1)),
          content: Text(
            'Are you sure you want to suspend ${user['name']}? They will no longer be able to access the platform.',
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
                    content: Text('${user['name']} has been suspended', style: GoogleFonts.acme()),
                    backgroundColor: AppColors.red1,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red1,
                foregroundColor: AppColors.white,
              ),
              child: Text('Suspend', style: GoogleFonts.acme(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _showUserOptionsMenu(BuildContext context, Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.grey4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMenuOption(Icons.email, 'Send Email', () {}),
            _buildMenuOption(Icons.history, 'View Activity Log', () {}),
            _buildMenuOption(Icons.warning, 'View Reports', () {}),
            _buildMenuOption(Icons.delete, 'Delete Account', () {}, color: AppColors.red1),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Widget _buildMenuOption(IconData icon, String label, VoidCallback onTap, {Color? color}) {
    final optionColor = color ?? AppColors.white;
    return ListTile(
      leading: Icon(icon, color: optionColor),
      title: Text(label, style: GoogleFonts.acme(fontSize: 15, color: optionColor)),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  List<Map<String, dynamic>> _getMockUsers(String type) {
    final allUsers = [
      {
        'name': 'Sarah Johnson',
        'email': 'sarah.j@email.com',
        'type': 'student',
        'status': 'Active',
        'joined': 'Jan 2024',
        'applications': 12,
        'reports': 0,
      },
      {
        'name': 'TechCorp Inc',
        'email': 'hr@techcorp.com',
        'type': 'employer',
        'status': 'Active',
        'joined': 'Mar 2024',
        'applications': 45,
        'reports': 0,
      },
      {
        'name': 'Ahmed Benali',
        'email': 'ahmed.b@email.com',
        'type': 'student',
        'status': 'Reported',
        'joined': 'Feb 2024',
        'applications': 8,
        'reports': 2,
      },
      {
        'name': 'StartupX',
        'email': 'contact@startupx.com',
        'type': 'employer',
        'status': 'Active',
        'joined': 'Apr 2024',
        'applications': 23,
        'reports': 0,
      },
      {
        'name': 'Lina Kaci',
        'email': 'lina.k@email.com',
        'type': 'student',
        'status': 'Suspended',
        'joined': 'Jan 2024',
        'applications': 5,
        'reports': 3,
      },
    ];

    if (type == 'all') return allUsers;
    return allUsers.where((user) => user['type'] == type).toList();
  }
}
