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
      'user_id': userId,
      'title': title,
      'message': message,
      'type': type,
      'related_id': relatedId,
      'related_type': relatedType,
      'action_url': actionUrl,
      'priority': priority,
      'is_read': isRead ? 1 : 0,
      'is_pushed': isPushed ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    // Handle createdAt - can be String or DateTime from database
    final createdAtValue = json['createdAt'] ?? json['created_at'];
    final DateTime createdAtParsed;
    if (createdAtValue is String) {
      createdAtParsed = DateTime.parse(createdAtValue);
    } else if (createdAtValue is DateTime) {
      createdAtParsed = createdAtValue;
    } else {
      createdAtParsed = DateTime.now();
    }

    return NotificationModel(
      id: json['id']?.toString() ?? '',
      userId: (json['userId'] ?? json['user_id'])?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      relatedId:
          json['relatedId']?.toString() ?? json['related_id']?.toString(),
      relatedType:
          json['relatedType']?.toString() ?? json['related_type']?.toString(),
      actionUrl:
          json['actionUrl']?.toString() ?? json['action_url']?.toString(),
      priority: (json['priority'] ?? 'medium')?.toString() ?? 'medium',
      isRead: json['isRead'] == true || json['is_read'] == 1,
      isPushed: json['isPushed'] == true || json['is_pushed'] == 1,
      createdAt: createdAtParsed,
    );
  }
}
