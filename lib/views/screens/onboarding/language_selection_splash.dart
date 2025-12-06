import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:navigui/commons/themes/style_simple/colors.dart';
import 'package:navigui/commons/language_provider.dart';

/// Language Selection Page - Modern design with color palette
/// Reusable component for choosing language in onboarding flow or settings
class LanguageSelectionPage extends StatelessWidget {
  final Function(String languageCode)? onLanguageSelected;

  const LanguageSelectionPage({
    super.key,
    this.onLanguageSelected,
  });

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Container(
      color: AppColors.purple2, // Same as first onboarding page
      child: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),

                  // Title
                  Text(
                    'Choose Your\nLanguage',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 32,
                      fontFamily: 'Aclonica',
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.5,
                      height: 1.15,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Subtitle
                  Text(
                    'اختر لغتك • Choisissez',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.black.withOpacity(0.6),
                      fontSize: 13,
                      fontFamily: 'Acme',
                      letterSpacing: 0.3,
                    ),
                  ),

                  const SizedBox(height: 35),

                  // Illustration
                  Image.asset(
                    'assets/images/onboarding/welcome1.png',
                    height: 240,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 35),

                  // Language Buttons - Using employer post colors
                  _buildLanguageButton(
                    context,
                    languageProvider,
                    flag: '🇬🇧',
                    name: 'English',
                    nativeName: 'English',
                    code: 'en',
                    color: AppColors.yellow2, // #FFE078 - Soft yellow
                  ),
                  const SizedBox(height: 12),
                  _buildLanguageButton(
                    context,
                    languageProvider,
                    flag: '🇩🇿',
                    name: 'Arabic',
                    nativeName: 'العربية',
                    code: 'ar',
                    color: AppColors.orange2, // #E0A961 - Warm beige/orange
                  ),
                  const SizedBox(height: 12),
                  _buildLanguageButton(
                    context,
                    languageProvider,
                    flag: '🇫🇷',
                    name: 'French',
                    nativeName: 'Français',
                    code: 'fr',
                    color: AppColors.white, // Clean white
                  ),

                  const SizedBox(
                      height: 180), // Extra space to avoid dots overlap
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageButton(
    BuildContext context,
    LanguageProvider languageProvider, {
    required String flag,
    required String name,
    required String nativeName,
    required String code,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () async {
        // Save language selection
        await languageProvider.changeLanguage(code);

        // Callback for custom behavior (e.g., navigate to next page)
        if (onLanguageSelected != null) {
          onLanguageSelected!(code);
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color == AppColors.white
                ? AppColors.grey3.withOpacity(0.3)
                : color.withOpacity(0.6),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Flag
            Text(
              flag,
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(width: 14),

            // Language names
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 18,
                      fontFamily: 'Aclonica',
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    nativeName,
                    style: TextStyle(
                      color: AppColors.black.withOpacity(0.65),
                      fontSize: 13,
                      fontFamily: 'Acme',
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow
            Icon(
              Icons.arrow_forward_rounded,
              color: AppColors.black,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
