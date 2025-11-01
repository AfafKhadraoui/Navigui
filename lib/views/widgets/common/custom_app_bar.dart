import 'package:flutter/material.dart';
import 'package:navigui/commons/themes/style_simple/colors.dart';

/// Custom App Bar with profile and notifications
/// Used in Home screen and other main screens
class CustomAppBar extends StatelessWidget {
  final String userName;
  final bool hasNotification;

  const CustomAppBar({
    super.key,
    required this.userName,
    this.hasNotification = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
      color: AppColors.background,
      child: Row(
        children: [
          // Profile avatar
          Stack(
            children: [
              // Avatar circle
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    userName[0].toUpperCase(),
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Online status indicator
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppColors.electricLime,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.background,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 15),

          // Greeting text
          Expanded(
            child: Text(
              'Hello, $userName',
              style: TextStyle(
                color: AppColors.purple1, // #AB93E0
                fontSize: 16,
                fontFamily: 'Aclonica',
                letterSpacing: -0.5,
              ),
            ),
          ),

          // Notification bell
          Stack(
            children: [
              Icon(
                Icons.notifications_outlined,
                color: AppColors.grey2,
                size: 24,
              ),

              // Notification dot
              if (hasNotification)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.electricLime,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.background,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}