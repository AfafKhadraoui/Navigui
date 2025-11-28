import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../commons/themes/style_simple/colors.dart';
import '../../../logic/services/auth_service.dart';
import '../../../routes/app_router.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  bool _maintenanceMode = false;
  bool _allowNewRegistrations = true;
  bool _autoApproveJobs = false;
  bool _emailNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        title: Text('Admin Settings', style: GoogleFonts.aclonica(fontSize: 22, color: AppColors.orange2)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            'Platform Controls',
            [
              _buildSwitchTile(
                'Maintenance Mode',
                'Temporarily disable access for all users',
                _maintenanceMode,
                (value) => setState(() => _maintenanceMode = value),
                Icons.construction,
              ),
              _buildSwitchTile(
                'Allow New Registrations',
                'Enable new users to sign up',
                _allowNewRegistrations,
                (value) => setState(() => _allowNewRegistrations = value),
                Icons.person_add,
              ),
              _buildSwitchTile(
                'Auto-Approve Jobs',
                'Automatically approve new job postings',
                _autoApproveJobs,
                (value) => setState(() => _autoApproveJobs = value),
                Icons.auto_awesome,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Notifications',
            [
              _buildSwitchTile(
                'Email Notifications',
                'Send email alerts for important events',
                _emailNotifications,
                (value) => setState(() => _emailNotifications = value),
                Icons.email,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Content Moderation',
            [
              _buildActionTile('Banned Words List', 'Manage prohibited content', Icons.block, () {}),
              _buildActionTile('Spam Detection Rules', 'Configure anti-spam settings', Icons.security, () {}),
              _buildActionTile('Report Thresholds', 'Set auto-moderation limits', Icons.flag, () {}),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            'System',
            [
              _buildActionTile('Database Backup', 'Create system backup', Icons.backup, _showBackupDialog),
              _buildActionTile('Clear Cache', 'Free up system resources', Icons.cleaning_services, _clearCache),
              _buildActionTile('System Logs', 'View platform activity logs', Icons.description, () {}),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Danger Zone',
            [
              _buildDangerTile('Reset Platform Stats', 'Clear all statistics', () {}),
              _buildDangerTile('Factory Reset', 'Restore to default settings', () {}),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Account',
            [
              _buildActionTile('Log Out', 'Sign out of admin account', Icons.logout, _handleLogout),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(title, style: GoogleFonts.aclonica(fontSize: 16, color: AppColors.white)),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.grey4,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: AppColors.orange2),
      title: Text(title, style: GoogleFonts.acme(fontSize: 15, color: AppColors.white)),
      subtitle: Text(subtitle, style: GoogleFonts.acme(fontSize: 12, color: AppColors.grey6)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.orange2,
      ),
    );
  }

  Widget _buildActionTile(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.orange2),
      title: Text(title, style: GoogleFonts.acme(fontSize: 15, color: AppColors.white)),
      subtitle: Text(subtitle, style: GoogleFonts.acme(fontSize: 12, color: AppColors.grey6)),
      trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.grey6, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildDangerTile(String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      leading: const Icon(Icons.warning, color: AppColors.red1),
      title: Text(title, style: GoogleFonts.acme(fontSize: 15, color: AppColors.red1)),
      subtitle: Text(subtitle, style: GoogleFonts.acme(fontSize: 12, color: AppColors.grey6)),
      trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.red1, size: 16),
      onTap: onTap,
    );
  }

  void _showBackupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.grey4,
        title: Text('Create Backup', style: GoogleFonts.aclonica(fontSize: 18, color: AppColors.orange2)),
        content: Text(
          'This will create a full backup of the platform database. This process may take several minutes.',
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
                  content: Text('Backup started...', style: GoogleFonts.acme()),
                  backgroundColor: AppColors.orange2,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.orange2, foregroundColor: AppColors.black),
            child: Text('Start Backup', style: GoogleFonts.acme(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _clearCache() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cache cleared successfully', style: GoogleFonts.acme()),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.grey4,
        title: Text('Log Out', style: GoogleFonts.aclonica(fontSize: 18, color: AppColors.orange2)),
        content: Text(
          'Are you sure you want to log out of admin mode?',
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
              // Logout logic
              final authService = context.read<AuthService>();
              authService.logout();
              context.go(AppRouter.login);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.orange2, foregroundColor: AppColors.black),
            child: Text('Log Out', style: GoogleFonts.acme(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
