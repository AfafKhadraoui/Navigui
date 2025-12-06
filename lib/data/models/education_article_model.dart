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
      'categoryId': categoryId,
      'targetAudience': targetAudience,
      'imageUrl': imageUrl,
      'author': author,
      'readTime': readTime,
      'viewsCount': viewsCount,
      'likesCount': likesCount,
      'publishedAt': publishedAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  factory EducationArticleModel.fromJson(Map<String, dynamic> json) {
    return EducationArticleModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      categoryId: json['categoryId'],
      targetAudience:
          json['targetAudience'] ?? json['target_audience'] ?? 'student',
      imageUrl: json['imageUrl'] ?? json['image_url'],
      author: json['author'],
      readTime: json['readTime'] ?? json['read_time'] ?? 5,
      viewsCount: json['viewsCount'] ?? json['views_count'] ?? 0,
      likesCount: json['likesCount'] ?? json['likes_count'] ?? 0,
      publishedAt: DateTime.parse(json['publishedAt'] ?? json['published_at']),
      createdAt: DateTime.parse(json['createdAt'] ?? json['created_at']),
      updatedAt: (json['updatedAt'] ?? json['updated_at']) != null
          ? DateTime.parse(json['updatedAt'] ?? json['updated_at'])
          : null,
      deletedAt: (json['deletedAt'] ?? json['deleted_at']) != null
          ? DateTime.parse(json['deletedAt'] ?? json['deleted_at'])
          : null,
    );
  }
}
