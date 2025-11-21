import 'package:flutter/material.dart';
import 'package:navigui/commons/themes/style_simple/colors.dart';

/// Stat Card Widget for Employer Dashboard
/// Displays a statistic with icon, value, and title
class EmployerStatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const EmployerStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.grey2.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.grey2.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 24,
              fontFamily: 'Aclonica',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: AppColors.white.withOpacity(0.7),
              fontSize: 11,
              fontFamily: 'Acme',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
