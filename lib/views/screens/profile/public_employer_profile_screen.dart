import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../commons/themes/style_simple/colors.dart';

/// Public Employer Profile Screen (View Any Employer)
/// Shows: Logo, business name, industry, description, location,
/// rating, reviews, active jobs, company size
class PublicEmployerProfileScreen extends StatefulWidget {
  final String employerId;
  final String? companyName;

  const PublicEmployerProfileScreen({
    super.key,
    required this.employerId,
    this.companyName,
  });

  @override
  State<PublicEmployerProfileScreen> createState() => _PublicEmployerProfileScreenState();
}

class _PublicEmployerProfileScreenState extends State<PublicEmployerProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;

  // Mock data - replace with API call
  final Map<String, dynamic> _companyData = {
    'name': 'Tech Solutions Inc.',
    'industry': 'Technology & Software Development',
    'location': 'Algiers, Algeria',
    'description': 'Tech Solutions Inc. is a leading technology company specializing in custom software development, mobile applications, and digital transformation services. We work with businesses of all sizes to bring their digital ideas to life.',
    'companySize': '51-200 employees',
    'founded': '2018',
    'rating': 4.5,
    'reviewCount': 28,
    'activeJobs': 12,
    'totalHires': 150,
    'logo': null,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadCompanyData();
  }

  Future<void> _loadCompanyData() async {
    // TODO: Load from API using widget.employerId
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Company Profile',
          style: GoogleFonts.aclonica(
            fontSize: 20,
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: AppColors.white),
            onPressed: () {
              // TODO: Implement share
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Share feature coming soon',
                    style: GoogleFonts.aclonica(),
                  ),
                  backgroundColor: AppColors.electricLime,
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.electricLime))
          : SafeArea(
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        _companyData['name'],
                        style: GoogleFonts.aclonica(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Industry
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        _companyData['industry'],
                        style: GoogleFonts.aclonica(
                          fontSize: 16,
                          color: AppColors.electricLime,
                        ),
                        textAlign: TextAlign.center,
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
                          _companyData['location'],
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
                            index < (_companyData['rating'] as double).floor() ? Icons.star : Icons.star_border,
                            color: AppColors.yellow5,
                            size: 20,
                          );
                        }),
                        const SizedBox(width: 8),
                        Text(
                          '${_companyData['rating']} (${_companyData['reviewCount']} reviews)',
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
                          Expanded(child: _buildStatCard('${_companyData['activeJobs']}', 'Active Jobs')),
                          const SizedBox(width: 8),
                          Expanded(child: _buildStatCard('${_companyData['totalHires']}+', 'Hires Made')),
                          const SizedBox(width: 8),
                          Expanded(child: _buildStatCard('${_companyData['rating']}', 'Rating')),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Action Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: View all jobs from this employer
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Viewing all jobs from ${_companyData['name']}',
                                  style: GoogleFonts.aclonica(),
                                ),
                                backgroundColor: AppColors.electricLime,
                              ),
                            );
                          },
                          icon: const Icon(Icons.work_outline, size: 20),
                          label: Text(
                            'View All Jobs',
                            style: GoogleFonts.aclonica(
                              fontSize: 16,
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
                          Tab(text: 'Benefits'),
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
                          _buildBenefitsTab(),
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
          _buildInfoCard(_companyData['description']),
          
          const SizedBox(height: 24),
          
          _buildSectionTitle('Company Size'),
          const SizedBox(height: 12),
          _buildInfoCard(_companyData['companySize']),
          
          const SizedBox(height: 24),
          
          _buildSectionTitle('Founded'),
          const SizedBox(height: 12),
          _buildInfoCard(_companyData['founded']),
          
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
        ],
      ),
    );
  }

  Widget _buildBenefitsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('What We Offer'),
          const SizedBox(height: 12),
          
          _buildBenefitCard(
            Icons.attach_money,
            'Competitive Salary',
            'Market-competitive compensation packages',
          ),
          _buildBenefitCard(
            Icons.schedule,
            'Flexible Hours',
            'Work-life balance with flexible scheduling',
          ),
          _buildBenefitCard(
            Icons.home_work,
            'Remote Work',
            'Hybrid and remote work options available',
          ),
          _buildBenefitCard(
            Icons.school,
            'Learning & Development',
            'Professional development and training opportunities',
          ),
          _buildBenefitCard(
            Icons.favorite,
            'Health Insurance',
            'Comprehensive health coverage for employees',
          ),
          _buildBenefitCard(
            Icons.coffee,
            'Great Environment',
            'Modern office with collaborative workspace',
          ),
          
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
            role: 'Software Developer',
            rating: 5,
            date: '1 month ago',
            review: 'Great company to work with! Professional environment, supportive team, and excellent learning opportunities. The management truly cares about employee growth.',
          ),
          _buildReviewCard(
            name: 'Sarah Mansouri',
            role: 'UI/UX Designer',
            rating: 5,
            date: '2 months ago',
            review: 'Amazing workplace! The team is collaborative and the projects are challenging and rewarding. Work-life balance is respected.',
          ),
          _buildReviewCard(
            name: 'Karim Djellouli',
            role: 'Intern',
            rating: 4,
            date: '3 months ago',
            review: 'Had a wonderful internship experience. Learned a lot from experienced developers and got hands-on experience with real projects.',
          ),
          _buildReviewCard(
            name: 'Nadia Cherif',
            role: 'Project Manager',
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

  Widget _buildBenefitCard(IconData icon, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey4,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.electricLime.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.electricLime),
            ),
            child: Icon(
              icon,
              color: AppColors.electricLime,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.aclonica(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.aclonica(
                    fontSize: 12,
                    color: AppColors.grey6,
                  ),
                ),
              ],
            ),
          ),
        ],
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
