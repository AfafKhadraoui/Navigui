/// Job Post Model
/// Represents an employer's job posting with all details
class JobPost {
  final String id;
  final String title;
  final String company;
  final String location;
  final String description;
  final String salary;
  final bool saved;
  final int applications;
  
  // Job classification
  final JobType jobType;
  final List<JobCategory>? categories;
  
  // Requirements
  final JobRequirements? requirements;
  
  // Time commitment
  final TimeCommitment? timeCommitment;
  
  // Payment details
  final PaymentInfo? payment;
  
  // Additional fields
  final bool isRecurring;
  final bool isUrgent;
  final int numberOfPositions;
  final JobStatus status;
  final DateTime createdDate;
  final DateTime? applicationDeadline;
  final List<String>? photos;

  JobPost({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.description,
    required this.salary,
    this.saved = false,
    this.applications = 0,
    required this.jobType,
    this.categories,
    this.requirements,
    this.timeCommitment,
    this.payment,
    this.isRecurring = false,
    this.isUrgent = false,
    this.numberOfPositions = 1,
    this.status = JobStatus.active,
    required this.createdDate,
    this.applicationDeadline,
    this.photos,
  });

  JobPost copyWith({
    String? id,
    String? title,
    String? company,
    String? location,
    String? description,
    String? salary,
    bool? saved,
    int? applications,
    JobType? jobType,
    List<JobCategory>? categories,
    JobRequirements? requirements,
    TimeCommitment? timeCommitment,
    PaymentInfo? payment,
    bool? isRecurring,
    bool? isUrgent,
    int? numberOfPositions,
    JobStatus? status,
    DateTime? createdDate,
    DateTime? applicationDeadline,
    List<String>? photos,
  }) {
    return JobPost(
      id: id ?? this.id,
      title: title ?? this.title,
      company: company ?? this.company,
      location: location ?? this.location,
      description: description ?? this.description,
      salary: salary ?? this.salary,
      saved: saved ?? this.saved,
      applications: applications ?? this.applications,
      jobType: jobType ?? this.jobType,
      categories: categories ?? this.categories,
      requirements: requirements ?? this.requirements,
      timeCommitment: timeCommitment ?? this.timeCommitment,
      payment: payment ?? this.payment,
      isRecurring: isRecurring ?? this.isRecurring,
      isUrgent: isUrgent ?? this.isUrgent,
      numberOfPositions: numberOfPositions ?? this.numberOfPositions,
      status: status ?? this.status,
      createdDate: createdDate ?? this.createdDate,
      applicationDeadline: applicationDeadline ?? this.applicationDeadline,
      photos: photos ?? this.photos,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'location': location,
      'description': description,
      'salary': salary,
      'saved': saved,
      'applications': applications,
      'jobType': jobType.name,
      'categories': categories?.map((c) => c.name).toList(),
      'requirements': requirements?.toJson(),
      'timeCommitment': timeCommitment?.toJson(),
      'payment': payment?.toJson(),
      'isRecurring': isRecurring,
      'isUrgent': isUrgent,
      'numberOfPositions': numberOfPositions,
      'status': status.name,
      'createdDate': createdDate.toIso8601String(),
      'applicationDeadline': applicationDeadline?.toIso8601String(),
      'photos': photos,
    };
  }

  factory JobPost.fromJson(Map<String, dynamic> json) {
    return JobPost(
      id: json['id'],
      title: json['title'],
      company: json['company'],
      location: json['location'],
      description: json['description'],
      salary: json['salary'],
      saved: json['saved'] ?? false,
      applications: json['applications'] ?? 0,
      jobType: JobType.values.firstWhere(
        (e) => e.name == json['jobType'],
        orElse: () => JobType.partTime,
      ),
      categories: (json['categories'] as List?)
          ?.map((c) => JobCategory.values.firstWhere(
                (e) => e.name == c,
                orElse: () => JobCategory.other,
              ))
          .toList(),
      requirements: json['requirements'] != null
          ? JobRequirements.fromJson(json['requirements'])
          : null,
      timeCommitment: json['timeCommitment'] != null
          ? TimeCommitment.fromJson(json['timeCommitment'])
          : null,
      payment: json['payment'] != null
          ? PaymentInfo.fromJson(json['payment'])
          : null,
      isRecurring: json['isRecurring'] ?? false,
      isUrgent: json['isUrgent'] ?? false,
      numberOfPositions: json['numberOfPositions'] ?? 1,
      status: JobStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => JobStatus.active,
      ),
      createdDate: DateTime.parse(json['createdDate']),
      applicationDeadline: json['applicationDeadline'] != null
          ? DateTime.parse(json['applicationDeadline'])
          : null,
      photos: (json['photos'] as List?)?.cast<String>(),
    );
  }
}

