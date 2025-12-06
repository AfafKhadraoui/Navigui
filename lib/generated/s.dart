import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 's_ar.dart';
import 's_en.dart';
import 's_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/s.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S? of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr')
  ];

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'Navigui'**
  String get appName;

  /// Application tagline
  ///
  /// In en, this message translates to:
  /// **'Your Gateway to Part-Time Jobs'**
  String get appTagline;

  /// Short app description
  ///
  /// In en, this message translates to:
  /// **'Connect Algerian students with part-time jobs and quick tasks'**
  String get appDescription;

  /// Generic welcome greeting
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get commonWelcome;

  /// Welcome message for returning users
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get commonWelcomeBack;

  /// No description provided for @commonGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get commonGetStarted;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get commonPrevious;

  /// No description provided for @commonSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get commonSkip;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get commonUpdate;

  /// No description provided for @commonSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get commonSubmit;

  /// No description provided for @commonApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get commonApply;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @commonYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get commonNo;

  /// No description provided for @commonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get commonLoading;

  /// No description provided for @commonPleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get commonPleaseWait;

  /// No description provided for @commonError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get commonError;

  /// No description provided for @commonSuccess.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get commonSuccess;

  /// No description provided for @commonWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get commonWarning;

  /// No description provided for @commonInfo.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get commonInfo;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome TO\nNavigui'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingFindWorkTitle.
  ///
  /// In en, this message translates to:
  /// **'Find Work That Fits\nYour Schedule'**
  String get onboardingFindWorkTitle;

  /// No description provided for @onboardingAccessStudentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Access ambitious\nStudents'**
  String get onboardingAccessStudentsTitle;

  /// No description provided for @onboardingReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready To Start\nEarning And Hiring?'**
  String get onboardingReadyTitle;

  /// No description provided for @onboardingSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get onboardingSignIn;

  /// No description provided for @onboardingSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get onboardingSignUp;

  /// No description provided for @commonNoData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get commonNoData;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get commonRefresh;

  /// No description provided for @commonSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get commonSearch;

  /// No description provided for @commonFilter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get commonFilter;

  /// No description provided for @commonSort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get commonSort;

  /// No description provided for @commonViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get commonViewAll;

  /// No description provided for @commonShowMore.
  ///
  /// In en, this message translates to:
  /// **'Show More'**
  String get commonShowMore;

  /// No description provided for @commonShowLess.
  ///
  /// In en, this message translates to:
  /// **'Show Less'**
  String get commonShowLess;

  /// No description provided for @commonRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get commonRequired;

  /// No description provided for @commonOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get commonOptional;

  /// No description provided for @commonLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get commonLanguage;

  /// No description provided for @commonSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get commonSettings;

  /// No description provided for @commonLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get commonLogout;

  /// No description provided for @commonSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get commonSeeAll;

  /// No description provided for @commonNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get commonNotAvailable;

  /// No description provided for @learnPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Learn & Grow'**
  String get learnPageTitle;

  /// No description provided for @learnNewToJobHunting.
  ///
  /// In en, this message translates to:
  /// **'New to Job Hunting'**
  String get learnNewToJobHunting;

  /// No description provided for @learnForStudents.
  ///
  /// In en, this message translates to:
  /// **'For Students'**
  String get learnForStudents;

  /// No description provided for @learnForEmployers.
  ///
  /// In en, this message translates to:
  /// **'For Employers'**
  String get learnForEmployers;

  /// No description provided for @learnViewAll.
  ///
  /// In en, this message translates to:
  /// **'view all'**
  String get learnViewAll;

  /// No description provided for @learnCompleteGuide.
  ///
  /// In en, this message translates to:
  /// **'complete guide'**
  String get learnCompleteGuide;

  /// No description provided for @learnReadNow.
  ///
  /// In en, this message translates to:
  /// **'Read Now'**
  String get learnReadNow;

  /// No description provided for @learnMinRead.
  ///
  /// In en, this message translates to:
  /// **'min read'**
  String get learnMinRead;

  /// No description provided for @learnErrorLoadingArticles.
  ///
  /// In en, this message translates to:
  /// **'Error loading articles'**
  String get learnErrorLoadingArticles;

  /// No description provided for @learnFailedToLoadArticles.
  ///
  /// In en, this message translates to:
  /// **'Failed to load articles'**
  String get learnFailedToLoadArticles;

  /// No description provided for @learnNoStudentArticles.
  ///
  /// In en, this message translates to:
  /// **'No student articles available'**
  String get learnNoStudentArticles;

  /// No description provided for @learnNoEmployerArticles.
  ///
  /// In en, this message translates to:
  /// **'No employer articles available'**
  String get learnNoEmployerArticles;

  /// No description provided for @learnAllStudentArticles.
  ///
  /// In en, this message translates to:
  /// **'All Student Articles'**
  String get learnAllStudentArticles;

  /// No description provided for @learnAllEmployerArticles.
  ///
  /// In en, this message translates to:
  /// **'All Employer Articles'**
  String get learnAllEmployerArticles;

  /// No description provided for @learnFirstTimeJobSeekers.
  ///
  /// In en, this message translates to:
  /// **'First-Time Job Seekers'**
  String get learnFirstTimeJobSeekers;

  /// No description provided for @learnFirstTimeDescription.
  ///
  /// In en, this message translates to:
  /// **'Everything you need to write winning  applications and ace your interviews'**
  String get learnFirstTimeDescription;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navBrowse.
  ///
  /// In en, this message translates to:
  /// **'Browse'**
  String get navBrowse;

  /// No description provided for @navMyTasks.
  ///
  /// In en, this message translates to:
  /// **'My Tasks'**
  String get navMyTasks;

  /// No description provided for @navLearn.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get navLearn;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @navMyJobs.
  ///
  /// In en, this message translates to:
  /// **'My Jobs'**
  String get navMyJobs;

  /// No description provided for @navApplications.
  ///
  /// In en, this message translates to:
  /// **'Applications'**
  String get navApplications;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navUsers.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get navUsers;

  /// No description provided for @navJobs.
  ///
  /// In en, this message translates to:
  /// **'Jobs'**
  String get navJobs;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return SAr();
    case 'en':
      return SEn();
    case 'fr':
      return SFr();
  }

  throw FlutterError(
      'S.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
