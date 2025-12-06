import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/notifications/notifications_repo_abstract.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepositoryBase _notificationRepository;
  final String _userId;

  NotificationCubit(this._notificationRepository, this._userId)
      : super(NotificationInitial());

  Future<void> loadNotifications() async {
    try {
      emit(NotificationLoading());

      final result = await _notificationRepository.getNotifications(_userId);
      final countResult = await _notificationRepository.getUnreadCount(_userId);

      if (result.isSuccess && countResult.isSuccess) {
        emit(NotificationsLoaded(
          notifications: result.data!,
          unreadCount: countResult.data!,
        ));
      } else {
        emit(NotificationError(result.error ??
            countResult.error ??
            'Failed to load notifications'));
      }
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> loadUnreadNotifications() async {
    try {
      emit(NotificationLoading());

      final result =
          await _notificationRepository.getUnreadNotifications(_userId);
      final countResult = await _notificationRepository.getUnreadCount(_userId);

      if (result.isSuccess && countResult.isSuccess) {
        emit(NotificationsLoaded(
          notifications: result.data!,
          unreadCount: countResult.data!,
        ));
      } else {
        emit(NotificationError(result.error ??
            countResult.error ??
            'Failed to load unread notifications'));
      }
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      final result = await _notificationRepository.markAsRead(notificationId);

      if (result.isSuccess) {
        emit(NotificationMarkedAsRead(notificationId));
        // Reload notifications to update unread count
        await loadNotifications();
      } else {
        emit(NotificationError(result.error ?? 'Failed to mark as read'));
      }
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> markAllAsRead() async {
    try {
      emit(NotificationLoading());

      final result = await _notificationRepository.markAllAsRead(_userId);

      if (result.isSuccess) {
        emit(AllNotificationsMarkedAsRead());
        // Reload notifications
        await loadNotifications();
      } else {
        emit(NotificationError(result.error ?? 'Failed to mark all as read'));
      }
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      final result =
          await _notificationRepository.deleteNotification(notificationId);

      if (result.isSuccess) {
        emit(NotificationDeleted(notificationId));
        // Reload notifications
        await loadNotifications();
      } else {
        emit(
            NotificationError(result.error ?? 'Failed to delete notification'));
      }
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> loadNotificationsByType(String type) async {
    try {
      emit(NotificationLoading());

      final result =
          await _notificationRepository.getNotificationsByType(_userId, type);
      final countResult = await _notificationRepository.getUnreadCount(_userId);

      if (result.isSuccess && countResult.isSuccess) {
        emit(NotificationsLoaded(
          notifications: result.data!,
          unreadCount: countResult.data!,
        ));
      } else {
        emit(NotificationError(result.error ??
            countResult.error ??
            'Failed to load notifications by type'));
      }
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> loadUrgentNotifications() async {
    try {
      emit(NotificationLoading());

      final result =
          await _notificationRepository.getUrgentNotifications(_userId);
      final countResult = await _notificationRepository.getUnreadCount(_userId);

      if (result.isSuccess && countResult.isSuccess) {
        emit(NotificationsLoaded(
          notifications: result.data!,
          unreadCount: countResult.data!,
        ));
      } else {
        emit(NotificationError(result.error ??
            countResult.error ??
            'Failed to load urgent notifications'));
      }
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> refreshNotifications() async {
    await loadNotifications();
  }

  Future<void> cleanOldNotifications({int daysOld = 30}) async {
    try {
      final result = await _notificationRepository.deleteOldReadNotifications(
        _userId,
        daysOld: daysOld,
      );

      if (result.isSuccess) {
        // Reload notifications after cleanup
        await loadNotifications();
      }
    } catch (e) {
      // Silent fail - cleanup is not critical
      print('Error cleaning old notifications: $e');
    }
  }

  Future<void> deleteAllNotifications() async {
    try {
      final result =
          await _notificationRepository.deleteAllNotifications(_userId);

      if (result.isSuccess) {
        emit(NotificationsLoaded(notifications: [], unreadCount: 0));
      } else {
        emit(NotificationError(
            result.error ?? 'Failed to delete all notifications'));
      }
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }
}