// Enums
enum JobType {
  partTime('Part-Time Job'),
  quickTask('Quick Task');

  final String label;
  const JobType(this.label);
}

enum JobCategory {
  photography('Photography'),
  translation('Translation'),
  graphicDesign('Graphic Design'),
  tutoring('Tutoring'),
  delivery('Delivery'),
  writing('Writing'),
  marketing('Marketing'),
  techSupport('Tech Support'),
  eventHelp('Event Help'),
  socialMedia('Social Media'),
  dataEntry('Data Entry'),
  videoEditing('Video Editing'),
  webDevelopment('Web Development'),
  customerService('Customer Service'),
  other('Other');

  final String label;
  const JobCategory(this.label);
}

enum JobStatus {
  active('Active'),
  filled('Filled'),
  closed('Closed'),
  draft('Draft');

  final String label;
  const JobStatus(this.label);
}

enum PaymentType {
  hourly('Hourly'),
  daily('Daily'),
  weekly('Weekly'),
  monthly('Monthly'),
  perTask('Per Task'),
  fixed('Fixed');

  final String label;
  const PaymentType(this.label);
}

// Supporting classes
class JobRequirements {
  final List<String> languages;
  final bool cvRequired;

  JobRequirements({
    required this.languages,
    this.cvRequired = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'languages': languages,
      'cvRequired': cvRequired,
    };
  }

  factory JobRequirements.fromJson(Map<String, dynamic> json) {
    return JobRequirements(
      languages: (json['languages'] as List).cast<String>(),
      cvRequired: json['cvRequired'] ?? false,
    );
  }
}

class TimeCommitment {
  final int? hoursPerWeek;
  final List<String>? daysNeeded;
  final DateTime? specificDate;
  final String? specificTime;

  TimeCommitment({
    this.hoursPerWeek,
    this.daysNeeded,
    this.specificDate,
    this.specificTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'hoursPerWeek': hoursPerWeek,
      'daysNeeded': daysNeeded,
      'specificDate': specificDate?.toIso8601String(),
      'specificTime': specificTime,
    };
  }

  factory TimeCommitment.fromJson(Map<String, dynamic> json) {
    return TimeCommitment(
      hoursPerWeek: json['hoursPerWeek'],
      daysNeeded: (json['daysNeeded'] as List?)?.cast<String>(),
      specificDate: json['specificDate'] != null
          ? DateTime.parse(json['specificDate'])
          : null,
      specificTime: json['specificTime'],
    );
  }
}

class PaymentInfo {
  final double amount;
  final PaymentType type;

  PaymentInfo({
    required this.amount,
    required this.type,
  });

  String get formattedAmount {
    switch (type) {
      case PaymentType.hourly:
        return '${amount.toStringAsFixed(0)} DZD/hour';
      case PaymentType.daily:
        return '${amount.toStringAsFixed(0)} DZD/day';
      case PaymentType.weekly:
        return '${amount.toStringAsFixed(0)} DZD/week';
      case PaymentType.monthly:
        return '${amount.toStringAsFixed(0)} DZD/month';
      case PaymentType.perTask:
        return '${amount.toStringAsFixed(0)} DZD/task';
      case PaymentType.fixed:
        return '${amount.toStringAsFixed(0)} DZD';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'type': type.name,
    };
  }

  factory PaymentInfo.fromJson(Map<String, dynamic> json) {
    return PaymentInfo(
      amount: json['amount'].toDouble(),
      type: PaymentType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => PaymentType.fixed,
      ),
    );
  }
}
