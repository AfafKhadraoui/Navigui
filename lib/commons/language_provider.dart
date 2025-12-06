import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Language Manager - Handles app language state
class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('en'); // Default to English

  Locale get currentLocale => _currentLocale;

  LanguageProvider() {
    _loadSavedLanguage();
  }

  /// Load saved language from local storage
  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'en';
    _currentLocale = Locale(languageCode);
    notifyListeners();
  }

  /// Change app language and save preference
  Future<void> changeLanguage(String languageCode) async {
    if (_currentLocale.languageCode == languageCode) return;

    _currentLocale = Locale(languageCode);

    // Save to local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);

    notifyListeners();
  }

  /// Get display name for language
  String getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'ar':
        return 'العربية';
      case 'fr':
        return 'Français';
      default:
        return 'English';
    }
  }

  /// Get all supported languages
  List<Map<String, String>> get supportedLanguages => [
        {
          'code': 'en',
          'name': 'English',
          'nativeName': 'English',
          'flag': '🇬🇧'
        },
        {
          'code': 'ar',
          'name': 'Arabic',
          'nativeName': 'العربية',
          'flag': '🇩🇿'
        },
        {
          'code': 'fr',
          'name': 'French',
          'nativeName': 'Français',
          'flag': '🇫🇷'
        },
      ];
}
