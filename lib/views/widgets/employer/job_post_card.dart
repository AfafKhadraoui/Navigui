import 'package:flutter/material.dart';
import 'package:navigui/commons/themes/style_simple/colors.dart';

/// Job Post Card Widget for Employer
/// Displays a job post with status, applicant count, and details
class JobPostCard extends StatelessWidget {
  final String title;
  final int applicants;
  final String status;
  final Color color;
  final String postedDate;
  final String? location;
  final String? deadline;
  final int? views;
  final VoidCallback? onTap;

  const JobPostCard({
    super.key,
    required this.title,
    required this.applicants,
    required this.status,
    required this.color,
    required this.postedDate,
    this.location,
    this.deadline,
    this.views,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.black.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 9,
                            fontFamily: 'Acme',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Icon(Icons.more_vert, color: AppColors.black, size: 18),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 13,
                    fontFamily: 'Aclonica',
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (location != null)
                      Flexible(
                        flex: 2,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.location_on_outlined,
                                color: AppColors.black.withOpacity(0.6),
                                size: 10),
                            const SizedBox(width: 2),
                            Flexible(
                              child: Text(
                                location!,
                                style: TextStyle(
                                  color: AppColors.black.withOpacity(0.7),
                                  fontSize: 8,
                                  fontFamily: 'Acme',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (location != null && deadline != null)
                      const SizedBox(width: 4),
                    if (deadline != null)
                      Flexible(
                        flex: 2,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.access_time,
                                color: AppColors.black.withOpacity(0.6),
                                size: 10),
                            const SizedBox(width: 2),
                            Flexible(
                              child: Text(
                                deadline!,
                                style: TextStyle(
                                  color: AppColors.black.withOpacity(0.7),
                                  fontSize: 8,
                                  fontFamily: 'Acme',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  postedDate,
                  style: TextStyle(
                    color: AppColors.black.withOpacity(0.6),
                    fontSize: 8,
                    fontFamily: 'Acme',
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.people, color: AppColors.black, size: 13),
                      const SizedBox(width: 2),
                      Flexible(
                        child: Text(
                          '$applicants',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 10,
                            fontFamily: 'Acme',
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (views != null) ...[
                        const SizedBox(width: 6),
                        Icon(Icons.visibility_outlined,
                            color: AppColors.black.withOpacity(0.7), size: 12),
                        const SizedBox(width: 2),
                        Flexible(
                          child: Text(
                            '$views',
                            style: TextStyle(
                              color: AppColors.black.withOpacity(0.8),
                              fontSize: 9,
                              fontFamily: 'Acme',
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    color: AppColors.white,
                    size: 13,
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
