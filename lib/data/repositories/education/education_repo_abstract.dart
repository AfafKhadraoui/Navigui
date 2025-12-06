// lib/data/repositories/education/education_repo_abstract.dart

import '../../models/education_article_model.dart';
import '../../models/result.dart';

/// Abstract base class for Education Repository
/// Defines the contract for education article operations
abstract class EducationRepositoryBase {
  /// Get all published articles with optional filters
  Future<RepositoryResult<List<EducationArticleModel>>> getArticles({
    String? categoryId,
    String? searchQuery,
  });

  /// Get a specific article by ID
  Future<RepositoryResult<EducationArticleModel>> getArticleById(
      String articleId);

  /// Get popular articles (sorted by view count)
  Future<RepositoryResult<List<EducationArticleModel>>> getPopularArticles({
    int limit = 10,
  });

  /// Get recent articles (sorted by published date)
  Future<RepositoryResult<List<EducationArticleModel>>> getRecentArticles({
    int limit = 10,
  });

  /// Increment view count for an article
  Future<RepositoryResult<bool>> incrementViewCount(String articleId);

  /// Search articles by query
  Future<RepositoryResult<List<EducationArticleModel>>> searchArticles(
      String query);

  /// Get articles by category
  Future<RepositoryResult<List<EducationArticleModel>>> getArticlesByCategory(
      String categoryId);

  /// Get articles by target audience (student or employer)
  Future<RepositoryResult<List<EducationArticleModel>>> getArticlesByAudience({
    required String targetAudience,
    int? limit,
  });

  /// Increment likes count for an article
  Future<RepositoryResult<bool>> incrementLikesCount(String articleId);

  /// Decrement likes count for an article
  Future<RepositoryResult<bool>> decrementLikesCount(String articleId);

  /// Singleton instance
  static EducationRepositoryBase? _instance;

  static EducationRepositoryBase getInstance() {
    _instance ??= _createInstance();
    return _instance!;
  }

  static EducationRepositoryBase _createInstance() {
    throw UnimplementedError('Must be implemented by concrete class');
  }
}
