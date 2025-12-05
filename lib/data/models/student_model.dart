/// Student-specific data model
/// Matches database 'student_profiles' table
class StudentModel {
  final String userId;
  final String university;
  final String faculty;
  final String major;
  final String yearOfStudy; // "1st year", "2nd year", etc.
  final String? bio;
  final String? cvUrl; // Resume/CV file URL
  final List<String> skills;
  final List<String> languages;
  final String? availability; // "weekdays", "weekends", "evenings", "flexible"
  final String?
      transportation; // "car", "motorcycle", "public transport", "none"
  final String? previousExperience;
  final String? websiteUrl;
  final List<String>? socialMediaLinks;
  final List<String>? portfolio;
  final bool isPhonePublic;
  final String profileVisibility; // "everyone", "employers_only"
  final double rating;
  final int reviewCount;
  final int jobsCompleted;

  StudentModel({
    required this.userId,
    required this.university,
    required this.faculty,
    required this.major,
    required this.yearOfStudy,
    this.bio,
    this.cvUrl,
    this.skills = const [],
    this.languages = const [],
    this.availability,
    this.transportation,
    this.previousExperience,
    this.websiteUrl,
    this.socialMediaLinks,
    this.portfolio,
    this.isPhonePublic = true,
    this.profileVisibility = 'everyone',
    this.rating = 0.0,
    this.reviewCount = 0,
    this.jobsCompleted = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'university': university,
      'faculty': faculty,
      'major': major,
      'yearOfStudy': yearOfStudy,
      'bio': bio,
      'cvUrl': cvUrl,
      'skills': skills,
      'languages': languages,
      'availability': availability,
      'transportation': transportation,
      'previousExperience': previousExperience,
      'websiteUrl': websiteUrl,
      'socialMediaLinks': socialMediaLinks,
      'portfolio': portfolio,
      'isPhonePublic': isPhonePublic,
      'profileVisibility': profileVisibility,
      'rating': rating,
      'reviewCount': reviewCount,
      'jobsCompleted': jobsCompleted,
    };
  }

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      userId: json['userId'],
      university: json['university'],
      faculty: json['faculty'],
      major: json['major'],
      yearOfStudy: json['yearOfStudy'],
      bio: json['bio'],
      cvUrl: json['cvUrl'],
      skills: List<String>.from(json['skills'] ?? []),
      languages: List<String>.from(json['languages'] ?? []),
      availability: json['availability'],
      transportation: json['transportation'],
      previousExperience: json['previousExperience'],
      websiteUrl: json['websiteUrl'],
      socialMediaLinks: json['socialMediaLinks'] != null
          ? List<String>.from(json['socialMediaLinks'])
          : null,
      portfolio: json['portfolio'] != null
          ? List<String>.from(json['portfolio'])
          : null,
      isPhonePublic: json['isPhonePublic'] ?? true,
      profileVisibility: json['profileVisibility'] ?? 'everyone',
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      jobsCompleted: json['jobsCompleted'] ?? 0,
    );
  }
}
