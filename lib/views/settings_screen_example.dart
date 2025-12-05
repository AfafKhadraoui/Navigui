import 'package:flutter/material.dart';
import '../commons/widgets/language_selector.dart';
import '../generated/s.dart';

/// Example Settings Screen showing language selector
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).commonSettings),
        actions: [
          // Option 1: Icon button in app bar
          const LanguageIconButton(),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // General Section
          Text(
            'General',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 12),

          // Language Setting Tile
          ListTile(
            leading: const Icon(Icons.language, size: 28),
            title: Text(S.of(context).commonLanguage),
            subtitle: const Text('Change app language'),
            trailing:
                const LanguageButton(), // Shows current language + dropdown
            onTap: () => LanguageSelector.show(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            tileColor: Colors.grey[100],
          ),

          const SizedBox(height: 16),

          // Other Settings
          Text(
            'Preferences',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 12),

          ListTile(
            leading: const Icon(Icons.notifications, size: 28),
            title: const Text('Notifications'),
            subtitle: const Text('Manage notification preferences'),
            trailing: Switch(value: true, onChanged: (val) {}),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            tileColor: Colors.grey[100],
          ),
        ],
      ),
    );
  }
}

/// Example: Floating language button (for onboarding)
class OnboardingScreenWithLanguage extends StatelessWidget {
  const OnboardingScreenWithLanguage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Your onboarding content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  S.of(context).appName,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  S.of(context).appTagline,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),

          // Floating language button in top-right corner
          Positioned(
            top: 50,
            right: 16,
            child: const LanguageButton(),
          ),
        ],
      ),
    );
  }
}
