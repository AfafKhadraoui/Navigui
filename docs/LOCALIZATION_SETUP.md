# 🌍 Localization Structure - Implementation Guide

## ⚠️ Important: Flutter l10n Limitation

**Flutter's official `gen-l10n` tool does NOT support subdirectories for ARB files.**

The tool expects all ARB files to be in a **single flat directory** (e.g., `lib/l10n/`), not organized into subdirectories like `lib/l10n/en/`, `lib/l10n/ar/`, etc.

## 📁 Current Structure Created

I've created an **organized structure** with separate files by feature:

```
lib/l10n/
├── en/
│   ├── common_en.arb       ✅ Created (58 keys)
│   ├── auth_en.arb         ✅ Created (34 keys)
│   ├── jobs_en.arb         ✅ Created (62 keys)
│   ├── profile_en.arb      ✅ Created (32 keys)
│   ├── applications_en.arb ✅ Created (34 keys)
│   ├── notifications_en.arb✅ Created (14 keys)
│   ├── search_en.arb       ✅ Created (24 keys)
│   ├── reviews_en.arb      ✅ Created (20 keys)
│   ├── education_en.arb    ✅ Created (7 keys)
│   ├── admin_en.arb        ✅ Created (28 keys)
│   └── errors_en.arb       ✅ Created (23 keys)
├── ar/
│   └── [11 placeholder files] 🔄 To be translated
└── fr/
    └── [11 placeholder files] 🔄 To be translated
```

**Total: 336+ translation keys organized by feature!**

## 🎯 Two Implementation Options

### **Option 1: Keep Organized Structure (RECOMMENDED for large projects)**

**Pros:**
- ✅ Clean organization by feature
- ✅ Easy to maintain and find translations
- ✅ Team can work on different files simultaneously
- ✅ Clear separation of concerns

**Cons:**
- ❌ Requires manual merging before generation
- ❌ Extra build step needed

**How it works:**
1. Keep your organized structure in `lib/l10n/en/`, `lib/l10n/ar/`, `lib/l10n/fr/`
2. Create a build script that merges files for each language
3. Generate merged files: `app_en.arb`, `app_ar.arb`, `app_fr.arb`
4. Run `flutter gen-l10n` on merged files

I'll create this build script for you below.

---

### **Option 2: Use Flat Structure (SIMPLER, but less organized)**

**Pros:**
- ✅ Works with `flutter gen-l10n` out of the box
- ✅ No build script needed
- ✅ Simpler workflow

**Cons:**
- ❌ All translations in one huge file per language
- ❌ Harder to navigate (300+ keys in one file)
- ❌ Merge conflicts when multiple people edit
- ❌ Difficult to find specific translations

**Structure:**
```
lib/l10n/
├── app_en.arb  (all 336+ keys)
├── app_ar.arb  (all 336+ keys)
└── app_fr.arb  (all 336+ keys)
```

---

## 🚀 Recommended Solution: Build Script for Merging

Let me create a PowerShell script that merges your organized files:

### File: `scripts/merge_l10n.ps1`

```powershell
# Merge organized ARB files into single files for flutter gen-l10n
$languages = @("en", "ar", "fr")

foreach ($lang in $languages) {
    Write-Host "Merging $lang translations..."
    
    $outputFile = "lib\l10n\app_$lang.arb"
    $sourceDir = "lib\l10n\$lang"
    
    # Start with metadata
    $merged = @{
        "@@locale" = $lang
        "@@last_modified" = (Get-Date -Format "yyyy-MM-dd")
        "@@generated_from" = "Merged from organized structure"
    }
    
    # Get all ARB files in order
    $files = @(
        "common_$lang.arb",
        "auth_$lang.arb",
        "jobs_$lang.arb",
        "profile_$lang.arb",
        "applications_$lang.arb",
        "notifications_$lang.arb",
        "search_$lang.arb",
        "reviews_$lang.arb",
        "education_$lang.arb",
        "admin_$lang.arb",
        "errors_$lang.arb"
    )
    
    foreach ($file in $files) {
        $filePath = Join-Path $sourceDir $file
        if (Test-Path $filePath) {
            $content = Get-Content $filePath -Raw | ConvertFrom-Json
            
            # Merge all properties except metadata
            $content.PSObject.Properties | Where-Object { 
                $_.Name -notlike "@@*" 
            } | ForEach-Object {
                $merged[$_.Name] = $_.Value
            }
        }
    }
    
    # Write merged file
    $merged | ConvertTo-Json -Depth 10 | Set-Content $outputFile -Encoding UTF8
    Write-Host "✓ Created $outputFile"
}

Write-Host "`n✅ All translations merged successfully!"
Write-Host "Now run: flutter gen-l10n"
```

### Usage:

```powershell
# Run from project root
.\scripts\merge_l10n.ps1

