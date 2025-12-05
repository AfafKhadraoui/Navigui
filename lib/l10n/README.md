# 🌍 Localization (l10n) Structure Guide

## 📁 Directory Structure

```
lib/l10n/
├── app_en.arb          # MASTER FILE - English (complete reference)
├── app_ar.arb          # Arabic translations
├── app_fr.arb          # French translations
└── README.md           # This file
```

## 🎯 File Organization Strategy

Instead of having ONE massive file per language, we **logically organize translations by feature** within each ARB file using **section comments**.

### Section Organization:

1. **COMMON** - Buttons, labels, general UI elements
2. **AUTH** - Login, signup, password, onboarding
3. **JOBS** - Job listings, details, categories
4. **APPLICATIONS** - Application submission, status
5. **PROFILE** - Student & employer profiles
6. **SEARCH** - Search, filters, sorting
7. **NOTIFICATIONS** - Notifications, badges
8. **REVIEWS** - Reviews, ratings, feedback
9. **SAVED_JOBS** - Bookmarks, saved jobs
10. **EDUCATION** - Educational articles, resources
11. **ADMIN** - Admin panel, moderation
12. **EMPLOYER** - Employer-specific features
13. **VALIDATION** - Form validation messages
14. **ERRORS** - Error messages, alerts

## 📝 ARB File Format

### What is ARB?

**ARB** = **Application Resource Bundle**

- JSON-based format for translations
- Supported by Flutter's official localization system
- Contains key-value pairs + metadata

### Basic Structure:

```json
{
  "@@locale": "en",
  "@@context": "Description of this translation file",

  "_comment_section": "═══════════════════════════════════",
  "_section_name": "SECTION NAME",
  "_comment_section_end": "═══════════════════════════════════",

  "translationKey": "Translation text",
  "@translationKey": {
    "description": "What this translation is used for",
    "context": "Additional context for translators"
  },

  "greetingMessage": "Hello {name}!",
  "@greetingMessage": {
    "description": "Greeting message with name placeholder",
    "placeholders": {
      "name": {
        "type": "String",
        "example": "Ahmed"
      }
    }
  }
}
```

## 🔑 Naming Conventions

### Key Naming Rules:

1. **camelCase** for all keys (e.g., `loginButton`, `emailPlaceholder`)
2. **Descriptive names** that indicate purpose (not just content)
3. **Prefix by feature** for clarity (e.g., `jobTitle`, `jobDescription`, `profileBio`)

### Examples:

- ✅ GOOD: `authLoginButton`, `jobApplyButton`, `profileSaveButton`
- ❌ BAD: `button1`, `button2`, `clickHere`

- ✅ GOOD: `authEmailPlaceholder`, `jobSearchPlaceholder`
- ❌ BAD: `enterEmail`, `search`

## 🌐 Supported Languages

### Current Languages:

1. **English (en)** - Default language, complete reference
2. **Arabic (ar)** - RTL support required
3. **French (fr)** - Common in Algeria

### Language Codes:

- `en` - English
- `ar` - Arabic
- `fr` - French

### How to Add a New Language:

1. Create new ARB file: `app_<code>.arb` (e.g., `app_es.arb` for Spanish)
2. Copy structure from `app_en.arb`
3. Translate all values (keep keys unchanged)
4. Run `flutter pub get` to regenerate files
5. Update `MaterialApp` supported locales in `main.dart`

## 📐 Translation Guidelines

### For English (en) - MASTER FILE:

- ✅ Complete and comprehensive
- ✅ Include descriptions for all keys
- ✅ Add context for complex translations
- ✅ Define all placeholders with examples
- ✅ Use clear, professional language

### For Arabic (ar):

- ✅ Use formal Arabic (Modern Standard Arabic)
- ✅ Consider RTL (Right-to-Left) display
- ✅ Translate meaning, not word-by-word
- ✅ Adapt cultural references appropriately
- ⚠️ Test RTL layout in UI

### For French (fr):

- ✅ Use formal French
- ✅ Consider Algerian French context
- ✅ Use proper accents (é, è, à, etc.)
- ✅ Gender-neutral language where possible

## 🔄 How Localization Works

### 1. **ARB Files** (Source)

```json
// lib/l10n/app_en.arb
{
  "loginButton": "Login",
  "@loginButton": {
    "description": "Button text for login action"
  }
}
```

### 2. **Generated Dart Code** (Auto-generated)

```dart
// lib/generated/l10n/app_localizations.dart
class AppLocalizations {
  String get loginButton => 'Login';
}
```

### 3. **Usage in Flutter** (Your code)

```dart
// lib/views/auth/login_screen.dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

ElevatedButton(
  onPressed: () {},
  child: Text(AppLocalizations.of(context)!.loginButton),
)
```

