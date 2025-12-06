// lib/data/databases/tables/education_articles_table.dart

import '../db_base_table.dart';

class DBEducationArticlesTable extends DBBaseTable {
  @override
  String get tableName => 'education_articles';

  /// Get all published articles (not deleted)
  Future<List<Map<String, dynamic>>> getPublishedArticles() async {
    try {
      final db = await getDatabase();
      return await db.query(
        tableName,
        where: 'deleted_at IS NULL',
        orderBy: 'published_at DESC, created_at DESC',
      );
    } catch (e) {
      print(' Error fetching published articles: $e');
      return [];
    }
  }

  /// Get articles by category
  Future<List<Map<String, dynamic>>> getArticlesByCategory(
      String categoryId) async {
    try {
      final db = await getDatabase();
      return await db.query(
        tableName,
        where: 'category_id = ? AND deleted_at IS NULL',
        whereArgs: [categoryId],
        orderBy: 'published_at DESC',
      );
    } catch (e) {
      print(' Error fetching articles by category: $e');
      return [];
    }
  }

  /// Search articles by title or content
  Future<List<Map<String, dynamic>>> searchArticles(String query) async {
    try {
      final db = await getDatabase();
      final searchPattern = '%$query%';
      return await db.query(
        tableName,
        where: '(title LIKE ? OR content LIKE ?) AND deleted_at IS NULL',
        whereArgs: [searchPattern, searchPattern],
        orderBy: 'views_count DESC, published_at DESC',
      );
    } catch (e) {
      print(' Error searching articles: $e');
      return [];
    }
  }

  /// Get articles with filters (category + search)
  Future<List<Map<String, dynamic>>> getFilteredArticles({
    String? categoryId,
    String? searchQuery,
  }) async {
    try {
      final db = await getDatabase();

      final conditions = <String>['deleted_at IS NULL'];
      final args = <dynamic>[];

      if (categoryId != null && categoryId.isNotEmpty) {
        conditions.add('category_id = ?');
        args.add(categoryId);
      }

      if (searchQuery != null && searchQuery.isNotEmpty) {
        conditions.add('(title LIKE ? OR content LIKE ?)');
        final searchPattern = '%$searchQuery%';
        args.add(searchPattern);
        args.add(searchPattern);
      }

      return await db.query(
        tableName,
        where: conditions.join(' AND '),
        whereArgs: args.isEmpty ? null : args,
        orderBy: 'published_at DESC, created_at DESC',
      );
    } catch (e) {
      print(' Error fetching filtered articles: $e');
      return [];
    }
  }

  /// Increment views count
  Future<void> incrementViewCount(String articleId) async {
    try {
      final db = await getDatabase();
      await db.rawUpdate(
        'UPDATE $tableName SET views_count = views_count + 1 WHERE id = ?',
        [articleId],
      );
    } catch (e) {
      print(' Error incrementing view count: $e');
    }
  }

  /// Get most popular articles
  Future<List<Map<String, dynamic>>> getPopularArticles(
      {int limit = 10}) async {
    try {
      final db = await getDatabase();
      return await db.query(
        tableName,
        where: 'deleted_at IS NULL',
        orderBy: 'views_count DESC, published_at DESC',
        limit: limit,
      );
    } catch (e) {
      print(' Error fetching popular articles: $e');
      return [];
    }
  }

  /// Get recent articles
  Future<List<Map<String, dynamic>>> getRecentArticles({int limit = 10}) async {
    try {
      final db = await getDatabase();
      return await db.query(
        tableName,
        where: 'deleted_at IS NULL',
        orderBy: 'published_at DESC, created_at DESC',
        limit: limit,
      );
    } catch (e) {
      print(' Error fetching recent articles: $e');
      return [];
    }
  }

  /// Soft delete article
  Future<bool> softDeleteArticle(String articleId) async {
    try {
      final db = await getDatabase();
      final now = DateTime.now().toIso8601String();
      await db.update(
        tableName,
        {'deleted_at': now},
        where: 'id = ?',
        whereArgs: [articleId],
      );
      return true;
    } catch (e) {
      print(' Error soft deleting article: $e');
      return false;
    }
  }

  /// Get article by ID (for detail view)
  Future<Map<String, dynamic>?> getArticleById(String articleId) async {
    try {
      final db = await getDatabase();
      final results = await db.query(
        tableName,
        where: 'id = ? AND deleted_at IS NULL',
        whereArgs: [articleId],
        limit: 1,
      );
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      print(' Error fetching article by ID: $e');
      return null;
    }
  }

  /// Get articles by target audience (student or employer)
  Future<List<Map<String, dynamic>>> getArticlesByAudience({
    required String targetAudience,
    int? limit,
  }) async {
    try {
      final db = await getDatabase();
      return await db.query(
        tableName,
        where: 'target_audience = ? AND deleted_at IS NULL',
        whereArgs: [targetAudience],
        orderBy: 'published_at DESC, created_at DESC',
        limit: limit,
      );
    } catch (e) {
      print(' Error fetching articles by audience: $e');
      return [];
    }
  }

  /// Increment likes count
  Future<void> incrementLikesCount(String articleId) async {
    try {
      final db = await getDatabase();
      await db.rawUpdate(
        'UPDATE $tableName SET likes_count = likes_count + 1 WHERE id = ?',
        [articleId],
      );
    } catch (e) {
      print(' Error incrementing likes count: $e');
    }
  }

  /// Decrement likes count
  Future<void> decrementLikesCount(String articleId) async {
    try {
      final db = await getDatabase();
      await db.rawUpdate(
        'UPDATE $tableName SET likes_count = likes_count - 1 WHERE id = ? AND likes_count > 0',
        [articleId],
      );
    } catch (e) {
      print(' Error decrementing likes count: $e');
    }
  }
}
