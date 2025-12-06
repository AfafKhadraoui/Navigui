import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/cubits/language/language_cubit.dart';
import '../../../commons/themes/style_simple/colors.dart';

/// Settings Screen
/// Language selection, notifications, privacy settings, account management
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'GENERAL',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            
            // Language Selection
            BlocBuilder<LanguageCubit, Locale>(
              builder: (context, locale) {
                final languageCubit = context.read<LanguageCubit>();
                return _buildSettingsTile(
                  icon: Icons.language,
                  title: 'Language',
                  subtitle: languageCubit.currentLanguageName,
                  onTap: () => _showLanguageDialog(context),
                );
              },
            ),
            
            Divider(color: AppColors.grey4, height: 32),
            
            const Text(
              'NOTIFICATIONS',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildSettingsTile(
              icon: Icons.notifications,
              title: 'Push Notifications',
              subtitle: 'Manage notification preferences',
              onTap: () {
                // TODO: Implement notification settings
              },
            ),
            
            Divider(color: AppColors.grey4, height: 32),
            
            const Text(
              'PRIVACY & SECURITY',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildSettingsTile(
              icon: Icons.lock,
              title: 'Privacy',
              subtitle: 'Control your privacy settings',
              onTap: () {
                // TODO: Implement privacy settings
              },
            ),
            
            _buildSettingsTile(
              icon: Icons.security,
              title: 'Security',
              subtitle: 'Password and authentication',
              onTap: () {
                // TODO: Implement security settings
              },
            ),
            
            Divider(color: AppColors.grey4, height: 32),
            
            const Text(
              'ABOUT',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildSettingsTile(
              icon: Icons.info,
              title: 'About Navigui',
              subtitle: 'Version 1.0.0',
              onTap: () {
                // TODO: Show about dialog
              },
            ),
            
            _buildSettingsTile(
              icon: Icons.description,
              title: 'Terms & Conditions',
              subtitle: 'Read our terms of service',
              onTap: () {
                // TODO: Show terms
              },
            ),
            
            _buildSettingsTile(
              icon: Icons.privacy_tip,
              title: 'Privacy Policy',
              subtitle: 'Read our privacy policy',
              onTap: () {
                // TODO: Show privacy policy
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.grey4,
        title: const Text(
          'Select Language',
          style: TextStyle(color: AppColors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: LanguageCubit.supportedLanguages.map((lang) {
            return BlocBuilder<LanguageCubit, Locale>(
              builder: (context, locale) {
                final isSelected = locale.languageCode == lang['code'];
                return ListTile(
                  title: Text(
                    lang['nativeName']!,
                    style: TextStyle(
                      color: isSelected ? AppColors.primary : AppColors.white,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    lang['name']!,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onTap: () {
                    context.read<LanguageCubit>().changeLanguage(lang['code']!);
                    Navigator.pop(dialogContext);
                  },
                );
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}
