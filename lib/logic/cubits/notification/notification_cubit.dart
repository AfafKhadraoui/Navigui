import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/notification_repo.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository _notificationRepository;

  NotificationCubit(this._notificationRepository)
      : super(NotificationInitial());

  Future<void> loadNotifications() async {
    try {
      emit(NotificationLoading());
      final notifications = await _notificationRepository.getNotifications();
      final unreadCount = notifications.where((n) => !n.isRead).length;
      emit(NotificationsLoaded(
        notifications: notifications,
        unreadCount: unreadCount,
      ));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> markAsRead(int notificationId) async {
    try {
      await _notificationRepository.markAsRead(notificationId);
      emit(NotificationMarkedAsRead(notificationId));
      // Reload notifications to update unread count
      await loadNotifications();
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> markAllAsRead() async {
    try {
      emit(NotificationLoading());
      await _notificationRepository.markAllAsRead();
      emit(AllNotificationsMarkedAsRead());
      // Reload notifications
      await loadNotifications();
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> deleteNotification(int notificationId) async {
    try {
      await _notificationRepository.deleteNotification(notificationId);
      emit(NotificationDeleted(notificationId));
      // Reload notifications
      await loadNotifications();
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> refreshNotifications() async {
    await loadNotifications();
  }
}
