import 'dart:convert';

/// Application Model
/// Represents a student's application to a job post
class Application {
  final String id;
  final String jobId;
  final String studentId;
  final String studentName;
  final DateTime appliedDate;
  final DateTime? respondedDate;
  final ApplicationStatus status;
  final String email;
  final String phone;
  final String experience;
  final String coverLetter;
  final List<String> skills;
  final String avatar;
  final bool isWithdrawn;
  final String university;
  final String major;
  final bool cvAttached;
  final String? cvUrl;

  Application({
    required this.id,
    required this.jobId,
    required this.studentId,
    required this.studentName,
    required this.appliedDate,
    this.respondedDate,
    required this.status,
    required this.email,
    required this.phone,
    required this.experience,
    required this.coverLetter,
    required this.skills,
    required this.avatar,
    required this.university,
    required this.major,
    this.cvAttached = false,
    this.cvUrl,
    this.isWithdrawn = false,
  });

  Application copyWith({
    String? id,
    String? jobId,
    String? studentId,
    String? studentName,
    DateTime? appliedDate,
    DateTime? respondedDate,
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
    bool? isWithdrawn,
  }) {
    return Application(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      appliedDate: appliedDate ?? this.appliedDate,
      respondedDate: respondedDate ?? this.respondedDate,
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
      isWithdrawn: isWithdrawn ?? this.isWithdrawn,
    );
  }

  /// Convert to map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'job_id': jobId,
      'student_id': studentId,
      'student_name': studentName,
      'applied_date': appliedDate.toIso8601String(),
      'responded_date': respondedDate?.toIso8601String(),
      'status': status.dbValue,
      'email': email,
      'phone': phone,
      'experience': experience,
      'cover_letter': coverLetter,
      'skills': jsonEncode(skills),
      'avatar': avatar,
      'university': university,
      'major': major,
      'cv_attached': cvAttached ? 1 : 0,
      'cv_url': cvUrl,
      'is_withdrawn': isWithdrawn ? 1 : 0,
    };
  }

  /// Create from database map
  factory Application.fromMap(Map<String, dynamic> map) {
    return Application(
      id: map['id'] as String,
      jobId: map['job_id'] as String,
      studentId: map['student_id'] as String,
      studentName: map['student_name'] as String,
      appliedDate: DateTime.parse(map['applied_date'] as String),
      respondedDate: map['responded_date'] != null 
          ? DateTime.parse(map['responded_date'] as String)
          : null,
      status: ApplicationStatus.fromDb(map['status'] as String),
      email: map['email'] as String,
      phone: map['phone'] as String,
      experience: map['experience'] as String,
      coverLetter: map['cover_letter'] as String,
      skills: List<String>.from(jsonDecode(map['skills'] as String? ?? '[]')),
      avatar: map['avatar'] as String,
      university: map['university'] as String,
      major: map['major'] as String,
      cvAttached: (map['cv_attached'] as int?) == 1,
      cvUrl: map['cv_url'] as String?,
      isWithdrawn: (map['is_withdrawn'] as int?) == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jobId': jobId,
      'studentId': studentId,
      'studentName': studentName,
      'appliedDate': appliedDate.toIso8601String(),
      'respondedDate': respondedDate?.toIso8601String(),
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
      'isWithdrawn': isWithdrawn,
    };
  }

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      id: json['id'] as String,
      jobId: json['jobId'] as String,
      studentId: json['studentId'] as String,
      studentName: json['studentName'] as String,
      appliedDate: DateTime.parse(json['appliedDate'] as String),
      respondedDate: json['respondedDate'] != null
          ? DateTime.parse(json['respondedDate'] as String)
          : null,
      status: ApplicationStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ApplicationStatus.pending,
      ),
      email: json['email'] as String,
      phone: json['phone'] as String,
      experience: json['experience'] as String,
      coverLetter: json['coverLetter'] as String,
      skills: List<String>.from(json['skills'] as List? ?? []),
      avatar: json['avatar'] as String,
      university: json['university'] as String,
      major: json['major'] as String,
      cvAttached: json['cvAttached'] as bool? ?? false,
      cvUrl: json['cvUrl'] as String?,
      isWithdrawn: json['isWithdrawn'] as bool? ?? false,
    );
  }
}

enum ApplicationStatus {
  pending('Pending', 'pending'),
  accepted('Accepted', 'accepted'),
  rejected('Rejected', 'rejected');

  final String label;
  final String dbValue;

  const ApplicationStatus(this.label, this.dbValue);

  static ApplicationStatus fromDb(String dbValue) {
    return ApplicationStatus.values.firstWhere(
      (e) => e.dbValue == dbValue,
      orElse: () => ApplicationStatus.pending,
    );
  }
}
