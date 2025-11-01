import 'package:flutter/material.dart';
import 'package:navigui/commons/themes/style_simple/colors.dart';

class EducationCard extends StatelessWidget {
  final String title;
  final String badge1;
  final String badge2;
  final String badge3;
  final Color backgroundColor;
  final String? imagePath;
  final bool isLiked;

  const EducationCard({
    super.key,
    required this.title,
    required this.badge1,
    required this.badge2,
    required this.badge3,
    required this.backgroundColor,
    this.imagePath,
    this.isLiked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 224,
      height: 158,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          // Image
          if (imagePath != null)
            Positioned(
              right: 10,
              top: 10,
              child: Image.asset(
                imagePath!,
                width: 125,
                height: 120,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 125,
                    height: 120,
                    color: Colors.grey.withOpacity(0.2),
                  );
                },
              ),
            ),

          // Text content
          Positioned(
            left: 14,
            top: 15,
            right: 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                    fontFamily: 'Aclonica',
                    height: 1.1,
                    letterSpacing: -0.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  'explore →',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 12,
                    fontFamily: 'Aclonica',
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),

          // Like button - Always show on top right (consistent position with job cards)
          Positioned(
            right: 9,
            top: 7,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.black,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? AppColors.red1 : AppColors.white,
                size: 16,
              ),
            ),
          ),

          // Info badges
          Positioned(
            left: 9,
            right: 9,
            bottom: 14,
            child: Row(
              children: [
                _buildBadge(badge1, backgroundColor),
                const SizedBox(width: 3),
                _buildBadge(badge2, backgroundColor),
                if (badge3.isNotEmpty) ...[
                  const SizedBox(width: 3),
                  _buildBadge(badge3, backgroundColor),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, Color textColor) {
    return Container(
      height: 18,
      padding: const EdgeInsets.symmetric(horizontal: 9),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 10,
            fontFamily: 'Acme',
            letterSpacing: -0.5,
          ),
        ),
      ),
    );
  }
}
