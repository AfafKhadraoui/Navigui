import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../commons/themes/style_simple/colors.dart';

/// Student Public Profile Screen
/// Shows: Photo, name, university, major, bio, skills, field of study, 
/// rating, reviews, CV download
class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> with SingleTickerProviderStateMixin {
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Public Profile',
          style: GoogleFonts.aclonica(
            fontSize: 20,
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              
              // Profile Picture
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.purple6,
                    width: 3,
                  ),
                  color: AppColors.grey4,
                ),
                child: const Icon(
                  Icons.person,
                  size: 60,
                  color: AppColors.grey6,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Name
              Text(
                'Afaf Khadraoui',
                style: GoogleFonts.aclonica(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // University & Major
              Text(
                'Computer Science Student',
                style: GoogleFonts.aclonica(
                  fontSize: 16,
                  color: AppColors.purple6,
                ),
              ),
              
              const SizedBox(height: 4),
              
              Text(
                'University of Technology',
                style: GoogleFonts.aclonica(
                  fontSize: 14,
                  color: AppColors.grey6,
                ),
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
                    '4.0 (12 reviews)',
                    style: GoogleFonts.aclonica(
                      fontSize: 14,
                      color: AppColors.grey6,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // CV Download Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement CV download
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Downloading CV...',
                            style: GoogleFonts.aclonica(),
                          ),
                          backgroundColor: AppColors.purple6,
                        ),
                      );
                    },
                    icon: const Icon(Icons.download),
                    label: Text(
                      'Download CV',
                      style: GoogleFonts.aclonica(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.purple6,
                      foregroundColor: AppColors.white,
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
                    color: AppColors.purple6,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelColor: AppColors.white,
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
                    Tab(text: 'Skills'),
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
                    _buildSkillsTab(),
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
          _buildSectionTitle('Bio'),
          const SizedBox(height: 12),
          _buildInfoCard(
            'Passionate computer science student with a keen interest in mobile development and UI/UX design. Looking for opportunities to apply my skills in real-world projects and gain valuable experience.',
          ),
          
          const SizedBox(height: 24),
          
          _buildSectionTitle('Field of Study'),
          const SizedBox(height: 12),
          _buildInfoCard('Computer Science & Software Engineering'),
          
          const SizedBox(height: 24),
          
          _buildSectionTitle('Year of Study'),
          const SizedBox(height: 12),
          _buildInfoCard('Master 1'),
          
          const SizedBox(height: 24),
          
          _buildSectionTitle('Languages'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildChip('Arabic - Native'),
              _buildChip('English - Fluent'),
              _buildChip('French - Intermediate'),
            ],
          ),
          
          const SizedBox(height: 24),
          
          _buildSectionTitle('Contact Information'),
          const SizedBox(height: 12),
          _buildContactItem(Icons.email, 'afaf.khadraoui@example.com'),
          _buildContactItem(Icons.phone, '+213 XXX XXX XXX'),
          _buildContactItem(Icons.link, 'portfolio.example.com'),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSkillsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Technical Skills'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSkillChip('Flutter', 0.9),
              _buildSkillChip('Dart', 0.85),
              _buildSkillChip('Firebase', 0.75),
              _buildSkillChip('Python', 0.8),
              _buildSkillChip('Java', 0.7),
              _buildSkillChip('Git', 0.85),
              _buildSkillChip('REST APIs', 0.8),
              _buildSkillChip('SQL', 0.75),
            ],
          ),
          
          const SizedBox(height: 24),
          
          _buildSectionTitle('Soft Skills'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildChip('Team Collaboration'),
              _buildChip('Problem Solving'),
              _buildChip('Communication'),
              _buildChip('Time Management'),
              _buildChip('Creativity'),
            ],
          ),
          
          const SizedBox(height: 24),
          
          _buildSectionTitle('Projects Completed'),
          const SizedBox(height: 12),
          _buildProjectCard(
            'E-Commerce Mobile App',
            'Flutter application with payment integration',
            '5.0 ⭐',
          ),
          _buildProjectCard(
            'Task Management System',
            'Web-based project management tool',
            '4.5 ⭐',
          ),
          _buildProjectCard(
            'Weather Forecast App',
            'Real-time weather updates with API integration',
            '4.8 ⭐',
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
            name: 'Tech Solutions Inc.',
            rating: 5,
            date: '2 weeks ago',
            review: 'Excellent work! Afaf delivered the mobile app ahead of schedule with great attention to detail. Highly recommended for Flutter development projects.',
          ),
          _buildReviewCard(
            name: 'StartUp Hub',
            rating: 4,
            date: '1 month ago',
            review: 'Very professional and skilled developer. Good communication throughout the project. Would work with again.',
          ),
          _buildReviewCard(
            name: 'Digital Marketing Co.',
            rating: 5,
            date: '2 months ago',
            review: 'Amazing experience! The app exceeded our expectations. Great problem-solving skills and creativity.',
          ),
          _buildReviewCard(
            name: 'Innovation Labs',
            rating: 4,
            date: '3 months ago',
            review: 'Solid work on our project. Met all requirements and was responsive to feedback.',
          ),
          const SizedBox(height: 24),
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
        color: AppColors.purple6,
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
        color: AppColors.purple6.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.purple6),
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

  Widget _buildSkillChip(String label, double proficiency) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.grey4,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.purple6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.aclonica(
              fontSize: 14,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                width: 100,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey5,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: proficiency,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.purple6,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${(proficiency * 100).toInt()}%',
                style: GoogleFonts.aclonica(
                  fontSize: 10,
                  color: AppColors.grey6,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.purple6, size: 20),
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

  Widget _buildProjectCard(String title, String description, String rating) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
                child: Text(
                  title,
                  style: GoogleFonts.aclonica(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ),
              Text(
                rating,
                style: GoogleFonts.aclonica(
                  fontSize: 14,
                  color: AppColors.yellow5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: GoogleFonts.aclonica(
              fontSize: 12,
              color: AppColors.grey6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard({
    required String name,
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
                child: Text(
                  name,
                  style: GoogleFonts.aclonica(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
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
