/// Task data model (simpler than job)
class TaskModel {
  final String id;
  final String employerId;
  final String title;
  final String description;
  final String category;
  final double pay;
  final String? location;
  final DateTime? deadline;
  final bool isUrgent;
  final String status; // 'active', 'completed', 'cancelled'
  final DateTime createdAt;
  final DateTime? completedAt;

  TaskModel({
    required this.id,
    required this.employerId,
    required this.title,
    required this.description,
    required this.category,
    required this.pay,
    this.location,
    this.deadline,
    this.isUrgent = false,
    this.status = 'active',
    required this.createdAt,
    this.completedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employerId': employerId,
      'title': title,
      'description': description,
      'category': category,
      'pay': pay,
      'location': location,
      'deadline': deadline?.toIso8601String(),
      'isUrgent': isUrgent,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      employerId: json['employerId'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      pay: (json['pay'] ?? 0.0).toDouble(),
      location: json['location'],
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'])
          : null,
      isUrgent: json['isUrgent'] ?? false,
      status: json['status'] ?? 'active',
      createdAt: DateTime.parse(json['createdAt']),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
    );
  }
}
