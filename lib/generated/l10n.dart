// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Navigui`
  String get appName {
    return Intl.message(
      'Navigui',
      name: 'appName',
      desc: 'Application name',
      args: [],
    );
  }

  /// `Your Gateway to Part-Time Jobs`
  String get appTagline {
    return Intl.message(
      'Your Gateway to Part-Time Jobs',
      name: 'appTagline',
      desc: 'Application tagline',
      args: [],
    );
  }

  /// `Connect Algerian students with part-time jobs and quick tasks`
  String get appDescription {
    return Intl.message(
      'Connect Algerian students with part-time jobs and quick tasks',
      name: 'appDescription',
      desc: 'Short app description',
      args: [],
    );
  }

  /// `Welcome`
  String get commonWelcome {
    return Intl.message(
      'Welcome',
      name: 'commonWelcome',
      desc: 'Generic welcome greeting',
      args: [],
    );
  }

  /// `Welcome back!`
  String get commonWelcomeBack {
    return Intl.message(
      'Welcome back!',
      name: 'commonWelcomeBack',
      desc: 'Welcome message for returning users',
      args: [],
    );
  }

  /// `Get Started`
  String get commonGetStarted {
    return Intl.message(
      'Get Started',
      name: 'commonGetStarted',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get commonContinue {
    return Intl.message('Continue', name: 'commonContinue', desc: '', args: []);
  }

  /// `Next`
  String get commonNext {
    return Intl.message('Next', name: 'commonNext', desc: '', args: []);
  }

  /// `Previous`
  String get commonPrevious {
    return Intl.message('Previous', name: 'commonPrevious', desc: '', args: []);
  }

  /// `Skip`
  String get commonSkip {
    return Intl.message('Skip', name: 'commonSkip', desc: '', args: []);
  }

  /// `Done`
  String get commonDone {
    return Intl.message('Done', name: 'commonDone', desc: '', args: []);
  }

  /// `Save`
  String get commonSave {
    return Intl.message('Save', name: 'commonSave', desc: '', args: []);
  }

  /// `Cancel`
  String get commonCancel {
    return Intl.message('Cancel', name: 'commonCancel', desc: '', args: []);
  }

  /// `Delete`
  String get commonDelete {
    return Intl.message('Delete', name: 'commonDelete', desc: '', args: []);
  }

  /// `Edit`
  String get commonEdit {
    return Intl.message('Edit', name: 'commonEdit', desc: '', args: []);
  }

  /// `Update`
  String get commonUpdate {
    return Intl.message('Update', name: 'commonUpdate', desc: '', args: []);
  }

  /// `Submit`
  String get commonSubmit {
    return Intl.message('Submit', name: 'commonSubmit', desc: '', args: []);
  }

  /// `Apply`
  String get commonApply {
    return Intl.message('Apply', name: 'commonApply', desc: '', args: []);
  }

  /// `Close`
  String get commonClose {
    return Intl.message('Close', name: 'commonClose', desc: '', args: []);
  }

  /// `Back`
  String get commonBack {
    return Intl.message('Back', name: 'commonBack', desc: '', args: []);
  }

  /// `OK`
  String get commonOk {
    return Intl.message('OK', name: 'commonOk', desc: '', args: []);
  }

  /// `Yes`
  String get commonYes {
    return Intl.message('Yes', name: 'commonYes', desc: '', args: []);
  }

  /// `No`
  String get commonNo {
    return Intl.message('No', name: 'commonNo', desc: '', args: []);
  }

  /// `Confirm`
  String get commonConfirm {
    return Intl.message('Confirm', name: 'commonConfirm', desc: '', args: []);
  }

  /// `Loading...`
  String get commonLoading {
    return Intl.message(
      'Loading...',
      name: 'commonLoading',
      desc: '',
      args: [],
    );
  }

  /// `Please wait...`
  String get commonPleaseWait {
    return Intl.message(
      'Please wait...',
      name: 'commonPleaseWait',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get commonError {
    return Intl.message('Error', name: 'commonError', desc: '', args: []);
  }

  /// `Success`
  String get commonSuccess {
    return Intl.message('Success', name: 'commonSuccess', desc: '', args: []);
  }

  /// `Warning`
  String get commonWarning {
    return Intl.message('Warning', name: 'commonWarning', desc: '', args: []);
  }

  /// `Information`
  String get commonInfo {
    return Intl.message('Information', name: 'commonInfo', desc: '', args: []);
  }

  /// `Welcome TO\nNavigui`
  String get onboardingWelcomeTitle {
    return Intl.message(
      'Welcome TO\nNavigui',
      name: 'onboardingWelcomeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Find Work That Fits\nYour Schedule`
  String get onboardingFindWorkTitle {
    return Intl.message(
      'Find Work That Fits\nYour Schedule',
      name: 'onboardingFindWorkTitle',
      desc: '',
      args: [],
    );
  }

  /// `Access ambitious\nStudents`
  String get onboardingAccessStudentsTitle {
    return Intl.message(
      'Access ambitious\nStudents',
      name: 'onboardingAccessStudentsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Ready To Start\nEarning And Hiring?`
  String get onboardingReadyTitle {
    return Intl.message(
      'Ready To Start\nEarning And Hiring?',
      name: 'onboardingReadyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get onboardingSignIn {
    return Intl.message(
      'Sign in',
      name: 'onboardingSignIn',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get onboardingSignUp {
    return Intl.message(
      'Sign up',
      name: 'onboardingSignUp',
      desc: '',
      args: [],
    );
  }

  /// `No data available`
  String get commonNoData {
    return Intl.message(
      'No data available',
      name: 'commonNoData',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get commonRetry {
    return Intl.message('Retry', name: 'commonRetry', desc: '', args: []);
  }

  /// `Refresh`
  String get commonRefresh {
    return Intl.message('Refresh', name: 'commonRefresh', desc: '', args: []);
  }

  /// `Search`
  String get commonSearch {
    return Intl.message('Search', name: 'commonSearch', desc: '', args: []);
  }

  /// `Filter`
  String get commonFilter {
    return Intl.message('Filter', name: 'commonFilter', desc: '', args: []);
  }

  /// `Sort`
  String get commonSort {
    return Intl.message('Sort', name: 'commonSort', desc: '', args: []);
  }

  /// `View All`
  String get commonViewAll {
    return Intl.message('View All', name: 'commonViewAll', desc: '', args: []);
  }

  /// `Show More`
  String get commonShowMore {
    return Intl.message(
      'Show More',
      name: 'commonShowMore',
      desc: '',
      args: [],
    );
  }

  /// `Show Less`
  String get commonShowLess {
    return Intl.message(
      'Show Less',
      name: 'commonShowLess',
      desc: '',
      args: [],
    );
  }

  /// `Required`
  String get commonRequired {
    return Intl.message('Required', name: 'commonRequired', desc: '', args: []);
  }

  /// `Optional`
  String get commonOptional {
    return Intl.message('Optional', name: 'commonOptional', desc: '', args: []);
  }

  /// `Language`
  String get commonLanguage {
    return Intl.message('Language', name: 'commonLanguage', desc: '', args: []);
  }

  /// `Settings`
  String get commonSettings {
    return Intl.message('Settings', name: 'commonSettings', desc: '', args: []);
  }

  /// `Logout`
  String get commonLogout {
    return Intl.message('Logout', name: 'commonLogout', desc: '', args: []);
  }

  /// `See All`
  String get commonSeeAll {
    return Intl.message('See All', name: 'commonSeeAll', desc: '', args: []);
  }

  /// `N/A`
  String get commonNotAvailable {
    return Intl.message('N/A', name: 'commonNotAvailable', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
