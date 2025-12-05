import '../models/notification_model.dart';

/// Notification data repository
/// Handles notification-related data operations
class NotificationRepository {
  Future<List<NotificationModel>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _getMockNotifications();
  }

  Future<void> markAsRead(int notificationId) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  Future<void> markAllAsRead() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> deleteNotification(int notificationId) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  List<NotificationModel> _getMockNotifications() {
    return [
      NotificationModel(
        id: '1',
        userId: '1',
        title: 'Application Update',
        message: 'Your application has been reviewed',
        type: 'application',
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      NotificationModel(
        id: '2',
        userId: '1',
        title: 'New Job Posted',
        message: 'A new job matching your profile',
        type: 'job',
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      NotificationModel(
        id: '3',
        userId: '1',
        title: 'Profile Viewed',
        message: 'An employer viewed your profile',
        type: 'profile',
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }
}
