// lib/data/repositories/notifications/notifications_repo_impl.dart

import '../../databases/tables/notifications_table.dart';
import '../../models/notification_model.dart';
import '../../models/result.dart';
import 'notifications_repo_abstract.dart';

/// Implementation of Notification Repository
/// Handles all notification data operations with error handling
class NotificationRepositoryImpl extends NotificationRepositoryBase {
  final DBNotificationsTable _dbTable = DBNotificationsTable();

  @override
  Future<RepositoryResult<List<NotificationModel>>> getNotifications(
      String userId) async {
    try {
      final results = await _dbTable.getUserNotifications(userId);
      final notifications =
          results.map((map) => NotificationModel.fromJson(map)).toList();
      return RepositoryResult.success(notifications);
    } catch (e) {
      return RepositoryResult.failure('Failed to fetch notifications: $e');
    }
  }

  @override
  Future<RepositoryResult<List<NotificationModel>>> getUnreadNotifications(
      String userId) async {
    try {
      final results = await _dbTable.getUnreadNotifications(userId);
      final notifications =
          results.map((map) => NotificationModel.fromJson(map)).toList();
      return RepositoryResult.success(notifications);
    } catch (e) {
      return RepositoryResult.failure(
          'Failed to fetch unread notifications: $e');
    }
  }

  @override
  Future<RepositoryResult<int>> getUnreadCount(String userId) async {
    try {
      final count = await _dbTable.countUnreadNotifications(userId);
      return RepositoryResult.success(count);
    } catch (e) {
      return RepositoryResult.failure('Failed to fetch unread count: $e');
    }
  }

  @override
  Future<RepositoryResult<bool>> markAsRead(String notificationId) async {
    try {
      final success = await _dbTable.markAsRead(notificationId);
      if (success) {
        return RepositoryResult.success(true);
      } else {
        return RepositoryResult.failure('Failed to mark notification as read');
      }
    } catch (e) {
      return RepositoryResult.failure('Error marking notification as read: $e');
    }
  }

  @override
  Future<RepositoryResult<bool>> markAllAsRead(String userId) async {
    try {
      final success = await _dbTable.markAllAsRead(userId);
      if (success) {
        return RepositoryResult.success(true);
      } else {
        return RepositoryResult.failure(
            'Failed to mark all notifications as read');
      }
    } catch (e) {
      return RepositoryResult.failure(
          'Error marking all notifications as read: $e');
    }
  }

  @override
  Future<RepositoryResult<bool>> deleteNotification(
      String notificationId) async {
    try {
      final success = await _dbTable.deleteNotification(notificationId);
      if (success) {
        return RepositoryResult.success(true);
      } else {
        return RepositoryResult.failure('Failed to delete notification');
      }
    } catch (e) {
      return RepositoryResult.failure('Error deleting notification: $e');
    }
  }

  @override
  Future<RepositoryResult<bool>> deleteAllNotifications(String userId) async {
    try {
      final success = await _dbTable.deleteAllUserNotifications(userId);
      if (success) {
        return RepositoryResult.success(true);
      } else {
        return RepositoryResult.failure('Failed to delete all notifications');
      }
    } catch (e) {
      return RepositoryResult.failure('Error deleting all notifications: $e');
    }
  }

  @override
  Future<RepositoryResult<NotificationModel>> createNotification(
      NotificationModel notification) async {
    try {
      final db = await _dbTable.getDatabase();
      final id = await db.insert(_dbTable.tableName, notification.toJson());

      // Fetch the created notification from the database
      final notificationsData =
          await _dbTable.getUserNotifications(notification.userId);
      final createdNotificationData = notificationsData.firstWhere(
        (n) => n['id'] == id.toString(),
        orElse: () => throw Exception('Notification not found after creation'),
      );
      final createdNotification =
          NotificationModel.fromJson(createdNotificationData);
      return RepositoryResult.success(createdNotification);
    } catch (e) {
      return RepositoryResult.failure('Failed to create notification: $e');
    }
  }

  @override
  Future<RepositoryResult<List<NotificationModel>>> getNotificationsByType(
    String userId,
    String type,
  ) async {
    try {
      final results = await _dbTable.getNotificationsByType(
        userId: userId,
        type: type,
      );
      final notifications =
          results.map((map) => NotificationModel.fromJson(map)).toList();
      return RepositoryResult.success(notifications);
    } catch (e) {
      return RepositoryResult.failure(
          'Failed to fetch notifications by type: $e');
    }
  }

  @override
  Future<RepositoryResult<List<NotificationModel>>> getNotificationsByPriority(
    String userId,
    String priority,
  ) async {
    try {
      final results = await _dbTable.getNotificationsByPriority(
        userId: userId,
        priority: priority,
      );
      final notifications =
          results.map((map) => NotificationModel.fromJson(map)).toList();
      return RepositoryResult.success(notifications);
    } catch (e) {
      return RepositoryResult.failure(
          'Failed to fetch notifications by priority: $e');
    }
  }

  @override
  Future<RepositoryResult<List<NotificationModel>>> getUrgentNotifications(
      String userId) async {
    try {
      final results = await _dbTable.getUrgentNotifications(userId);
      final notifications =
          results.map((map) => NotificationModel.fromJson(map)).toList();
      return RepositoryResult.success(notifications);
    } catch (e) {
      return RepositoryResult.failure(
          'Failed to fetch urgent notifications: $e');
    }
  }

  @override
  Future<RepositoryResult<int>> deleteOldReadNotifications(String userId,
      {int daysOld = 30}) async {
    try {
      final count = await _dbTable.deleteOldReadNotifications(
        userId: userId,
        daysOld: daysOld,
      );
      return RepositoryResult.success(count);
    } catch (e) {
      return RepositoryResult.failure('Failed to delete old notifications: $e');
    }
  }
}
