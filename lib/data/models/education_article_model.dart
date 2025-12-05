/// Educational article/content data model
class EducationArticleModel {
  final String id;
  final String title;
  final String content;
  final String categoryId; // Changed from category (String) to categoryId (FK)
  final String? imageUrl;
  final String? author;
  final int readTime; // in minutes
  final int viewsCount; // Added
  final DateTime publishedAt;
  final DateTime createdAt; // Added
  final DateTime? updatedAt; // Added
  final DateTime? deletedAt; // Added

  EducationArticleModel({
    required this.id,
    required this.title,
    required this.content,
    required this.categoryId,
    this.imageUrl,
    this.author,
    this.readTime = 5,
    this.viewsCount = 0,
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
      'imageUrl': imageUrl,
      'author': author,
      'readTime': readTime,
      'viewsCount': viewsCount,
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
      imageUrl: json['imageUrl'],
      author: json['author'],
      readTime: json['readTime'] ?? 5,
      viewsCount: json['viewsCount'] ?? 0,
      publishedAt: DateTime.parse(json['publishedAt']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'])
          : null,
    );
  }
}
