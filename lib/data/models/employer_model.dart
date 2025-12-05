/// Employer-specific data model
/// Matches database 'employer_profiles' table
class EmployerModel {
  final String userId;
  final String businessName;
  final String businessType;
  final String industry;
  final String? description;
  final String? location;
  final String? address;
  final String? logo;
  final String? websiteUrl;
  final String? verificationDocumentUrl; // Business license, tax ID, etc.
  final List<String>? socialMediaLinks;
  final double rating;
  final int reviewCount;
  final int activeJobs;
  final int totalJobsPosted;
  final int totalHires;
  final bool isVerified;
  final String? verificationBadge;
  final Map<String, dynamic>? contactInfo;

  EmployerModel({
    required this.userId,
    required this.businessName,
    required this.businessType,
    required this.industry,
    this.description,
    this.location,
    this.address,
    this.logo,
    this.websiteUrl,
    this.verificationDocumentUrl,
    this.socialMediaLinks,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.activeJobs = 0,
    this.totalJobsPosted = 0,
    this.totalHires = 0,
    this.isVerified = false,
    this.verificationBadge,
    this.contactInfo,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'businessName': businessName,
      'businessType': businessType,
      'industry': industry,
      'description': description,
      'location': location,
      'address': address,
      'logo': logo,
      'websiteUrl': websiteUrl,
      'verificationDocumentUrl': verificationDocumentUrl,
      'socialMediaLinks': socialMediaLinks,
      'rating': rating,
      'reviewCount': reviewCount,
      'activeJobs': activeJobs,
      'totalJobsPosted': totalJobsPosted,
      'totalHires': totalHires,
      'isVerified': isVerified,
      'verificationBadge': verificationBadge,
      'contactInfo': contactInfo,
    };
  }

  factory EmployerModel.fromJson(Map<String, dynamic> json) {
    return EmployerModel(
      userId: json['userId'],
      businessName: json['businessName'],
      businessType: json['businessType'],
      industry: json['industry'],
      description: json['description'],
      location: json['location'],
      address: json['address'],
      logo: json['logo'],
      websiteUrl: json['websiteUrl'],
      verificationDocumentUrl: json['verificationDocumentUrl'],
      socialMediaLinks: json['socialMediaLinks'] != null
          ? List<String>.from(json['socialMediaLinks'])
          : null,
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      activeJobs: json['activeJobs'] ?? 0,
      totalJobsPosted: json['totalJobsPosted'] ?? 0,
      totalHires: json['totalHires'] ?? 0,
      isVerified: json['isVerified'] ?? false,
      verificationBadge: json['verificationBadge'],
      contactInfo: json['contactInfo'] != null
          ? Map<String, dynamic>.from(json['contactInfo'])
          : null,
    );
  }
}
