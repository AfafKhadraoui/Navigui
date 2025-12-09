

class JobPost {
  // Core identification
  final String id; // VARCHAR(36) PRIMARY KEY
  final String employerId; // VARCHAR(36) NOT NULL FK -> employer_profiles

  // Basic info
  final String title;
  final String description; // TEXT NOT NULL
  final String? briefDescription; // VARCHAR(500) NULL - for home page cards

  // Category & Type - CRITICAL: category is String, not enum!
  final String category; // ENUM stored as TEXT - flexible categories
  final JobType jobType; // ENUM('part_time', 'task') - only 2 values, enum OK

  // Requirements - ADDED: was missing from original model
  final String? requirements; // TEXT NULL - freeform requirements text

  // Payment
  final double pay; // DECIMAL(10,2) NOT NULL - numeric payment amount
  final PaymentType?
      paymentType; // ENUM NULL - hourly/daily/weekly/monthly/per_task

  // Time & Duration
  final String? timeCommitment; 
  final String? duration; 
  final DateTime? startDate; // TIMESTAMP NULL

  // Location & Contact
  final String? location; // VARCHAR(255) NULL
  final ContactPreference?
      contactPreference; // ENUM NULL - phone/email/whatsapp

  // Flags & Counts
  final bool isRecurring; 
  final bool isUrgent; 
  final bool requiresCv; // BOOLEAN DEFAULT FALSE
  final bool isDraft; // BOOLEAN DEFAULT FALSE
  final int numberOfPositions;
  final int applicantsCount;
  final int viewsCount;
  final int savesCount; 

  // Status & Timestamps
  final JobStatus status;
  final DateTime? applicationDeadline; // TIMESTAMP NULL (deadline in DB)
  final DateTime createdDate; 
  final DateTime? updatedAt; // TIMESTAMP NULL
  final DateTime? deletedAt; 
  // From JOIN tables (not direct columns)
  final List<String> photos; // Loaded from job_photos table
  final List<String> languages; // Loaded from job_required_languages table

  JobPost({
    required this.id,
    required this.employerId,
    required this.title,
    required this.description,
    this.briefDescription,
    required this.category, // String, not enum!
    required this.jobType,
    this.requirements,
    required this.pay,
    this.paymentType,
    this.timeCommitment,
    this.duration,
    this.startDate,
    this.location,
    this.contactPreference,
    this.isRecurring = false,
    this.isUrgent = false,
    this.requiresCv = false,
    this.isDraft = false,
    this.numberOfPositions = 1,
    this.applicantsCount = 0,
    this.viewsCount = 0,
    this.savesCount = 0,
    this.status = JobStatus.active,
    this.applicationDeadline,
    required this.createdDate,
    this.updatedAt,
    this.deletedAt,
    this.photos = const [],
    this.languages = const [],
  });

