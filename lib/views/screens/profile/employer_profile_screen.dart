import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../commons/themes/style_simple/colors.dart';
import '../../../logic/models/job_post.dart';
import '../../../utils/mock_data.dart';
import '../../../routes/app_router.dart';
import 'public_employer_profile_screen.dart';

/// Employer Profile Screen (Own Profile Management)
/// Shows: Logo, business name, industry, description, location,
/// rating, reviews, active jobs, company size with Edit & View Public Profile buttons
class EmployerProfileScreen extends StatefulWidget {
  const EmployerProfileScreen({super.key});

  @override
  State<EmployerProfileScreen> createState() => _EmployerProfileScreenState();
}

class _EmployerProfileScreenState extends State<EmployerProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<JobPost> _jobs = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadJobs();
  }

  void _loadJobs() {
    // TODO: Load jobs from backend
    setState(() {
      _jobs = [];
    });
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
        title: Text(
          'My Company Profile',
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              
              // Company Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.electricLime,
                    width: 3,
                  ),
                  color: AppColors.grey4,
                ),
                child: const Icon(
                  Icons.business,
                  size: 60,
                  color: AppColors.grey6,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Company Name
              Text(
                'Tech Solutions Inc.',
                style: GoogleFonts.aclonica(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Industry
              Text(
                'Technology & Software Development',
                style: GoogleFonts.aclonica(
                  fontSize: 16,
                  color: AppColors.electricLime,
                ),
              ),
              
              const SizedBox(height: 4),
              
              // Location
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on, color: AppColors.grey6, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'Algiers, Algeria',
                    style: GoogleFonts.aclonica(
                      fontSize: 14,
                      color: AppColors.grey6,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Rating
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(5, (index) {
                    return Icon(
                      index < 4 ? Icons.star : Icons.star_border,
                      color: AppColors.yellow5,
                      size: 20,
                    );
                  }),
                  const SizedBox(width: 8),
                  Text(
                    '4.5 (28 reviews)',
                    style: GoogleFonts.aclonica(
                      fontSize: 14,
                      color: AppColors.grey6,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Stats Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(child: _buildStatCard('50+', 'Active Jobs')),
                    const SizedBox(width: 8),
                    Expanded(child: _buildStatCard('200+', 'Hires Made')),
                    const SizedBox(width: 8),
                    Expanded(child: _buildStatCard('4.5', 'Rating')),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Edit Profile Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.push(AppRouter.editEmployerProfile);
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
                      backgroundColor: AppColors.electricLime,
                      foregroundColor: AppColors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // View Public Profile Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => const PublicEmployerProfileScreen(
                            employerId: 'current_user', // TODO: Use actual user ID
                            companyName: 'Tech Solutions Inc.',
                          ),
                        ),
                      );
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
                      foregroundColor: AppColors.electricLime,
                      side: const BorderSide(
                        color: AppColors.electricLime,
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Tab Bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: AppColors.grey4,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: AppColors.electricLime,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelColor: AppColors.black,
                  unselectedLabelColor: AppColors.grey6,
                  labelStyle: GoogleFonts.aclonica(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: GoogleFonts.aclonica(
                    fontSize: 14,
                  ),
                  tabs: const [
                    Tab(text: 'About'),
                    Tab(text: 'Jobs'),
                    Tab(text: 'Reviews'),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Tab Content
              SizedBox(
                height: 500,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildAboutTab(),
                    _buildJobsTab(),
                    _buildReviewsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Company Description'),
          const SizedBox(height: 12),
          _buildInfoCard(
            'Tech Solutions Inc. is a leading technology company specializing in custom software development, mobile applications, and digital transformation services. We work with businesses of all sizes to bring their digital ideas to life.',
          ),
          
          const SizedBox(height: 24),
          
          _buildSectionTitle('Industry'),
          const SizedBox(height: 12),
          _buildInfoCard('Technology & Software Development'),
          
          const SizedBox(height: 24),
          
          _buildSectionTitle('Company Size'),
          const SizedBox(height: 12),
          _buildInfoCard('51-200 employees'),
          
          const SizedBox(height: 24),
          
          _buildSectionTitle('Specializations'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildChip('Mobile Development'),
              _buildChip('Web Development'),
              _buildChip('Cloud Solutions'),
              _buildChip('AI & Machine Learning'),
              _buildChip('UI/UX Design'),
              _buildChip('DevOps'),
            ],
          ),
          
          const SizedBox(height: 24),
          
          _buildSectionTitle('Contact Information'),
          const SizedBox(height: 12),
          _buildContactItem(Icons.email, 'contact@techsolutions.dz'),
          _buildContactItem(Icons.phone, '+213 XXX XXX XXX'),
          _buildContactItem(Icons.language, 'www.techsolutions.dz'),
          _buildContactItem(Icons.location_on, '123 Business Street, Algiers'),
          
          const SizedBox(height: 24),
          
          _buildSectionTitle('Founded'),
          const SizedBox(height: 12),
          _buildInfoCard('2018'),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildJobsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Active Job Postings'),
          const SizedBox(height: 12),
          
          if (_jobs.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'No jobs posted yet',
                  style: GoogleFonts.aclonica(
                    fontSize: 14,
                    color: AppColors.grey6,
                  ),
                ),
              ),
            )
          else
            ..._jobs.map((job) => _buildJobCard(job)),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _buildReviewCard(
            name: 'Ahmed Benali',
            role: 'Former Employee - Developer',
            rating: 5,
            date: '1 month ago',
            review: 'Great company to work with! Professional environment, supportive team, and excellent learning opportunities. The management truly cares about employee growth.',
          ),
          _buildReviewCard(
            name: 'Sarah Mansouri',
            role: 'Current Employee - Designer',
            rating: 5,
            date: '2 months ago',
            review: 'Amazing workplace! The team is collaborative and the projects are challenging and rewarding. Work-life balance is respected.',
          ),
          _buildReviewCard(
            name: 'Karim Djellouli',
            role: 'Former Intern',
            rating: 4,
            date: '3 months ago',
            review: 'Had a wonderful internship experience. Learned a lot from experienced developers and got hands-on experience with real projects.',
          ),
          _buildReviewCard(
            name: 'Nadia Cherif',
            role: 'Former Employee - Project Manager',
            rating: 5,
            date: '4 months ago',
            review: 'Professional and well-organized company. The management is transparent and the work environment is very positive.',
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.grey4,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.electricLime, width: 1),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.aclonica(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.electricLime,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.aclonica(
              fontSize: 10,
              color: AppColors.grey6,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.aclonica(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.electricLime,
      ),
    );
  }

  Widget _buildInfoCard(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey4,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey5),
      ),
      child: Text(
        text,
        style: GoogleFonts.aclonica(
          fontSize: 14,
          color: AppColors.white,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.electricLime.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.electricLime),
      ),
      child: Text(
        label,
        style: GoogleFonts.aclonica(
          fontSize: 12,
          color: AppColors.white,
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.electricLime, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.aclonica(
                fontSize: 14,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(JobPost job) {
    return GestureDetector(
      onTap: () {
        context.push('${AppRouter.jobPostDetail}/${job.id}', extra: job);
      },
      child: Container(
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
            Text(
              job.title,
              style: GoogleFonts.aclonica(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              job.description,
              style: GoogleFonts.aclonica(
                fontSize: 13,
                color: AppColors.grey6,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.payments, color: AppColors.electricLime, size: 18),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          job.salary,
                          style: GoogleFonts.aclonica(
                            fontSize: 13,
                            color: AppColors.electricLime,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Row(
                  children: [
                    Icon(Icons.people, color: AppColors.grey6, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      '${job.applications} applicants',
                      style: GoogleFonts.aclonica(
                        fontSize: 13,
                        color: AppColors.grey6,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard({
    required String name,
    required String role,
    required int rating,
    required String date,
    required String review,
  }) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.aclonica(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    Text(
                      role,
                      style: GoogleFonts.aclonica(
                        fontSize: 12,
                        color: AppColors.grey6,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                date,
                style: GoogleFonts.aclonica(
                  fontSize: 12,
                  color: AppColors.grey6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: AppColors.yellow5,
                size: 16,
              );
            }),
          ),
          const SizedBox(height: 12),
          Text(
            review,
            style: GoogleFonts.aclonica(
              fontSize: 14,
              color: AppColors.white,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
