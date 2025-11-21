import 'package:flutter/material.dart';
import 'package:navigui/commons/themes/style_simple/colors.dart';
import 'package:provider/provider.dart';
import '../../../logic/services/auth_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> _getNotifications(bool isEmployer) {
    if (isEmployer) {
      // Employer notifications
      return [
        {
          'title': 'New application received!',
          'subtitle': 'Ahmed Benali applied for your Waiter Needed position.',
          'highlightColor': Color(0xFFD2FF1F), // Electric lime highlight
          'isRead': false,
        },
        {
          'title':
              'Your job post "Delivery Driver" expires in 2 days. Renew now to keep it active!',
          'subtitle': '',
          'highlightColor': null,
          'isRead': false,
        },
        {
          'title':
              'Fatima Kader completed the job. Rate their performance to help other employers.',
          'subtitle': '',
          'highlightColor': null,
          'isRead': false,
        },
      ];
    } else {
      // Student notifications
      return [
        {
          'title': 'Your application was accepted!',
          'subtitle':
              'Café Littéraire accepted your application for Weekend Waiter.',
          'highlightColor': Color(0xFFD2FF1F),
          'isRead': false,
        },
        {
          'title':
              'The Social Media Manager position you saved expires in 2 days. Apply now!',
          'subtitle': '',
          'highlightColor': null,
          'isRead': false,
        },
        {
          'title':
              'You completed a job with QuickBox Delivery. Rate your experience to help other students.',
          'subtitle': '',
          'highlightColor': null,
          'isRead': false,
        },
      ];
    }
  }

  late List<Map<String, dynamic>> _notifications;
  late bool _isEmployer;

  @override
  void initState() {
    super.initState();
    // Initialize in initState to avoid resetting on rebuild
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get role from provider and initialize notifications once
    final authService = context.read<AuthService>();
    _isEmployer = authService.isEmployer;
    if (!_notificationsInitialized) {
      _notifications = _getNotifications(_isEmployer);
      _notificationsInitialized = true;
    }
  }

  bool _notificationsInitialized = false;

  void _removeNotification(int index) {
    setState(() {
      _notifications.removeAt(index);
    });
  }

  void _clearAllNotifications() {
    setState(() {
      _notifications.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // #1A1A1A
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
          if (_notifications.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16, top: 8),
              child: GestureDetector(
                onTap: _clearAllNotifications,
                child: Icon(
                  Icons.delete_outline,
                  color: AppColors.electricLime,
                  size: 28,
                ),
              ),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // "No more" text
                  Text(
                    'You are all \ncaught up!',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 34,
                      fontFamily: 'Aclonica',
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Illustration
                  Image.asset(
                    'assets/images/illustrations/notif.png',
                    height: 300,
                    width: 300,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              itemCount: _notifications.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return _buildNotificationCard(
                  title: notification['title'],
                  subtitle: notification['subtitle'],
                  highlightColor: notification['highlightColor'],
                  onDismiss: () => _removeNotification(index),
                );
              },
            ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String subtitle,
    Color? highlightColor,
    required VoidCallback onDismiss,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF2F2F2F), // Dark grey background
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
                if (highlightColor != null)
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: title,
                          style: TextStyle(
                            color: highlightColor, // Yellow for highlighted
                            fontSize: 16,
                            fontFamily: 'Acme', // ⭐ Changed to Acme
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.5,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontFamily: 'Acme', // ⭐ Changed to Acme
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.5,
                      height: 1.3,
                    ),
                    maxLines: 2, // ⭐ Limit to 2 lines
                    overflow:
                        TextOverflow.ellipsis, // ⭐ Add ellipsis if too long
                  ),

                // Subtitle (if exists)
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                      fontFamily: 'Acme', // ⭐ Changed to Acme
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.5,
                      height: 1.3,
                    ),
                    maxLines: 2, // ⭐ Limit to 2 lines
                    overflow:
                        TextOverflow.ellipsis, // ⭐ Add ellipsis if too long
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Close button (X)
          GestureDetector(
            onTap: onDismiss,
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
}
