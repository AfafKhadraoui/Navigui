import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../commons/themes/style_simple/colors.dart';
import '../../../logic/cubits/student_profile/student_profile_cubit.dart';
import '../../../logic/cubits/student_profile/student_profile_state.dart';
import '../../../core/dependency_injection.dart';

/// Public Student Profile Screen (View Any Student)
/// Shows: Photo, name, university, major, bio, skills, field of study, 
/// rating, reviews, CV download
class PublicStudentProfileScreen extends StatelessWidget {
  final String studentId;
  final String? studentName;

  const PublicStudentProfileScreen({
    super.key,
    required this.studentId,
    this.studentName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = getIt<StudentProfileCubit>();
        cubit.loadProfile(studentId);
        return cubit;
      },
      child: _PublicStudentProfileView(studentName: studentName),
    );
  }
}

class _PublicStudentProfileView extends StatefulWidget {
  final String? studentName;

  const _PublicStudentProfileView({this.studentName});

  @override
  State<_PublicStudentProfileView> createState() => _PublicStudentProfileViewState();
}

class _PublicStudentProfileViewState extends State<_PublicStudentProfileView> with SingleTickerProviderStateMixin {
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
          widget.studentName ?? 'Student Profile',
          style: GoogleFonts.aclonica(
            fontSize: 20,
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<StudentProfileCubit, StudentProfileState>(
        builder: (context, state) {
          if (state is StudentProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.purple6),
            );
          }

          if (state is StudentProfileError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: AppColors.red1, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: GoogleFonts.inter(color: AppColors.white),
                  ),
                ],
              ),
            );
          }

          if (state is! StudentProfileLoaded) {
            return const SizedBox.shrink();
          }

          final profile = state.profile;

          return SafeArea(
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
                      widget.studentName ?? 'Student',
                      style: GoogleFonts.aclonica(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Major
                    Text(
                      '${profile.major} Student',
                      style: GoogleFonts.aclonica(
                        fontSize: 16,
                        color: AppColors.purple6,
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // University
                    Text(
                      profile.university,
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
                            index < profile.rating.floor() ? Icons.star : Icons.star_border,
                            color: AppColors.yellow5,
                            size: 20,
                          );
                        }),
                        const SizedBox(width: 8),
                        Text(
                          '${profile.rating.toStringAsFixed(1)} (${profile.reviewCount} reviews)',
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
                          _buildAboutTab(profile),
                          _buildSkillsTab(profile),
                          _buildReviewsTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
        },
      ),
    );
  }

  Widget _buildAboutTab(profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Bio'),
          const SizedBox(height: 12),
          _buildInfoCard(profile.bio ?? 'No bio provided'),
          
          const SizedBox(height: 24),
          
          _buildSectionTitle('Field of Study'),
          const SizedBox(height: 12),
          _buildInfoCard('${profile.faculty} - ${profile.major}'),
          
          const SizedBox(height: 24),
          
          _buildSectionTitle('Year of Study'),
          const SizedBox(height: 12),
          _buildInfoCard(profile.yearOfStudy),
          
          const SizedBox(height: 24),
          
          _buildSectionTitle('Languages'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: profile.languages.isNotEmpty
                ? profile.languages.map((lang) => _buildChip(lang)).toList()
                : [_buildChip('Not specified')],
          ),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSkillsTab(profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Skills'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: profile.skills.isNotEmpty
                ? profile.skills.map((skill) => _buildChip(skill)).toList()
                : [_buildChip('No skills added yet')],
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
