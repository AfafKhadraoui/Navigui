// lib/data/repositories/notifications/notifications_repo_abstract.dart

import '../../models/notification_model.dart';
import '../../models/result.dart';

/// Abstract base class for Notification Repository
/// Defines the contract for notification operations
abstract class NotificationRepositoryBase {
  /// Get all notifications for a user
  Future<RepositoryResult<List<NotificationModel>>> getNotifications(
      String userId);

  /// Get unread notifications for a user
  Future<RepositoryResult<List<NotificationModel>>> getUnreadNotifications(
      String userId);

  /// Get count of unread notifications
  Future<RepositoryResult<int>> getUnreadCount(String userId);

  /// Mark a notification as read
  Future<RepositoryResult<bool>> markAsRead(String notificationId);

  /// Mark all notifications as read for a user
  Future<RepositoryResult<bool>> markAllAsRead(String userId);

  /// Delete a notification
  Future<RepositoryResult<bool>> deleteNotification(String notificationId);

  /// Delete all notifications for a user
  Future<RepositoryResult<bool>> deleteAllNotifications(String userId);

  /// Create a new notification
  Future<RepositoryResult<NotificationModel>> createNotification(
      NotificationModel notification);

  /// Get notifications by type
  Future<RepositoryResult<List<NotificationModel>>> getNotificationsByType(
    String userId,
    String type,
  );

  /// Get notifications by priority
  Future<RepositoryResult<List<NotificationModel>>> getNotificationsByPriority(
    String userId,
    String priority,
  );

  /// Get urgent notifications
  Future<RepositoryResult<List<NotificationModel>>> getUrgentNotifications(
      String userId);

  /// Delete old read notifications
  Future<RepositoryResult<int>> deleteOldReadNotifications(String userId,
      {int daysOld = 30});

  /// Singleton instance
  static NotificationRepositoryBase? _instance;

  static NotificationRepositoryBase getInstance() {
    _instance ??= _createInstance();
    return _instance!;
  }

  static NotificationRepositoryBase _createInstance() {
    throw UnimplementedError('Must be implemented by concrete class');
  }
}
