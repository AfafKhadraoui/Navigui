# Language Selection Implementation Guide

## Overview

This guide explains how to implement first-launch language selection for Navigui app.

## Approach: Splash Screen Language Selection

### Why This Approach?

1. **Target Market**: Algeria/North Africa users speak Arabic, French, or English
2. **First Impression**: Language choice should happen BEFORE users see any text
3. **Registration Flow**: 4-5 step registration needs to be in correct language from start
4. **User Experience**: One-time choice on first launch, no friction for returning users
5. **Accessibility**: Users can still change language later in Settings

---

## User Flow

### First Launch (New Users)

```
App Launch
  ↓
Splash Screen (5s - checks if language is set)
  ↓
Language Selection Screen (NEW)
  - Shows "Navigui" logo
  - 3 language cards: 🇬🇧 English, 🇩🇿 العربية, 🇫🇷 Français
  - User selects → saves to SharedPreferences
  ↓
Onboarding Screen (in chosen language)
  ↓
Rest of app flow...
```

### Returning Users

```
App Launch
  ↓
Splash Screen (5s - language already set)
  ↓
Auto-navigate to Onboarding/Home
  ↓
(Can change language anytime in Settings)
```

---

## Implementation Steps

### ✅ Step 1: File Already Created

**File**: `lib/views/screens/onboarding/language_selection_splash.dart`

- Full UI with 3 language cards
- Uses existing `LanguageProvider`
- Brutalist design matching app theme
- Loading indicator during language save

### 🔧 Step 2: Update Main.dart (REQUIRED)

**Current**: Uses basic `main.dart` without language support
**Needed**: Switch to language-aware version

**Action**: Replace `lib/main.dart` content with logic from `lib/main_with_language.dart`

```dart
// Key changes needed in main.dart:

// 1. Add imports
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'commons/language_provider.dart';
import 'generated/s.dart';

// 2. Wrap app with ChangeNotifierProvider
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();

  runApp(
    ChangeNotifierProvider(
      create: (_) => LanguageProvider(),
      child: const NaviguiApp(),
    ),
  );
}

// 3. Add Consumer and localization delegates
Widget build(BuildContext context) {
  return MultiBlocProvider(
    providers: [...],
    child: Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return MaterialApp.router(
          locale: languageProvider.currentLocale,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
            Locale('fr'),
          ],
          // ... rest of config
        );
      },
    ),
  );
}
```

### 🔧 Step 3: Update Splash Screen Logic

**File**: `lib/views/screens/onboarding/splash_screen.dart`

**Current behavior**: 5-second delay → navigate to onboarding

**New behavior**:

- Check if language is already set
- If NOT set → navigate to language selection
- If set → navigate to onboarding (current behavior)

```dart
// In _SplashScreenState initState():

@override
void initState() {
  super.initState();
  _checkLanguageAndNavigate();
}

Future<void> _checkLanguageAndNavigate() async {
  await Future.delayed(const Duration(seconds: 5));

  if (!mounted) return;

  // Check if language has been selected before
  final prefs = await SharedPreferences.getInstance();
  final hasLanguage = prefs.containsKey('language_code');

  if (hasLanguage) {
    // Returning user - go to onboarding
    context.go(AppRouter.onboarding);
  } else {
    // First-time user - show language selection
    context.go('/language-selection');
  }
}
```

### 🔧 Step 4: Add Route to App Router

**File**: `lib/routes/app_router.dart`

Add import:

```dart
import '../views/screens/onboarding/language_selection_splash.dart';
```

Add route (in GoRouter routes list):

```dart
GoRoute(
  path: '/language-selection',
  name: 'language-selection',
  builder: (context, state) => const LanguageSelectionSplash(),
),
```

### 🔧 Step 5: Update Settings Screen (Optional - for later)

**File**: `lib/views/screens/profile/settings_screen.dart`

Replace placeholder with full settings UI including language switcher:

```dart
import 'package:provider/provider.dart';
import '../../../commons/language_provider.dart';
import '../../../commons/widgets/language_selector.dart';

// In settings screen, add language section:
ListTile(
  leading: Icon(Icons.language),
  title: Text('Language'),
  subtitle: Text(Provider.of<LanguageProvider>(context).getLanguageName(
    Provider.of<LanguageProvider>(context).currentLocale.languageCode
  )),
  onTap: () {
    showDialog(
      context: context,
      builder: (context) => const LanguageSelector(),
    );
  },
),
```

---

## Dependencies Check

### Required Packages (should already be in pubspec.yaml):

```yaml
dependencies:
  provider: ^6.0.0
  shared_preferences: ^2.0.0
  flutter_localizations:
    sdk: flutter
  intl: any
```

### Generated Files Required:

- `lib/generated/s.dart` (from ARB files)
- `lib/l10n/intl_en.arb`
- `lib/l10n/intl_ar.arb`
- `lib/l10n/intl_fr.arb`

---

## Testing Checklist

### First Launch Test:

- [ ] Install fresh (or clear app data)
- [ ] App shows splash for 5 seconds
- [ ] Language selection screen appears
- [ ] Select English → continues to onboarding in English
- [ ] Restart app → goes directly to onboarding (no language selection)

### Language Switch Test:

- [ ] Clear app data
- [ ] Select Arabic → verify onboarding shows Arabic text
- [ ] Restart app → app remembers Arabic
- [ ] Clear data, select French → verify French text

### Settings Test (after Step 5):

- [ ] Navigate to Settings
- [ ] Tap language option
- [ ] Change language → app UI updates immediately
- [ ] Restart app → new language persists

---

## Visual Design

The language selection screen matches Navigui's brutalist design:

- **Background**: Electric lime (#D2FF1F)
- **Cards**: Black with electric lime text
- **Logo**: "Navigui" in Aclonica font
- **Decorative shapes**: Same octagonal shapes as splash
- **Language cards**:
  - Flag emoji (🇬🇧 🇩🇿 🇫🇷)
  - Language name in native script
  - Arrow indicator
  - Full-width tap targets

---

## Summary

**What's Ready:**
✅ Language selection screen created
✅ LanguageProvider exists
✅ Language selector widget exists
✅ ARB translation files exist

**What Needs Implementation (30-45 min):**

1. Update main.dart with Provider wrapper (5 min)
2. Update splash_screen.dart with language check (10 min)
3. Add route to app_router.dart (5 min)
4. Test first launch flow (10 min)
5. Update settings screen (optional, 10 min)

**Result:**

- Professional first-launch experience
- Language set before user sees any text
- No friction for returning users
- Can change language anytime in settings
