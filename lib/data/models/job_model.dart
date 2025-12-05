/// Job data model
class JobModel {
  final String id;
  final String employerId;
  final String title;
  final String description;
  final String? briefDescription;
  final String category;
  final String jobType; // 'part_time' or 'task'
  final String? requirements;
  final double pay;
  final String
  paymentType; // 'hourly', 'daily', 'weekly', 'monthly', 'per_task'
  final String?
  timeCommitment; // 'full_day', 'half_day', 'few_hours', 'flexible'
  final String? duration; // 'one_time', '1_week', '1_month', 'ongoing'
  final DateTime? startDate;
  final bool isRecurring;
  final int numberOfPositions;
  final String? location;
  final List<String>? photos;
  final List<String>? tags;
  final String? contactPreference; // 'phone', 'email', 'whatsapp', 'in_app'
  final DateTime? deadline;
  final bool isUrgent;
  final bool requiresCV;
  final bool isDraft;
  final List<String>? languagesRequired;
  final String status; // 'active', 'filled', 'closed', 'draft'
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int applicantsCount;

  JobModel({
    required this.id,
    required this.employerId,
    required this.title,
    required this.description,
    this.briefDescription,
    required this.category,
    required this.jobType,
    this.requirements,
    required this.pay,
    required this.paymentType,
    this.timeCommitment,
    this.duration,
    this.startDate,
    this.isRecurring = false,
    this.numberOfPositions = 1,
    this.location,
    this.photos,
    this.tags,
    this.contactPreference,
    this.deadline,
    this.isUrgent = false,
    this.requiresCV = false,
    this.isDraft = false,
    this.languagesRequired,
    this.status = 'active',
    required this.createdAt,
    this.updatedAt,
    this.applicantsCount = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employerId': employerId,
      'title': title,
      'description': description,
      'briefDescription': briefDescription,
      'category': category,
      'jobType': jobType,
      'requirements': requirements,
      'pay': pay,
      'paymentType': paymentType,
      'timeCommitment': timeCommitment,
      'duration': duration,
      'startDate': startDate?.toIso8601String(),
      'isRecurring': isRecurring,
      'numberOfPositions': numberOfPositions,
      'location': location,
      'photos': photos,
      'tags': tags,
      'contactPreference': contactPreference,
      'deadline': deadline?.toIso8601String(),
      'isUrgent': isUrgent,
      'requiresCV': requiresCV,
      'isDraft': isDraft,
      'languagesRequired': languagesRequired,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'applicantsCount': applicantsCount,
    };
  }

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'],
      employerId: json['employerId'],
      title: json['title'],
      description: json['description'],
      briefDescription: json['briefDescription'],
      category: json['category'],
      jobType: json['jobType'],
      requirements: json['requirements'],
      pay: (json['pay'] ?? 0.0).toDouble(),
      paymentType: json['paymentType'],
      timeCommitment: json['timeCommitment'],
      duration: json['duration'],
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      isRecurring: json['isRecurring'] ?? false,
      numberOfPositions: json['numberOfPositions'] ?? 1,
      location: json['location'],
      photos: json['photos'] != null ? List<String>.from(json['photos']) : null,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      contactPreference: json['contactPreference'],
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'])
          : null,
      isUrgent: json['isUrgent'] ?? false,
      requiresCV: json['requiresCV'] ?? false,
      isDraft: json['isDraft'] ?? false,
      languagesRequired: json['languagesRequired'] != null
          ? List<String>.from(json['languagesRequired'])
          : null,
      status: json['status'] ?? 'active',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      applicantsCount: json['applicantsCount'] ?? 0,
    );
  }
}
