import 'package:flutter/material.dart';
import 'package:navigui/commons/themes/style_simple/colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onExploreTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.onExploreTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 20,
              fontFamily: 'Aclonica',
              letterSpacing: -0.5,
            ),
          ),
          GestureDetector(
            onTap: onExploreTap,
            child: Text(
              'explore more',
              style: TextStyle(
                color: AppColors.electricLime,
                fontSize: 14,
                fontFamily: 'Acme',
                letterSpacing: -0.5,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.electricLime,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
