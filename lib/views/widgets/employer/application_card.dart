import 'package:flutter/material.dart';
import 'package:navigui/commons/themes/style_simple/colors.dart';

/// Application Card Widget for Employer
/// Displays a student's application with accept/reject actions
class EmployerApplicationCard extends StatelessWidget {
  final String studentName;
  final String jobTitle;
  final String timeAgo;
  final Color avatarColor;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onTap;

  const EmployerApplicationCard({
    super.key,
    required this.studentName,
    required this.jobTitle,
    required this.timeAgo,
    required this.avatarColor,
    this.onAccept,
    this.onReject,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.grey1.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: avatarColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  studentName[0],
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 20,
                    fontFamily: 'Aclonica',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    studentName,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 15,
                      fontFamily: 'Aclonica',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Applied for: $jobTitle',
                    style: TextStyle(
                      color: AppColors.white.withOpacity(0.6),
                      fontSize: 12,
                      fontFamily: 'Acme',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timeAgo,
                    style: TextStyle(
                      color: AppColors.white.withOpacity(0.5),
                      fontSize: 11,
                      fontFamily: 'Acme',
                    ),
                  ),
                ],
              ),
            ),

            // Action buttons
            Row(
              children: [
                GestureDetector(
                  onTap: onAccept,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.electricLime.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.electricLime.withOpacity(0.5),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      color: AppColors.electricLime,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onReject,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.grey2.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.grey2.withOpacity(0.4),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      color: AppColors.grey2,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
