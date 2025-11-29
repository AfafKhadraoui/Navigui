import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../commons/themes/style_simple/colors.dart';
import '../../../routes/app_router.dart';
import 'public_student_profile_screen.dart';
import 'public_employer_profile_screen.dart';
import '../jobs/saved_jobs_screen.dart';

/// My Profile Screen
/// Shows user profile with edit button
/// Statistics tab, Portfolio tab, Reviews tab, Settings, About, Logout
class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Get actual user type from state/provider
    final bool isStudent = true; // Change this based on logged-in user type
    
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        title: Text(
          'My Profile',
          style: GoogleFonts.aclonica(
            fontSize: 20,
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.white),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isStudent ? AppColors.purple6 : AppColors.electricLime,
                    width: 3,
                  ),
                  color: AppColors.grey4,
                ),
                child: Icon(
                  isStudent ? Icons.person : Icons.business,
                  size: 60,
                  color: AppColors.grey6,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Name
              Text(
                isStudent ? 'Student Name' : 'Company Name',
                style: GoogleFonts.aclonica(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Email
              Text(
                'user@example.com',
                style: GoogleFonts.aclonica(
                  fontSize: 14,
                  color: AppColors.grey6,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Edit Profile Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (isStudent) {
                      context.push(AppRouter.editStudentProfile);
                    } else {
                      context.push(AppRouter.editEmployerProfile);
                    }
                  },
                  icon: const Icon(Icons.edit),
                  label: Text(
                    'Edit Profile',
                    style: GoogleFonts.aclonica(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isStudent ? AppColors.purple6 : AppColors.electricLime,
                    foregroundColor: isStudent ? AppColors.white : AppColors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // View Public Profile Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Navigate to public profile view - using root navigator to bypass bottom nav
                    if (isStudent) {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => const PublicStudentProfileScreen(
                            studentId: 'current_user', // TODO: Use actual user ID
                            studentName: 'Student Name',
                          ),
                        ),
                      );
                    } else {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => const PublicEmployerProfileScreen(
                            employerId: 'current_user', // TODO: Use actual user ID
                            companyName: 'Company Name',
                          ),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.visibility_outlined),
                  label: Text(
                    'View Public Profile',
                    style: GoogleFonts.aclonica(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isStudent ? AppColors.purple6 : AppColors.electricLime,
                    side: BorderSide(
                      color: isStudent ? AppColors.purple6 : AppColors.electricLime,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Profile Stats (for students)
              if (isStudent) ...[
                Row(
                  children: [
                    Expanded(child: _buildStatCard('12', 'Applications')),
                    const SizedBox(width: 8),
                    Expanded(child: _buildStatCard('3', 'Interviews')),
                    const SizedBox(width: 8),
                    Expanded(child: _buildStatCard('1', 'Hired')),
                  ],
                ),
                const SizedBox(height: 32),
                
                // Analytics Section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.grey4,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.grey5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Analytics',
                            style: GoogleFonts.aclonica(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFAB93E0),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Last 10 Days',
                                  style: GoogleFonts.aclonica(
                                    fontSize: 12,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.arrow_drop_down,
                                  color: AppColors.black,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Bar Chart
                      SizedBox(
                        height: 250,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildBarWithLabel('15', 65, '12 Jan, 2024'),
                            _buildBarWithLabel('16', 80, 'Jan 16'),
                            _buildBarWithLabel('17', 100, 'Jan 17'),
                            _buildBarWithLabel('18', 75, 'Jan 18'),
                            _buildBarWithLabel('19', 85, 'Jan 19'),
                            _buildBarWithLabel('20', 90, 'Jan 20'),
                            // _buildBarWithLabel('21', 95, 'Jan 21', showTooltip: true, tooltipValue: '65 Views'),
                            _buildBarWithLabel('21', 95, 'Jan 21'),
                            _buildBarWithLabel('22', 70, 'Jan 22'),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Total Views Summary
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.grey5,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Profile Views',
                                  style: GoogleFonts.aclonica(
                                    fontSize: 12,
                                    color: AppColors.grey6,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '635',
                                  style: GoogleFonts.aclonica(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFAB93E0),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFAB93E0).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.trending_up,
                                    color: Color(0xFFAB93E0),
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '+12.5%',
                                    style: GoogleFonts.aclonica(
                                      fontSize: 12,
                                      color: const Color(0xFFAB93E0),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
              
              // Profile Stats & Analytics (for employers)
              if (!isStudent) ...[
                Row(
                  children: [
                    Expanded(child: _buildStatCard('25', 'Active Jobs', isEmployer: true)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildStatCard('150', 'Applications', isEmployer: true)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildStatCard('32', 'Hired', isEmployer: true)),
                  ],
                ),
                const SizedBox(height: 32),
                
                // Analytics Section for Employers
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.grey4,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.grey5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Analytics',
                            style: GoogleFonts.aclonica(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.electricLime,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Last 10 Days',
                                  style: GoogleFonts.aclonica(
                                    fontSize: 12,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.arrow_drop_down,
                                  color: AppColors.black,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Bar Chart
                      SizedBox(
                        height: 250,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildBarWithLabel('15', 70, '12 Jan, 2024', isEmployer: true),
                            _buildBarWithLabel('16', 85, 'Jan 16', isEmployer: true),
                            _buildBarWithLabel('17', 95, 'Jan 17', isEmployer: true),
                            _buildBarWithLabel('18', 80, 'Jan 18', isEmployer: true),
                            _buildBarWithLabel('19', 90, 'Jan 19', isEmployer: true),
                            _buildBarWithLabel('20', 100, 'Jan 20', isEmployer: true),
                            _buildBarWithLabel('21', 88, 'Jan 21', isEmployer: true),
                            _buildBarWithLabel('22', 75, 'Jan 22', isEmployer: true),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Total Views Summary
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.grey5,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Job Views',
                                  style: GoogleFonts.aclonica(
                                    fontSize: 12,
                                    color: AppColors.grey6,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '1,247',
                                  style: GoogleFonts.aclonica(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.electricLime,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.electricLime.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.trending_up,
                                    color: AppColors.electricLime,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '+18.3%',
                                    style: GoogleFonts.aclonica(
                                      fontSize: 12,
                                      color: AppColors.electricLime,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
              
              // Menu Options
              _buildMenuOption(
                icon: Icons.work,
                title: isStudent ? 'My Applications' : 'My Job Posts',
                onTap: () {
                  // TODO: Navigate to applications/jobs
                },
              ),
              
              _buildMenuOption(
                icon: Icons.favorite,
                title: 'Saved Items',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SavedJobsScreen(),
                    ),
                  );
                },
              ),
              
              _buildMenuOption(
                icon: Icons.notifications,
                title: 'Notifications',
                onTap: () {
                  context.push(AppRouter.notifications);
                },
              ),
              
              _buildMenuOption(
                icon: Icons.help,
                title: 'Help & Support',
                onTap: () {
                  // TODO: Navigate to help
                },
              ),
              
              const SizedBox(height: 24),
              
              // Logout Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Implement logout
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: AppColors.grey4,
                        title: Text(
                          'Logout',
                          style: GoogleFonts.aclonica(color: AppColors.white),
                        ),
                        content: Text(
                          'Are you sure you want to logout?',
                          style: GoogleFonts.aclonica(
                            color: AppColors.grey6,
                            fontSize: 14,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.aclonica(
                                color: isStudent ? AppColors.purple6 : AppColors.electricLime,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              context.go(AppRouter.login);
                            },
                            child: Text(
                              'Logout',
                              style: GoogleFonts.aclonica(color: AppColors.red1),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: Text(
                    'Logout',
                    style: GoogleFonts.aclonica(
                      fontSize: 18,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.red1,
                    side: const BorderSide(
                      color: AppColors.red1,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Version Info
              Text(
                'Version 1.0.0',
                style: GoogleFonts.aclonica(
                  fontSize: 12,
                  color: AppColors.grey6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildStatCard(String value, String label, {bool isEmployer = false}) {
    final accentColor = isEmployer ? AppColors.electricLime : AppColors.purple6;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.grey4,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor, width: 1),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.aclonica(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.aclonica(
              fontSize: 11,
              color: AppColors.grey6,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
  
  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppColors.grey4,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(icon, color: AppColors.white, size: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.aclonica(
                      fontSize: 16,
                      color: AppColors.white,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.grey6,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildBarWithLabel(
    String day,
    double heightPercent,
    String date, {
    bool showTooltip = false,
    String tooltipValue = '',
    bool isEmployer = false,
  }) {
    final barHeight = (heightPercent / 100) * 150; // Max height is 150
    final barColor = isEmployer ? AppColors.electricLime : const Color(0xFFAB93E0);
    
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (showTooltip)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    tooltipValue,
                    style: GoogleFonts.aclonica(
                      fontSize: 10,
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    date,
                    style: GoogleFonts.aclonica(
                      fontSize: 8,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            )
          else
            const SizedBox(height: 40),
          
          const SizedBox(height: 8),
          
          // The actual bar
          Container(
            width: 20,
            height: barHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  barColor.withOpacity(0.5),
                  barColor,
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Day label
          Text(
            day,
            style: GoogleFonts.aclonica(
              fontSize: 10,
              color: AppColors.grey6,
            ),
          ),
        ],
      ),
    );
  }
}
