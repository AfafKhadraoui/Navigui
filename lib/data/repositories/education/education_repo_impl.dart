// lib/data/repositories/education/education_repo_impl.dart

import '../../databases/tables/education_articles_table.dart';
import '../../models/education_article_model.dart';
import '../../models/result.dart';
import 'education_repo_abstract.dart';

/// Implementation of Education Repository
/// Handles all education article data operations with error handling
class EducationRepositoryImpl extends EducationRepositoryBase {
  final DBEducationArticlesTable _dbTable = DBEducationArticlesTable();

  @override
  Future<RepositoryResult<List<EducationArticleModel>>> getArticles({
    String? categoryId,
    String? searchQuery,
  }) async {
    try {
      List<Map<String, dynamic>> results;

      if (categoryId != null && searchQuery != null && searchQuery.isNotEmpty) {
        // Both filters applied
        results = await _dbTable.getFilteredArticles(
          categoryId: categoryId,
          searchQuery: searchQuery,
        );
      } else if (categoryId != null) {
        // Category filter only
        results = await _dbTable.getArticlesByCategory(categoryId);
      } else if (searchQuery != null && searchQuery.isNotEmpty) {
        // Search filter only
        results = await _dbTable.searchArticles(searchQuery);
      } else {
        // No filters - get all published
        results = await _dbTable.getPublishedArticles();
      }

      final articles =
          results.map((map) => EducationArticleModel.fromJson(map)).toList();
      return RepositoryResult.success(articles);
    } catch (e) {
      return RepositoryResult.failure('Failed to fetch articles: $e');
    }
  }

  @override
  Future<RepositoryResult<EducationArticleModel>> getArticleById(
      String articleId) async {
    try {
      final result = await _dbTable.getRecordById(articleId);
      if (result == null) {
        return RepositoryResult.failure('Article not found');
      }
      final article = EducationArticleModel.fromJson(result);
      return RepositoryResult.success(article);
    } catch (e) {
      return RepositoryResult.failure('Failed to fetch article: $e');
    }
  }

  @override
  Future<RepositoryResult<List<EducationArticleModel>>> getPopularArticles({
    int limit = 10,
  }) async {
    try {
      final results = await _dbTable.getPopularArticles(limit: limit);
      final articles =
          results.map((map) => EducationArticleModel.fromJson(map)).toList();
      return RepositoryResult.success(articles);
    } catch (e) {
      return RepositoryResult.failure('Failed to fetch popular articles: $e');
    }
  }

  @override
  Future<RepositoryResult<List<EducationArticleModel>>> getRecentArticles({
    int limit = 10,
  }) async {
    try {
      final results = await _dbTable.getRecentArticles(limit: limit);
      final articles =
          results.map((map) => EducationArticleModel.fromJson(map)).toList();
      return RepositoryResult.success(articles);
    } catch (e) {
      return RepositoryResult.failure('Failed to fetch recent articles: $e');
    }
  }

  @override
  Future<RepositoryResult<bool>> incrementViewCount(String articleId) async {
    try {
      await _dbTable.incrementViewCount(articleId);
      return RepositoryResult.success(true);
    } catch (e) {
      return RepositoryResult.failure('Error incrementing view count: $e');
    }
  }

  @override
  Future<RepositoryResult<List<EducationArticleModel>>> searchArticles(
      String query) async {
    try {
      final results = await _dbTable.searchArticles(query);
      final articles =
          results.map((map) => EducationArticleModel.fromJson(map)).toList();
      return RepositoryResult.success(articles);
    } catch (e) {
      return RepositoryResult.failure('Failed to search articles: $e');
    }
  }

  @override
  Future<RepositoryResult<List<EducationArticleModel>>> getArticlesByCategory(
      String categoryId) async {
    try {
      final results = await _dbTable.getArticlesByCategory(categoryId);
      final articles =
          results.map((map) => EducationArticleModel.fromJson(map)).toList();
      return RepositoryResult.success(articles);
    } catch (e) {
      return RepositoryResult.failure(
          'Failed to fetch articles by category: $e');
    }
  }

  @override
  Future<RepositoryResult<List<EducationArticleModel>>> getArticlesByAudience({
    required String targetAudience,
    int? limit,
  }) async {
    try {
      final results = await _dbTable.getArticlesByAudience(
        targetAudience: targetAudience,
        limit: limit,
      );
      final articles =
          results.map((map) => EducationArticleModel.fromJson(map)).toList();
      return RepositoryResult.success(articles);
    } catch (e) {
      return RepositoryResult.failure(
          'Failed to fetch articles by audience: $e');
    }
  }

  @override
  Future<RepositoryResult<bool>> incrementLikesCount(String articleId) async {
    try {
      await _dbTable.incrementLikesCount(articleId);
      return RepositoryResult.success(true);
    } catch (e) {
      return RepositoryResult.failure('Error incrementing likes count: $e');
    }
  }

  @override
  Future<RepositoryResult<bool>> decrementLikesCount(String articleId) async {
    try {
      await _dbTable.decrementLikesCount(articleId);
      return RepositoryResult.success(true);
    } catch (e) {
      return RepositoryResult.failure('Error decrementing likes count: $e');
    }
  }
}
