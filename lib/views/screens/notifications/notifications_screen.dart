import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigui/commons/themes/style_simple/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../logic/cubits/notification/notification_cubit.dart';
import '../../../logic/cubits/notification/notification_state.dart';
import '../../../core/dependency_injection.dart';

class NotificationsScreen extends StatefulWidget {
  final String? userId;

  const NotificationsScreen({super.key, this.userId});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    setState(() {
      _currentUserId = widget.userId ?? userId ?? 'user123';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUserId == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
      );
    }

    final currentUserId = _currentUserId!;

    return BlocProvider(
      create: (context) =>
          getIt<NotificationCubit>(param1: currentUserId)..loadNotifications(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: AppColors.white, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Notifications',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 28,
                fontFamily: 'Aclonica',
                fontWeight: FontWeight.w400,
                letterSpacing: -0.5,
              ),
            ),
          ),
          centerTitle: true,
          actions: [
            BlocBuilder<NotificationCubit, NotificationState>(
              builder: (context, state) {
                if (state is NotificationsLoaded &&
                    state.notifications.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16, top: 8),
                    child: GestureDetector(
                      onTap: () {
                        context
                            .read<NotificationCubit>()
                            .deleteAllNotifications();
                      },
                      child: Icon(
                        Icons.delete_outline,
                        color: AppColors.electricLime,
                        size: 28,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.electricLime,
                ),
              );
            }

            if (state is NotificationError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading notifications',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        state.message,
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<NotificationCubit>()
                            .refreshNotifications();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.electricLime,
                        foregroundColor: AppColors.background,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is NotificationsLoaded) {
              final notifications = state.notifications;

              if (notifications.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'You are all \ncaught up!',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 34,
                          fontFamily: 'Aclonica',
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      Icon(
                        Icons.notifications_off_outlined,
                        color: Colors.white38,
                        size: 120,
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await context
                      .read<NotificationCubit>()
                      .refreshNotifications();
                },
                color: AppColors.electricLime,
                backgroundColor: AppColors.background,
                child: ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  itemCount: notifications.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return _buildNotificationCard(
                      context: context,
                      notification: notification,
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required BuildContext context,
    required notification,
  }) {
    // Determine highlight color (electric lime for important notifications)
    final hasHighlight = notification.priority == 'high' ||
        notification.priority == 'urgent' ||
        notification.type == 'application';
    final highlightColor = hasHighlight ? AppColors.electricLime : null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF2F2F2F),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title with optional highlight
                Text(
                  notification.title,
                  style: TextStyle(
                    color: highlightColor ?? AppColors.white,
                    fontSize: 16,
                    fontFamily: 'Acme',
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.5,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                // Subtitle/message (if exists)
                if (notification.message.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    notification.message,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                      fontFamily: 'Acme',
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.5,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Close button (X)
          GestureDetector(
            onTap: () {
              context
                  .read<NotificationCubit>()
                  .deleteNotification(notification.id);
            },
            child: Container(
              width: 24,
              height: 24,
              child: Icon(
                Icons.close,
                color: AppColors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime dateTime) {
    try {
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inHours < 1) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inDays < 1) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      }
    } catch (e) {
      return '';
    }
  }
}
