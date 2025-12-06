/// Educational article/content data model
class EducationArticleModel {
  final String id;
  final String title;
  final String content;
  final String categoryId; // Changed from category (String) to categoryId (FK)
  final String targetAudience; // 'student' or 'employer'
  final String? imageUrl;
  final String? author;
  final int readTime; // in minutes
  final int viewsCount; // Added
  final int likesCount; // Added
  final DateTime publishedAt;
  final DateTime createdAt; // Added
  final DateTime? updatedAt; // Added
  final DateTime? deletedAt; // Added

  EducationArticleModel({
    required this.id,
    required this.title,
    required this.content,
    required this.categoryId,
    this.targetAudience = 'student',
    this.imageUrl,
    this.author,
    this.readTime = 5,
    this.viewsCount = 0,
    this.likesCount = 0,
    required this.publishedAt,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category_id': categoryId,
      'target_audience': targetAudience,
      'image_url': imageUrl,
      'author': author,
      'read_time': readTime,
      'views_count': viewsCount,
      'likes_count': likesCount,
      'published_at': publishedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  factory EducationArticleModel.fromJson(Map<String, dynamic> json) {
    // Handle DateTime parsing safely
    DateTime parseDateTime(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is DateTime) return value;
      if (value is String) return DateTime.parse(value);
      return DateTime.now();
    }

    DateTime? parseOptionalDateTime(dynamic value) {
      if (value == null) return null;
      if (value is DateTime) return value;
      if (value is String) return DateTime.parse(value);
      return null;
    }

    return EducationArticleModel(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      content: (json['content'] ?? '').toString(),
      categoryId: (json['categoryId'] ?? json['category_id'] ?? '').toString(),
      targetAudience:
          (json['targetAudience'] ?? json['target_audience'] ?? 'student')
              .toString(),
      imageUrl: json['imageUrl']?.toString() ?? json['image_url']?.toString(),
      author: json['author']?.toString(),
      readTime: (json['readTime'] ?? json['read_time'] ?? 5) is int
          ? (json['readTime'] ?? json['read_time'] ?? 5)
          : int.tryParse(
                  (json['readTime'] ?? json['read_time'] ?? 5).toString()) ??
              5,
      viewsCount: (json['viewsCount'] ?? json['views_count'] ?? 0) is int
          ? (json['viewsCount'] ?? json['views_count'] ?? 0)
          : int.tryParse((json['viewsCount'] ?? json['views_count'] ?? 0)
                  .toString()) ??
              0,
      likesCount: (json['likesCount'] ?? json['likes_count'] ?? 0) is int
          ? (json['likesCount'] ?? json['likes_count'] ?? 0)
          : int.tryParse((json['likesCount'] ?? json['likes_count'] ?? 0)
                  .toString()) ??
              0,
      publishedAt: parseDateTime(json['publishedAt'] ?? json['published_at']),
      createdAt: parseDateTime(json['createdAt'] ?? json['created_at']),
      updatedAt: parseOptionalDateTime(json['updatedAt'] ?? json['updated_at']),
      deletedAt: parseOptionalDateTime(json['deletedAt'] ?? json['deleted_at']),
    );
  }
}
