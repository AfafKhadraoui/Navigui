import 'package:flutter/material.dart';
import '../../../logic/services/session_manager.dart';
import '../../../commons/themes/style_simple/colors.dart';

/// Session Timeout Warning Dialog
/// Shows when user session is about to expire
class SessionTimeoutWarning extends StatelessWidget {
  final SessionManager sessionManager;
  final VoidCallback onExtend;
  final VoidCallback onLogout;

  const SessionTimeoutWarning({
    super.key,
    required this.sessionManager,
    required this.onExtend,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.orange2, width: 1),
      ),
      title: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: AppColors.orange2, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Session Expiring',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your session is about to expire due to inactivity.',
            style: TextStyle(
              color: AppColors.grey6,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Would you like to continue your session?',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onLogout();
          },
          child: Text(
            'Logout',
            style: TextStyle(
              color: AppColors.grey6,
              fontSize: 14,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onExtend();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.orange2,
            foregroundColor: AppColors.black,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Continue Session',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  /// Show session timeout warning dialog
  static Future<void> show({
    required BuildContext context,
    required SessionManager sessionManager,
    required VoidCallback onExtend,
    required VoidCallback onLogout,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SessionTimeoutWarning(
        sessionManager: sessionManager,
        onExtend: onExtend,
        onLogout: onLogout,
      ),
    );
  }
}
