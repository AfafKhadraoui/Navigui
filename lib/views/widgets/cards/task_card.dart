import 'package:flutter/material.dart';
import 'package:navigui/commons/themes/style_simple/colors.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String time;
  final String location;
  final Color backgroundColor;
  final String earnings;
  final String status;
  final int tasksCompleted;
  final int totalTasks;
  final VoidCallback? onTap;

  const TaskCard({
    super.key,
    required this.title,
    required this.time,
    required this.location,
    required this.backgroundColor,
    required this.earnings,
    required this.status,
    required this.tasksCompleted,
    required this.totalTasks,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 110,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top row - title and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 17,
                      fontFamily: 'Aclonica',
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.black.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 10,
                      fontFamily: 'Acme',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            // Middle row - time and location
            Row(
              children: [
                Icon(Icons.access_time, color: AppColors.black, size: 14),
                const SizedBox(width: 5),
                Text(
                  time,
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 12,
                    fontFamily: 'Acme',
                  ),
                ),
                const SizedBox(width: 15),
                Icon(
                  location == 'Online' ? Icons.laptop : Icons.location_on,
                  color: AppColors.black,
                  size: 14,
                ),
                const SizedBox(width: 5),
                Text(
                  location,
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 12,
                    fontFamily: 'Acme',
                  ),
                ),
              ],
            ),

            // Bottom row - earnings, progress, and action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Earnings
                Text(
                  earnings,
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 14,
                    fontFamily: 'Acme',
                    fontWeight: FontWeight.w600,
                  ),
                ),

                // Progress
                Text(
                  '$tasksCompleted/$totalTasks tasks',
                  style: TextStyle(
                    color: AppColors.black.withOpacity(0.7),
                    fontSize: 11,
                    fontFamily: 'Acme',
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
