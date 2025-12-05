/// Notification data model
/// Matches database 'notifications' table
class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String
      type; // 'job_match', 'application_response', 'new_applicant', etc.
  final String? relatedId; // Related job/application/review ID
  final String? relatedType; // 'job', 'application', 'review', etc.
  final String? actionUrl; // Screen to navigate to when clicked
  final String priority; // 'low', 'medium', 'high', 'urgent'
  final bool isRead;
  final bool isPushed; // Track if push notification was sent
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    this.relatedId,
    this.relatedType,
    this.actionUrl,
    this.priority = 'medium',
    this.isRead = false,
    this.isPushed = false,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'message': message,
      'type': type,
      'relatedId': relatedId,
      'relatedType': relatedType,
      'actionUrl': actionUrl,
      'priority': priority,
      'isRead': isRead,
      'isPushed': isPushed,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      message: json['message'],
      type: json['type'],
      relatedId: json['relatedId'],
      relatedType: json['relatedType'],
      actionUrl: json['actionUrl'],
      priority: json['priority'] ?? 'medium',
      isRead: json['isRead'] ?? false,
      isPushed: json['isPushed'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
