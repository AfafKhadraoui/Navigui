import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Language Cubit
/// Manages app language/locale selection
class LanguageCubit extends Cubit<Locale> {
  static const String _languageKey = 'app_language';

  LanguageCubit() : super(const Locale('en')) {
    _loadSavedLanguage();
  }

  /// Load saved language preference from SharedPreferences
  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey);
    if (languageCode != null) {
      emit(Locale(languageCode));
    }
  }

  /// Change language and persist the selection
  Future<void> changeLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
    emit(Locale(languageCode));
  }

  /// Get current language name
  String get currentLanguageName {
    switch (state.languageCode) {
      case 'ar':
        return 'العربية';
      case 'fr':
        return 'Français';
      case 'en':
      default:
        return 'English';
    }
  }

  /// Get list of supported languages
  static const List<Map<String, String>> supportedLanguages = [
    {'code': 'en', 'name': 'English', 'nativeName': 'English'},
    {'code': 'ar', 'name': 'Arabic', 'nativeName': 'العربية'},
    {'code': 'fr', 'name': 'French', 'nativeName': 'Français'},
  ];
}
