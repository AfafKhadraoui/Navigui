/// Service data model (Fiverr-like marketplace)
class ServiceModel {
  final String id;
  final String studentId;
  final String title;
  final String description;
  final String category;
  final double startingPrice;
  final List<String>? photos;
  final List<String>? tags;
  final String deliveryTime; // '1_day', '3_days', '1_week', '2_weeks'
  final double rating;
  final int reviewCount;
  final int ordersCompleted;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ServiceModel({
    required this.id,
    required this.studentId,
    required this.title,
    required this.description,
    required this.category,
    required this.startingPrice,
    this.photos,
    this.tags,
    required this.deliveryTime,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.ordersCompleted = 0,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'title': title,
      'description': description,
      'category': category,
      'startingPrice': startingPrice,
      'photos': photos,
      'tags': tags,
      'deliveryTime': deliveryTime,
      'rating': rating,
      'reviewCount': reviewCount,
      'ordersCompleted': ordersCompleted,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      studentId: json['studentId'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      startingPrice: (json['startingPrice'] ?? 0.0).toDouble(),
      photos: json['photos'] != null ? List<String>.from(json['photos']) : null,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      deliveryTime: json['deliveryTime'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      ordersCompleted: json['ordersCompleted'] ?? 0,
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }
}
