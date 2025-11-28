// lib/models/application.dart
/// Application Model
/// Represents a student's application to a job post
class Application {
  final String id;
  final String jobId;
  final String studentName;
  final String jobTitle;
  final DateTime appliedDate;
  final ApplicationStatus status;
  final String email;
  final String phone;
  final String experience;
  final String coverLetter;
  final List<String> skills;
  final String avatar;
  
  // Additional fields from detailed structure
  final String? university;
  final String? major;
  final bool cvAttached;
  final String? cvUrl;

  Application({
    required this.id,
    required this.jobId,
    required this.studentName,
    required this.jobTitle,
    required this.appliedDate,
    required this.status,
    required this.email,
    required this.phone,
    required this.experience,
    required this.coverLetter,
    required this.skills,
    required this.avatar,
    this.university,
    this.major,
    this.cvAttached = false,
    this.cvUrl,
  });

  Application copyWith({
    String? id,
    String? jobId,
    String? studentName,
    String? jobTitle,
    DateTime? appliedDate,
    ApplicationStatus? status,
    String? email,
    String? phone,
    String? experience,
    String? coverLetter,
    List<String>? skills,
    String? avatar,
    String? university,
    String? major,
    bool? cvAttached,
    String? cvUrl,
  }) {
    return Application(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      studentName: studentName ?? this.studentName,
      jobTitle: jobTitle ?? this.jobTitle,
      appliedDate: appliedDate ?? this.appliedDate,
      status: status ?? this.status,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      experience: experience ?? this.experience,
      coverLetter: coverLetter ?? this.coverLetter,
      skills: skills ?? this.skills,
      avatar: avatar ?? this.avatar,
      university: university ?? this.university,
      major: major ?? this.major,
      cvAttached: cvAttached ?? this.cvAttached,
      cvUrl: cvUrl ?? this.cvUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jobId': jobId,
      'studentName': studentName,
      'jobTitle': jobTitle,
      'appliedDate': appliedDate.toIso8601String(),
      'status': status.name,
      'email': email,
      'phone': phone,
      'experience': experience,
      'coverLetter': coverLetter,
      'skills': skills,
      'avatar': avatar,
      'university': university,
      'major': major,
      'cvAttached': cvAttached,
      'cvUrl': cvUrl,
    };
  }

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      id: json['id'],
      jobId: json['jobId'],
      studentName: json['studentName'],
      jobTitle: json['jobTitle'],
      appliedDate: DateTime.parse(json['appliedDate']),
      status: ApplicationStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ApplicationStatus.pending,
      ),
      email: json['email'],
      phone: json['phone'],
      experience: json['experience'],
      coverLetter: json['coverLetter'],
      skills: (json['skills'] as List).cast<String>(),
      avatar: json['avatar'],
      university: json['university'],
      major: json['major'],
      cvAttached: json['cvAttached'] ?? false,
      cvUrl: json['cvUrl'],
    );
  }
}

enum ApplicationStatus {
  pending('Pending'),
  accepted('Accepted'),
  rejected('Rejected');

  final String label;
  const ApplicationStatus(this.label);
}
