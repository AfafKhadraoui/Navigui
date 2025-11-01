import 'package:flutter/material.dart';
import 'package:navigui/commons/themes/style_simple/colors.dart';

class JobCard extends StatelessWidget {
  final String title;
  final String location;
  final String salary;
  final Color backgroundColor;
  final String? imagePath;
  final bool isLiked;
  final VoidCallback? onTap;

  const JobCard({
    super.key,
    required this.title,
    required this.location,
    required this.salary,
    required this.backgroundColor,
    this.imagePath,
    this.isLiked = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                  width: 121,
                  height: 120,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 121,
                      height: 120,
                      color: Colors.grey.withOpacity(0.2),
                      child: Icon(Icons.image, size: 40, color: Colors.grey),
                    );
                  },
                ),
              ),

            // Text content
            Positioned(
              left: 9,
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    location,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 11,
                      fontFamily: 'Acme',
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    salary,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 11,
                      fontFamily: 'Acme',
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),

            // Like button - Always show on top right
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

            // Action buttons
            Positioned(
              left: 9,
              right: 9,
              bottom: 14,
              child: Row(
                children: [
                  _buildButton('Read more', backgroundColor),
                  const SizedBox(width: 3),
                  _buildButton('Apply Now', backgroundColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String label, Color textColor) {
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
