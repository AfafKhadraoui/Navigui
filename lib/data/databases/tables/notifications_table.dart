// lib/data/databases/tables/notifications_table.dart

import '../db_base_table.dart';

class DBNotificationsTable extends DBBaseTable {
  @override
  String get tableName => 'notifications';

  /// Get all notifications for a user (ordered by newest first)
  Future<List<Map<String, dynamic>>> getUserNotifications(String userId) async {
    try {
      final db = await getDatabase();
      return await db.query(
        tableName,
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'created_at DESC',
      );
    } catch (e) {
      print('Error fetching user notifications: $e');
      return [];
    }
  }

  /// Get unread notifications for a user
  Future<List<Map<String, dynamic>>> getUnreadNotifications(
      String userId) async {
    try {
      final db = await getDatabase();
      return await db.query(
        tableName,
        where: 'user_id = ? AND is_read = ?',
        whereArgs: [userId, 0],
        orderBy: 'created_at DESC',
      );
    } catch (e) {
      print(' Error fetching unread notifications: $e');
      return [];
    }
  }

  /// Count unread notifications
  Future<int> countUnreadNotifications(String userId) async {
    try {
      final db = await getDatabase();
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM $tableName WHERE user_id = ? AND is_read = ?',
        [userId, 0],
      );
      return result.first['count'] as int? ?? 0;
    } catch (e) {
      print('Error counting unread notifications: $e');
      return 0;
    }
  }

  /// Mark notification as read
  Future<bool> markAsRead(String notificationId) async {
    try {
      final db = await getDatabase();
      await db.update(
        tableName,
        {'is_read': 1},
        where: 'id = ?',
        whereArgs: [notificationId],
      );
      return true;
    } catch (e) {
      print('Error marking notification as read: $e');
      return false;
    }
  }

  /// Mark all notifications as read for a user
  Future<bool> markAllAsRead(String userId) async {
    try {
      final db = await getDatabase();
      await db.update(
        tableName,
        {'is_read': 1},
        where: 'user_id = ? AND is_read = ?',
        whereArgs: [userId, 0],
      );
      return true;
    } catch (e) {
      print('Error marking all notifications as read: $e');
      return false;
    }
  }

  /// Delete notification
  Future<bool> deleteNotification(String notificationId) async {
    return await deleteRecord(notificationId);
  }

  /// Delete all notifications for a user
  Future<bool> deleteAllUserNotifications(String userId) async {
    try {
      final db = await getDatabase();
      await db.delete(
        tableName,
        where: 'user_id = ?',
        whereArgs: [userId],
      );
      return true;
    } catch (e) {
      print('Error deleting all user notifications: $e');
      return false;
    }
  }

  /// Get notifications by type
  Future<List<Map<String, dynamic>>> getNotificationsByType({
    required String userId,
    required String type,
  }) async {
    try {
      final db = await getDatabase();
      return await db.query(
        tableName,
        where: 'user_id = ? AND type = ?',
        whereArgs: [userId, type],
        orderBy: 'created_at DESC',
      );
    } catch (e) {
      print('Error fetching notifications by type: $e');
      return [];
    }
  }

  /// Get notifications by priority
  Future<List<Map<String, dynamic>>> getNotificationsByPriority({
    required String userId,
    required String priority,
  }) async {
    try {
      final db = await getDatabase();
      return await db.query(
        tableName,
        where: 'user_id = ? AND priority = ?',
        whereArgs: [userId, priority],
        orderBy: 'created_at DESC',
      );
    } catch (e) {
      print('Error fetching notifications by priority: $e');
      return [];
    }
  }

  /// Get urgent notifications
  Future<List<Map<String, dynamic>>> getUrgentNotifications(
      String userId) async {
    return await getNotificationsByPriority(
      userId: userId,
      priority: 'urgent',
    );
  }

  /// Mark notification as pushed
  Future<void> markAsPushed(String notificationId) async {
    try {
      final db = await getDatabase();
      await db.update(
        tableName,
        {'is_pushed': 1},
        where: 'id = ?',
        whereArgs: [notificationId],
      );
    } catch (e) {
      print('Error marking notification as pushed: $e');
    }
  }

  /// Delete old read notifications (older than specified days)
  Future<int> deleteOldReadNotifications({
    required String userId,
    int daysOld = 30,
  }) async {
    try {
      final db = await getDatabase();
      final cutoffDate =
          DateTime.now().subtract(Duration(days: daysOld)).toIso8601String();

      final result = await db.delete(
        tableName,
        where: 'user_id = ? AND is_read = ? AND created_at < ?',
        whereArgs: [userId, 1, cutoffDate],
      );
      return result;
    } catch (e) {
      print('Error deleting old notifications: $e');
      return 0;
    }
  }
}
