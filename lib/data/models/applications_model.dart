
enum ApplicationStatus {
  pending('Pending'),
  accepted('Accepted'),
  rejected('Rejected'),
  withdrawn('Withdrawn');

  final String label;
  const ApplicationStatus(this.label);
}

class Application {
  final String id;
  final String jobId;
  final String jobTitle;
  final String userId;
  final String coverLetter;
  final String? resumeUrl;
  final Map<String, dynamic>? additionalInfo;
  final ApplicationStatus status;
  final DateTime appliedDate;
  final DateTime? reviewedDate;
  final String? employerFeedback;
  final String employerId;
  
  // Added fields for mock data / UI
  final String studentName; 
  final String? email;
  final String? phone;
  final String? experience;
  final List<String>? skills;
  final String? avatar;
  final String? university;
  final String? major;

  Application({
    required this.id,
    required this.jobId,
    required this.jobTitle,
    required this.userId,
    required this.coverLetter,
    this.resumeUrl,
    this.additionalInfo,
    required this.status,
    required this.appliedDate,
    this.reviewedDate,
    this.employerFeedback,
    required this.employerId,
    // Defaults for new fields
    this.studentName = 'Unknown Student',
    this.email,
    this.phone,
    this.experience,
    this.skills,
    this.avatar,
    this.university,
    this.major,
  });

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      id: json['id'] ?? '',
      jobId: json['jobId'] ?? '',
      jobTitle: json['jobTitle'] ?? '',
      userId: json['userId'] ?? '',
      coverLetter: json['coverLetter'] ?? '',
      resumeUrl: json['resumeUrl'],
      additionalInfo: json['additionalInfo'] is Map
          ? Map<String, dynamic>.from(json['additionalInfo'])
          : null,
      status: ApplicationStatus.values.firstWhere(
        (e) => e.name == (json['status'] ?? 'pending'),
        orElse: () => ApplicationStatus.pending,
      ),
      appliedDate: json['appliedDate'] != null
          ? DateTime.parse(json['appliedDate'])
          : DateTime.now(),
      reviewedDate: json['reviewedDate'] != null
          ? DateTime.parse(json['reviewedDate'])
          : null,
      employerFeedback: json['employerFeedback'],
      employerId: json['employerId'] ?? '',
      studentName: json['studentName'] ?? 'Unknown Student',
      email: json['email'],
      phone: json['phone'],
      experience: json['experience'],
      skills: (json['skills'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      avatar: json['avatar'],
      university: json['university'],
      major: json['major'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jobId': jobId,
      'jobTitle': jobTitle,
      'userId': userId,
      'coverLetter': coverLetter,
      'resumeUrl': resumeUrl,
      'additionalInfo': additionalInfo,
      'status': status.name,
      'appliedDate': appliedDate.toIso8601String(),
      'reviewedDate': reviewedDate?.toIso8601String(),
      'employerFeedback': employerFeedback,
      'employerId': employerId,
      'studentName': studentName,
      'email': email,
      'phone': phone,
      'experience': experience,
      'skills': skills,
      'avatar': avatar,
      'university': university,
      'major': major,
    };
  }

  // Compatibility getter
  String get studentId => userId;

  Application copyWith({
    String? id,
    String? jobId,
    String? jobTitle,
    String? userId,
    String? coverLetter,
    String? resumeUrl,
    Map<String, dynamic>? additionalInfo,
    ApplicationStatus? status,
    DateTime? appliedDate,
    DateTime? reviewedDate,
    String? employerFeedback,
    String? employerId,
    String? studentName,
    String? email,
    String? phone,
    String? experience,
    List<String>? skills,
    String? avatar,
    String? university,
    String? major,
  }) {
    return Application(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      jobTitle: jobTitle ?? this.jobTitle,
      userId: userId ?? this.userId,
      coverLetter: coverLetter ?? this.coverLetter,
      resumeUrl: resumeUrl ?? this.resumeUrl,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      status: status ?? this.status,
      appliedDate: appliedDate ?? this.appliedDate,
      reviewedDate: reviewedDate ?? this.reviewedDate,
      employerFeedback: employerFeedback ?? this.employerFeedback,
      employerId: employerId ?? this.employerId,
      studentName: studentName ?? this.studentName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      experience: experience ?? this.experience,
      skills: skills ?? this.skills,
      avatar: avatar ?? this.avatar,
      university: university ?? this.university,
      major: major ?? this.major,
    );
  }
}