import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../commons/themes/style_simple/colors.dart';

/// Public Student Profile Screen (View Any Student)
/// Shows: Photo, name, university, major, bio, skills, field of study, 
/// rating, reviews, CV download
class PublicStudentProfileScreen extends StatefulWidget {
  final String studentId;
  final String? studentName;

  const PublicStudentProfileScreen({
    super.key,
    required this.studentId,
    this.studentName,
  });

  @override
  State<PublicStudentProfileScreen> createState() => _PublicStudentProfileScreenState();
}

class _PublicStudentProfileScreenState extends State<PublicStudentProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;

  // Mock data - replace with API call
  final Map<String, dynamic> _studentData = {
    'name': 'Afaf Khadraoui',
    'university': 'University of Science and Technology',
    'major': 'Computer Science',
    'bio': 'Passionate computer science student with a keen interest in mobile development and UI/UX design. Looking for opportunities to apply my skills in real-world projects and gain valuable experience.',
    'fieldOfStudy': 'Computer Science & Software Engineering',
    'year': 'Master 1',
    'rating': 4.5,
    'reviewCount': 15,
    'profilePicture': null,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadStudentData();
  }

  Future<void> _loadStudentData() async {
    // TODO: Load from API using widget.studentId
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
          'Student Profile',
          style: GoogleFonts.aclonica(
            fontSize: 20,
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.purple6))
          : SafeArea(
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
                      _studentData['name'],
                      style: GoogleFonts.aclonica(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Major
                    Text(
                      '${_studentData['major']} Student',
                      style: GoogleFonts.aclonica(
                        fontSize: 16,
                        color: AppColors.purple6,
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // University
                    Text(
                      _studentData['university'],
                      style: GoogleFonts.aclonica(
                        fontSize: 14,
                        color: AppColors.grey6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < (_studentData['rating'] as double).floor() ? Icons.star : Icons.star_border,
                            color: AppColors.yellow5,
                            size: 20,
                          );
                        }),
                        const SizedBox(width: 8),
                        Text(
                          '${_studentData['rating']} (${_studentData['reviewCount']} reviews)',
                          style: GoogleFonts.aclonica(
                            fontSize: 14,
                            color: AppColors.grey6,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Action Buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  // TODO: Implement messaging
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Messaging feature coming soon',
                                        style: GoogleFonts.aclonica(),
                                      ),
                                      backgroundColor: AppColors.purple6,
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.message, size: 18),
                                label: Text(
                                  'Message',
                                  style: GoogleFonts.aclonica(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.purple6,
                                  side: const BorderSide(color: AppColors.purple6, width: 2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 48,
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
                                icon: const Icon(Icons.download, size: 18),
                                label: Text(
                                  'CV',
                                  style: GoogleFonts.aclonica(
                                    fontSize: 14,
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
                        ],
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
          _buildInfoCard(_studentData['bio']),
          
          const SizedBox(height: 24),
          
          _buildSectionTitle('Field of Study'),
          const SizedBox(height: 12),
          _buildInfoCard(_studentData['fieldOfStudy']),
          
          const SizedBox(height: 24),
          
          _buildSectionTitle('Year of Study'),
          const SizedBox(height: 12),
          _buildInfoCard(_studentData['year']),
          
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
            review: 'Excellent work! Delivered the project ahead of schedule with great attention to detail. Highly recommended for development projects.',
          ),
          _buildReviewCard(
            name: 'StartUp Hub',
            rating: 4,
            date: '1 month ago',
            review: 'Very professional and skilled. Good communication throughout the project. Would work with again.',
          ),
          _buildReviewCard(
            name: 'Digital Marketing Co.',
            rating: 5,
            date: '2 months ago',
            review: 'Amazing experience! The work exceeded our expectations. Great problem-solving skills and creativity.',
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
