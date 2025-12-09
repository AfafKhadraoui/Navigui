class SavedJob {
  final String id;
  final String userId;
  final String jobId;
  final DateTime savedDate;
  final Job? jobDetails;

  SavedJob({
    required this.id,
    required this.userId,
    required this.jobId,
    required this.savedDate,
    this.jobDetails,
  });

  factory SavedJob.fromJson(Map<String, dynamic> json) {
    return SavedJob(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      jobId: json['jobId'] ?? '',
      savedDate: json['savedDate'] != null
          ? DateTime.parse(json['savedDate'])
          : DateTime.now(),
      jobDetails: json['jobDetails'] != null
          ? Job.fromJson(json['jobDetails'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'jobId': jobId,
      'savedDate': savedDate.toIso8601String(),
      'jobDetails': jobDetails?.toJson(),
    };
  }
}