  // Helper getters for UI display
  String get postedTime {
    final now = DateTime.now();
    final difference = now.difference(createdDate);
    
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return 'Just now';
      }
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inDays == 1) {
      return '1 day ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    }
  }

  String get deadlineText {
    if (applicationDeadline == null) return 'No deadline';
    
    final now = DateTime.now();
    final difference = applicationDeadline!.difference(now);
    
    if (difference.isNegative) return 'Expired';
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return '1 day left';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days left';
    } else {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} left';
    }
  }

  String get salaryText {
    if (paymentType == null) {
      return '${pay.toInt()} DA';
    }
    
    switch (paymentType!) {
      case PaymentType.hourly:
        return '${pay.toInt()} DA/hr';
      case PaymentType.daily:
        return '${pay.toInt()} DA/day';
      case PaymentType.weekly:
        return '${pay.toInt()} DA/wk';
      case PaymentType.monthly:
        return '${pay.toInt()} DA/mo';
      case PaymentType.perTask:
        return '${pay.toInt()} DA';
      case PaymentType.fixed:
        return '${pay.toInt()} DA';
    }
  }

  /// Converts model to SQLite-compatible Map
  /// Use this for INSERT/UPDATE operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employer_id': employerId,
      'title': title,
      'description': description,
      'brief_description': briefDescription,
      'category': category, // Stored directly as String
      'job_type': jobType.dbValue, // Convert enum to DB string
      'requirements': requirements,
      'pay': pay,
      'payment_type': paymentType?.dbValue, // Convert enum to DB string
      'time_commitment': timeCommitment,
      'duration': duration,
      'start_date': startDate?.millisecondsSinceEpoch,
      'location': location,
      'contact_preference': contactPreference?.dbValue,
      'is_recurring': isRecurring ? 1 : 0, // SQLite boolean as INTEGER
      'is_urgent': isUrgent ? 1 : 0,
      'requires_cv': requiresCv ? 1 : 0,
      'is_draft': isDraft ? 1 : 0,
      'number_of_positions': numberOfPositions,
      'applicants_count': applicantsCount,
      'views_count': viewsCount,
      'saves_count': savesCount,
      'status': status.dbValue,
      'deadline': applicationDeadline?.millisecondsSinceEpoch,
      'created_at': createdDate.millisecondsSinceEpoch,
      'updated_at': updatedAt?.millisecondsSinceEpoch,
      'deleted_at': deletedAt?.millisecondsSinceEpoch,
      // Note: photos and languages are NOT included - they go to separate tables
    };
  }

  /// Creates model from SQLite Map
  /// Use this for SELECT operations
  static JobPost fromMap(Map<String, dynamic> map) {
    return JobPost(
      id: map['id'] as String,
      employerId: map['employer_id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      briefDescription: map['brief_description'] as String?,
      category: map['category'] as String, // Read directly as String
      jobType: JobType.fromDb(map['job_type'] as String),
      requirements: map['requirements'] as String?,
      pay: (map['pay'] as num).toDouble(),
      paymentType: map['payment_type'] != null
          ? PaymentType.fromDb(map['payment_type'] as String)
          : null,
      timeCommitment: map['time_commitment'] as String?,
      duration: map['duration'] as String?,
      startDate: map['start_date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['start_date'] as int)
          : null,
      location: map['location'] as String?,
      contactPreference: map['contact_preference'] != null
          ? ContactPreference.fromDb(map['contact_preference'] as String)
          : null,
      isRecurring: (map['is_recurring'] as int) == 1,
      isUrgent: (map['is_urgent'] as int) == 1,
      requiresCv: (map['requires_cv'] as int) == 1,
      isDraft: (map['is_draft'] as int) == 1,
      numberOfPositions: map['number_of_positions'] as int,
      applicantsCount: map['applicants_count'] as int,
      viewsCount: map['views_count'] as int,
      savesCount: map['saves_count'] as int,
      status: JobStatus.fromDb(map['status'] as String),
      applicationDeadline: map['deadline'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['deadline'] as int)
          : null,
      createdDate:
          DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      updatedAt: map['updated_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int)
          : null,
      deletedAt: map['deleted_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['deleted_at'] as int)
          : null,
      // Note: photos and languages must be loaded separately via JOIN
      photos: const [],
      languages: const [],
    );
  }

  /// JSON serialization (for API communication)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employerId': employerId,
      'title': title,
      'description': description,
      'briefDescription': briefDescription,
      'category': category, // String
      'jobType': jobType.name,
      'requirements': requirements,
      'pay': pay,
      'paymentType': paymentType?.name,
      'timeCommitment': timeCommitment,
      'duration': duration,
      'startDate': startDate?.toIso8601String(),
      'location': location,
      'contactPreference': contactPreference?.name,
      'isRecurring': isRecurring,
      'isUrgent': isUrgent,
      'requiresCv': requiresCv,
      'isDraft': isDraft,
      'numberOfPositions': numberOfPositions,
      'applicantsCount': applicantsCount,
      'viewsCount': viewsCount,
      'savesCount': savesCount,
      'status': status.name,
      'applicationDeadline': applicationDeadline?.toIso8601String(),
      'createdDate': createdDate.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'photos': photos,
      'languages': languages,
    };
  }

  /// JSON deserialization (for API communication)
  factory JobPost.fromJson(Map<String, dynamic> json) {
    return JobPost(
      id: json['id'] as String,
      employerId: json['employerId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      briefDescription: json['briefDescription'] as String?,
      category: json['category'] as String, // String
      jobType: JobType.values.firstWhere(
        (e) => e.name == json['jobType'],
        orElse: () => JobType.partTime,
      ),
      requirements: json['requirements'] as String?,
      pay: (json['pay'] as num).toDouble(),
      paymentType: json['paymentType'] != null
          ? PaymentType.values.firstWhere(
              (e) => e.name == json['paymentType'],
              orElse: () => PaymentType.fixed,
            )
          : null,
      timeCommitment: json['timeCommitment'] as String?,
      duration: json['duration'] as String?,
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String)
          : null,
      location: json['location'] as String?,
      contactPreference: json['contactPreference'] != null
          ? ContactPreference.values.firstWhere(
              (e) => e.name == json['contactPreference'],
              orElse: () => ContactPreference.email,
            )
          : null,
      isRecurring: json['isRecurring'] as bool? ?? false,
      isUrgent: json['isUrgent'] as bool? ?? false,
      requiresCv: json['requiresCv'] as bool? ?? false,
      isDraft: json['isDraft'] as bool? ?? false,
      numberOfPositions: json['numberOfPositions'] as int? ?? 1,
      applicantsCount: json['applicantsCount'] as int? ?? 0,
      viewsCount: json['viewsCount'] as int? ?? 0,
      savesCount: json['savesCount'] as int? ?? 0,
      status: JobStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => JobStatus.active,
      ),
      applicationDeadline: json['applicationDeadline'] != null
          ? DateTime.parse(json['applicationDeadline'] as String)
          : null,
      createdDate: DateTime.parse(json['createdDate'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'] as String)
          : null,
      photos: (json['photos'] as List<dynamic>?)?.cast<String>() ?? const [],
      languages:
          (json['languages'] as List<dynamic>?)?.cast<String>() ?? const [],
    );
  }

  JobPost copyWith({
    String? id,
    String? employerId,
    String? title,
    String? description,
    String? briefDescription,
    String? category,
    JobType? jobType,
    String? requirements,
    double? pay,
    PaymentType? paymentType,
    String? timeCommitment,
    String? duration,
    DateTime? startDate,
    String? location,
    ContactPreference? contactPreference,
    bool? isRecurring,
    bool? isUrgent,
    bool? requiresCv,
    bool? isDraft,
    int? numberOfPositions,
    int? applicantsCount,
    int? viewsCount,
    int? savesCount,
    JobStatus? status,
    DateTime? applicationDeadline,
    DateTime? createdDate,
    DateTime? updatedAt,
    DateTime? deletedAt,
    List<String>? photos,
    List<String>? languages,
  }) {
    return JobPost(
      id: id ?? this.id,
      employerId: employerId ?? this.employerId,
      title: title ?? this.title,
      description: description ?? this.description,
      briefDescription: briefDescription ?? this.briefDescription,
      category: category ?? this.category,
      jobType: jobType ?? this.jobType,
      requirements: requirements ?? this.requirements,
      pay: pay ?? this.pay,
      paymentType: paymentType ?? this.paymentType,
      timeCommitment: timeCommitment ?? this.timeCommitment,
      duration: duration ?? this.duration,
      startDate: startDate ?? this.startDate,
      location: location ?? this.location,
      contactPreference: contactPreference ?? this.contactPreference,
      isRecurring: isRecurring ?? this.isRecurring,
      isUrgent: isUrgent ?? this.isUrgent,
      requiresCv: requiresCv ?? this.requiresCv,
      isDraft: isDraft ?? this.isDraft,
      numberOfPositions: numberOfPositions ?? this.numberOfPositions,
      applicantsCount: applicantsCount ?? this.applicantsCount,
      viewsCount: viewsCount ?? this.viewsCount,
      savesCount: savesCount ?? this.savesCount,
      status: status ?? this.status,
      applicationDeadline: applicationDeadline ?? this.applicationDeadline,
      createdDate: createdDate ?? this.createdDate,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      photos: photos ?? this.photos,
      languages: languages ?? this.languages,
    );
  }
}

// ============================================================================
// ENUMS - Matching Database Schema
// ============================================================================

/// Job Type - ENUM('part_time', 'task') in database
enum JobType {
  partTime('Part-Time Job', 'part_time'),
  quickTask('Quick Task', 'task');

  final String label;
  final String dbValue; // Database representation

  const JobType(this.label, this.dbValue);

  /// Parse from database value
  static JobType fromDb(String dbValue) {
    return JobType.values.firstWhere(
      (e) => e.dbValue == dbValue,
      orElse: () => JobType.partTime,
    );
  }

  /// Display name for UI
  String get displayName => label;
}

/// Job Status - ENUM('draft', 'active', 'filled', 'closed', 'expired') in database
/// FIXED: Added 'expired' status that was missing
enum JobStatus {
  draft('Draft', 'draft'),
  active('Active', 'active'),
  filled('Filled', 'filled'),
  closed('Closed', 'closed'),
  expired('Expired', 'expired'); // ADDED: Was missing from original

  final String label;
  final String dbValue;

  const JobStatus(this.label, this.dbValue);

  static JobStatus fromDb(String dbValue) {
    return JobStatus.values.firstWhere(
      (e) => e.dbValue == dbValue,
      orElse: () => JobStatus.active,
    );
  }
}

/// Payment Type - ENUM in database
enum PaymentType {
  hourly('Hourly', 'hourly'),
  daily('Daily', 'daily'),
  weekly('Weekly', 'weekly'),
  monthly('Monthly', 'monthly'),
  perTask('Per Task', 'per_task'),
  fixed('Fixed', 'fixed');

  final String label;
  final String dbValue;

  const PaymentType(this.label, this.dbValue);

  static PaymentType fromDb(String dbValue) {
    return PaymentType.values.firstWhere(
      (e) => e.dbValue == dbValue,
      orElse: () => PaymentType.fixed,
    );
  }
}

/// Contact Preference - ENUM('phone', 'email', 'whatsapp') in database
enum ContactPreference {
  phone('Phone', 'phone'),
  email('Email', 'email'),
  whatsapp('WhatsApp', 'whatsapp');

  final String label;
  final String dbValue;

  const ContactPreference(this.label, this.dbValue);

  static ContactPreference fromDb(String dbValue) {
    return ContactPreference.values.firstWhere(
      (e) => e.dbValue == dbValue,
      orElse: () => ContactPreference.email,
    );
  }
}

// ============================================================================
// HELPER CLASSES FOR LOADING RELATED DATA
// ============================================================================

/// Helper for loading photos from job_photos table
class JobPhotosHelper {
  /// Load photos for a job from job_photos table
  ///
  /// SQL: SELECT photo_url FROM job_photos WHERE job_id = ? ORDER BY display_order
  static Future<List<String>> loadPhotos(String jobId) async {
    // TODO: Implement database query
    // Example:
    // final db = await DatabaseHelper.instance.database;
    // final result = await db.query(
    //   'job_photos',
    //   columns: ['photo_url'],
    //   where: 'job_id = ?',
    //   whereArgs: [jobId],
    //   orderBy: 'display_order ASC',
    // );
    // return result.map((row) => row['photo_url'] as String).toList();
    return [];
  }

  /// Save photos for a job to job_photos table
  static Future<void> savePhotos(String jobId, List<String> photoUrls) async {
    // TODO: Implement database insert
    // Example:
    // final db = await DatabaseHelper.instance.database;
    // await db.delete('job_photos', where: 'job_id = ?', whereArgs: [jobId]);
    // for (var i = 0; i < photoUrls.length; i++) {
    //   await db.insert('job_photos', {
    //     'job_id': jobId,
    //     'photo_url': photoUrls[i],
    //     'display_order': i,
    //   });
    // }
  }
}

/// Helper for loading languages from job_required_languages table
class JobLanguagesHelper {
  /// Load required languages for a job
  ///
  /// SQL: SELECT language FROM job_required_languages WHERE job_id = ?
  static Future<List<String>> loadLanguages(String jobId) async {
    // TODO: Implement database query
    return [];
  }

  /// Save required languages for a job
  static Future<void> saveLanguages(
      String jobId, List<String> languages) async {
    // TODO: Implement database insert
  }
}