# Then generate localizations
flutter gen-l10n
```

---

## 📋 Step-by-Step Setup Guide

### Step 1: Update `pubspec.yaml`

Add flutter_localizations and enable generation:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: any

flutter:
  generate: true  # Enable code generation
```

### Step 2: Create `l10n.yaml` in project root

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-dir: lib/generated/l10n
output-localization-file: app_localizations.dart
output-class: AppLocalizations
preferred-supported-locales:
  - en
synthetic-package: false
nullable-getter: true
```

### Step 3: Choose Your Workflow

**Option A: Use organized structure with merge script**
1. Keep editing files in `lib/l10n/en/`, `lib/l10n/ar/`, etc.
2. Run `.\scripts\merge_l10n.ps1` before building
3. Run `flutter pub get` to generate code

**Option B: Use flat structure**
1. Manually merge all `lib/l10n/en/*.arb` into `lib/l10n/app_en.arb`
2. Manually merge all `lib/l10n/ar/*.arb` into `lib/l10n/app_ar.arb`
3. Manually merge all `lib/l10n/fr/*.arb` into `lib/l10n/app_fr.arb`
4. Run `flutter pub get` to generate code

### Step 4: Update `main.dart`

```dart
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Add localization delegates
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      
      // Supported languages
      supportedLocales: const [
        Locale('en'), // English
        Locale('ar'), // Arabic
        Locale('fr'), // French
      ],
      
      // Default locale
      locale: const Locale('en'),
      
      home: HomeScreen(),
    );
  }
}
```

### Step 5: Use translations in code

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// In your widget:
Text(AppLocalizations.of(context)!.commonWelcome)

// With parameters:
Text(AppLocalizations.of(context)!.jobSalaryRange('10,000', '20,000'))
```

---

## 🎨 Current Translation Status

### English (en) - ✅ COMPLETE
- **common_en.arb**: 58 keys (buttons, labels, general UI)
- **auth_en.arb**: 34 keys (login, signup, onboarding)
- **jobs_en.arb**: 62 keys (job listings, details, categories)
- **profile_en.arb**: 32 keys (student & employer profiles)
- **applications_en.arb**: 34 keys (application management)
- **notifications_en.arb**: 14 keys (notification system)
- **search_en.arb**: 24 keys (search & filters)
- **reviews_en.arb**: 20 keys (reviews & saved jobs)
- **education_en.arb**: 7 keys (educational resources)
- **admin_en.arb**: 28 keys (admin panel & employer features)
- **errors_en.arb**: 23 keys (errors, validation, timestamps)

**Total: 336+ translation keys**

### Arabic (ar) - 🔄 PLACEHOLDER
All 11 files created with metadata only. Ready for translation.

### French (fr) - 🔄 PLACEHOLDER
All 11 files created with metadata only. Ready for translation.

---

## 📝 Translation Workflow

### For Translators:

1. **Open English reference file** (e.g., `lib/l10n/en/common_en.arb`)
2. **Open corresponding language file** (e.g., `lib/l10n/ar/common_ar.arb`)
3. **Copy EXACT keys** from English file (don't change key names!)
4. **Translate only the values**, keeping keys identical
5. **Keep @ metadata blocks** (descriptions help with context)

### Example:

**English (`common_en.arb`):**
```json
{
  "commonWelcome": "Welcome",
  "@commonWelcome": {
    "description": "Generic welcome greeting"
  }
}
```

**Arabic (`common_ar.arb`):**
```json
{
  "commonWelcome": "مرحبا",
  "@commonWelcome": {
    "description": "Generic welcome greeting"
  }
}
```

**French (`common_fr.arb`):**
```json
{
  "commonWelcome": "Bienvenue",
  "@commonWelcome": {
    "description": "Generic welcome greeting"
  }
}
```

---

## 🔧 Troubleshooting

### Issue: `AppLocalizations not found`
**Solution:** 
```bash
flutter clean
flutter pub get
```

### Issue: Translations not updating
**Solution:**
```bash
.\scripts\merge_l10n.ps1  # If using organized structure
flutter pub get
```

### Issue: RTL not working for Arabic
**Solution:** 
Ensure your MaterialApp has proper Bidi support:
```dart
MaterialApp(
  locale: Locale('ar'),
  // Flutter automatically handles RTL for Arabic
)
```

---

## 📞 Next Steps

1. **Choose your workflow** (organized with script OR flat structure)
2. **Update `pubspec.yaml`** with flutter_localizations
3. **Create `l10n.yaml`** configuration file
4. **If using organized structure**: Create `scripts/merge_l10n.ps1`
5. **Run generation**: `flutter pub get`
6. **Update `main.dart`** with localization support
7. **Start translating** Arabic and French files when ready

---

**Created**: December 4, 2025  
**Structure**: 11 files × 3 languages = 33 ARB files  
**Total Keys**: 336+ translation keys  
**Status**: English complete, Arabic & French awaiting translation