## 🛠️ Generation Commands

### Regenerate Localization Files:

```bash
# Method 1: Using flutter gen-l10n
flutter gen-l10n

# Method 2: Using pub get (if generate: true in pubspec.yaml)
flutter pub get

# Method 3: Clean and regenerate
flutter clean
flutter pub get
```

### When to Regenerate:

- ✅ After adding new translation keys
- ✅ After modifying ARB files
- ✅ After changing l10n.yaml configuration
- ✅ If generated files are deleted

## 📊 Translation Progress Tracking

### Completion Status:

- ✅ **English (en)**: 100% complete (102 keys) - MASTER
- 🔄 **Arabic (ar)**: ~1% complete (1 key) - NEEDS TRANSLATION
- ❌ **French (fr)**: 0% complete (0 keys) - NEEDS TRANSLATION

### Priority Translation Order:

1. **P1 (Critical)**: Auth, Common, Errors
2. **P2 (High)**: Jobs, Applications, Profile
3. **P3 (Medium)**: Search, Notifications, Reviews
4. **P4 (Low)**: Education, Admin

## 📱 Usage Examples

### Simple Text:

```dart
Text(AppLocalizations.of(context)!.appName)
```

### With Parameters:

```dart
// ARB file:
"greetingMessage": "Hello {name}!"

// Usage:
Text(AppLocalizations.of(context)!.greetingMessage('Ahmed'))
```

### Plural Forms:

```dart
// ARB file:
"jobsCount": "{count, plural, =0{No jobs} =1{1 job} other{{count} jobs}}"

// Usage:
Text(AppLocalizations.of(context)!.jobsCount(jobList.length))
```

### Date/Time Formatting:

```dart
// ARB file:
"lastUpdated": "Last updated: {date}"

// Usage:
Text(AppLocalizations.of(context)!.lastUpdated(
  DateFormat.yMd().format(DateTime.now())
))
```

## 🎨 Best Practices

### DO:

- ✅ Keep keys in alphabetical order within sections
- ✅ Add `@` metadata for every translation key
- ✅ Use placeholders for dynamic content
- ✅ Write clear descriptions for translators
- ✅ Test translations in actual UI
- ✅ Keep translations concise for mobile screens
- ✅ Use section comments for organization
- ✅ Commit ARB files to version control
- ✅ Review translations with native speakers

### DON'T:

- ❌ Edit generated files in `lib/generated/l10n/`
- ❌ Hard-code text in UI widgets
- ❌ Mix languages in the same ARB file
- ❌ Use offensive or inappropriate language
- ❌ Duplicate keys across files
- ❌ Forget to regenerate after changes
- ❌ Use long sentences without breaking
- ❌ Assume direct translations work

## 🐛 Common Issues & Solutions

### Issue: Generated files not updating

```bash
# Solution:
flutter clean
flutter pub get
# Or force regeneration:
flutter gen-l10n
```

### Issue: "AppLocalizations not found"

```dart
// Solution: Add to main.dart
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

MaterialApp(
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: const [
    Locale('en'),
    Locale('ar'),
    Locale('fr'),
  ],
)
```

### Issue: RTL not working for Arabic

```dart
// Solution: Ensure locale is set correctly
MaterialApp(
  locale: const Locale('ar'),
  // Flutter automatically handles RTL for 'ar'
)
```

### Issue: Missing translations

```bash
# Solution: Check for typos in key names
# Verify ARB file JSON syntax is valid
# Ensure all languages have the same keys
```

## 📚 Resources

- [Flutter Internationalization](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization)
- [ARB Format Specification](https://github.com/google/app-resource-bundle)
- [Intl Package Documentation](https://pub.dev/packages/intl)
- [Material Localization](https://api.flutter.dev/flutter/flutter_localizations/GlobalMaterialLocalizations-class.html)

## 🎯 Translation Workflow

### For Developers:

1. Add English key in `app_en.arb`
2. Run `flutter pub get`
3. Use in code: `AppLocalizations.of(context)!.keyName`
4. Test in English
5. Request translations for ar/fr

### For Translators:

1. Receive English ARB file as reference
2. Open target language ARB file
3. Translate values (keep keys unchanged)
4. Return completed ARB file
5. Developer runs `flutter pub get`

## 📞 Contact

For translation assistance or questions:

- **Developer**: [Your Name]
- **Translation Coordinator**: [Coordinator Name]
- **Project**: Navigui - Student Job Marketplace

---

**Last Updated**: December 4, 2025
**Languages Supported**: English (en), Arabic (ar), French (fr)
**Total Translation Keys**: 102+ (and growing)
