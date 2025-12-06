/// Form validation utilities for Navigui app
/// 
/// This file contains reusable validators for all forms across the app.
/// All validators return null if valid, or an error message string if invalid.
/// 
/// Security: Includes SQL injection and XSS prevention patterns.
library;

import 'package:flutter/services.dart';

/// Centralized validation utilities for all forms in the app
class FormValidators {
  // Private constructor to prevent instantiation
  FormValidators._();

  // ============================================================================
  // SQL INJECTION & XSS PREVENTION
  // ============================================================================

  /// Detects common SQL injection patterns
  /// 
  /// Returns true if suspicious patterns are found
  static bool _containsSQLInjection(String input) {
    final sqlPatterns = [
      r"('|(\-\-)|;|(\/\*)|(\\*\/))", // SQL comment patterns
      r'(\b(SELECT|INSERT|UPDATE|DELETE|DROP|CREATE|ALTER|EXEC|EXECUTE|UNION|SCRIPT)\b)', // SQL keywords
      r"(\bOR\b.*=.*)", // OR 1=1 patterns
      r"(\bAND\b.*=.*)", // AND 1=1 patterns
    ];

    for (var pattern in sqlPatterns) {
      if (RegExp(pattern, caseSensitive: false).hasMatch(input)) {
        return true;
      }
    }

    return false;
  }

  /// Detects XSS (Cross-Site Scripting) attempts
  /// 
  /// Returns true if suspicious patterns are found
  static bool _containsXSS(String input) {
    final xssPatterns = [
      r'<script',
      r'<iframe',
      r'javascript:',
      r'onerror=',
      r'onclick=',
      r'onload=',
      r'<object',
      r'<embed',
    ];

    for (var pattern in xssPatterns) {
      if (RegExp(pattern, caseSensitive: false).hasMatch(input)) {
        return true;
      }
    }

    return false;
  }

  // ============================================================================
  // EMAIL VALIDATION
  // ============================================================================

  /// Validates email address format
  /// 
  /// Returns null if valid, error message if invalid
  /// 
  /// Example:
  /// ```dart
  /// TextFormField(
  ///   validator: FormValidators.validateEmail,
  /// )
  /// ```
  static String? validateEmail(String? value, {String? fieldName}) {
    final field = fieldName ?? 'Email';

    if (value == null || value.isEmpty) {
      return 'Please enter your ${field.toLowerCase()}';
    }

    // Check for SQL injection
    if (_containsSQLInjection(value)) {
      return 'Invalid characters detected';
    }

    // Basic email regex
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    // Length check
    if (value.length > 254) {
      return 'Email is too long';
    }

    return null;
  }

  /// Validates email with custom error message
  static String? validateEmailRequired(String? value) {
    return validateEmail(value);
  }

  /// Validates optional email (can be empty)
  static String? validateEmailOptional(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    return validateEmail(value);
  }

  // ============================================================================
  // PASSWORD VALIDATION
  // ============================================================================

  /// Validates password with minimum length
  /// 
  /// Default minimum: 6 characters
  /// 
  /// Example:
  /// ```dart
  /// TextFormField(
  ///   validator: (value) => FormValidators.validatePassword(value, minLength: 8),
  /// )
  /// ```
  static String? validatePassword(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    if (value.length < minLength) {
      return 'Password must be at least $minLength characters long';
    }

    return null;
  }

  /// Validates strong password (8+ chars, uppercase, lowercase, number)
  static String? validateStrongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  /// Validates password confirmation matches
  /// 
  /// Example:
  /// ```dart
  /// TextFormField(
  ///   validator: (value) => FormValidators.validatePasswordConfirm(
  ///     value, 
  ///     _passwordController.text
  ///   ),
  /// )
  /// ```
  static String? validatePasswordConfirm(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  // ============================================================================
  // PHONE NUMBER VALIDATION
  // ============================================================================

  /// Validates Algerian phone number
  /// 
  /// Accepts formats:
  /// - +213 555 123 456
  /// - +213555123456
  /// - 0555123456
  /// - 0555 12 34 56
  /// 
  /// Example:
  /// ```dart
  /// TextFormField(
  ///   validator: FormValidators.validatePhoneAlgeria,
  /// )
  /// ```
  static String? validatePhoneAlgeria(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }

    // Check for SQL injection
    if (_containsSQLInjection(value)) {
      return 'Invalid characters detected';
    }

    // Remove spaces, hyphens, parentheses for validation
    String cleanPhone = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // Algerian phone format: +213 or 0, followed by 5-7 (mobile), then 8 digits
    if (!RegExp(r'^(\+213|0)[5-7][0-9]{8}$').hasMatch(cleanPhone)) {
      return 'Invalid phone format. Use +213 xxx xxx xxx or 0x xx xx xx xx';
    }

    return null;
  }

  /// Validates international phone number (basic)
  static String? validatePhoneInternational(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }

    if (_containsSQLInjection(value)) {
      return 'Invalid characters detected';
    }

    String cleanPhone = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // Basic international format: + followed by 7-15 digits
    if (!RegExp(r'^\+?[0-9]{7,15}$').hasMatch(cleanPhone)) {
      return 'Invalid phone number format';
    }

    return null;
  }

  // ============================================================================
  // NAME VALIDATION
  // ============================================================================

  /// Validates person name (first/last name)
  /// 
  /// Allows: letters, spaces, apostrophes, hyphens
  /// 
  /// Example:
  /// ```dart
  /// TextFormField(
  ///   validator: (value) => FormValidators.validateName(value, 'First name'),
  /// )
  /// ```
  static String? validateName(String? value, {String fieldName = 'Name', int minLength = 2, int maxLength = 50}) {
    if (value == null || value.isEmpty) {
      return 'Please enter your ${fieldName.toLowerCase()}';
    }

    // Check for SQL injection
    if (_containsSQLInjection(value)) {
      return 'Invalid characters detected';
    }

    // Allow letters, spaces, apostrophes, hyphens (for names like O'Brien, Mary-Jane)
    if (!RegExp(r"^[a-zA-ZÀ-ÿ\s'\-]+$").hasMatch(value)) {
      return '$fieldName can only contain letters, spaces, apostrophes, and hyphens';
    }

    // Length validation
    if (value.trim().length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }

    if (value.length > maxLength) {
      return '$fieldName is too long (max $maxLength characters)';
    }

    return null;
  }

  /// Validates business/company name
  /// 
  /// Allows: letters, numbers, spaces, dots, apostrophes, hyphens, ampersands
  static String? validateBusinessName(String? value, {String fieldName = 'Business name'}) {
    if (value == null || value.isEmpty) {
      return 'Please enter your ${fieldName.toLowerCase()}';
    }

    // Check for SQL injection
    if (_containsSQLInjection(value)) {
      return 'Invalid characters detected';
    }

    // Allow letters, numbers, spaces, dots, apostrophes, hyphens, ampersands
    // (for names like "John's Shop", "Tech & Co.", "Company Inc.")
    if (!RegExp(r"^[a-zA-Z0-9À-ÿ\s.,'&\-]+$").hasMatch(value)) {
      return '$fieldName contains invalid characters';
    }

    // Length validation
    if (value.trim().length < 2) {
      return '$fieldName must be at least 2 characters';
    }

    if (value.length > 100) {
      return '$fieldName is too long (max 100 characters)';
    }

    // No excessive consecutive special characters
    if (RegExp(r'[.\-&\s]{3,}').hasMatch(value)) {
      return 'Too many consecutive special characters';
    }

    return null;
  }

  // ============================================================================
  // TEXT FIELD VALIDATION
  // ============================================================================

  /// Validates general text field with length constraints
  /// 
  /// Example:
  /// ```dart
  /// TextFormField(
  ///   validator: (value) => FormValidators.validateTextField(
  ///     value,
  ///     fieldName: 'Job title',
  ///     minLength: 3,
  ///     maxLength: 100,
  ///   ),
  /// )
  /// ```
  static String? validateTextField(
    String? value, {
    required String fieldName,
    int minLength = 1,
    int maxLength = 255,
    bool allowEmpty = false,
  }) {
    if (value == null || value.isEmpty) {
      if (allowEmpty) {
        return null;
      }
      return 'Please enter $fieldName';
    }

    // Check for SQL injection
    if (_containsSQLInjection(value)) {
      return 'Invalid characters detected';
    }

    // Check for dangerous special characters
    if (RegExp(r'[<>{}\\[\]]').hasMatch(value)) {
      return '$fieldName contains invalid characters';
    }

    // Length validation
    if (value.trim().length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }

    if (value.length > maxLength) {
      return '$fieldName is too long (max $maxLength characters)';
    }

    return null;
  }

  // ============================================================================
  // LOCATION VALIDATION
  // ============================================================================

  /// Validates location/address field
  static String? validateLocation(String? value, {String fieldName = 'Location'}) {
    if (value == null || value.isEmpty) {
      return 'Please enter your ${fieldName.toLowerCase()}';
    }

    // Check for SQL injection
    if (_containsSQLInjection(value)) {
      return 'Invalid characters detected';
    }

    // Check for dangerous special characters
    if (RegExp(r'[<>{}\\[\]]').hasMatch(value)) {
      return '$fieldName contains invalid characters';
    }

    // Length validation
    if (value.trim().length < 3) {
      return '$fieldName must be at least 3 characters';
    }

    if (value.length > 200) {
      return '$fieldName is too long (max 200 characters)';
    }

    return null;
  }

  // ============================================================================
  // DESCRIPTION/BIO VALIDATION
  // ============================================================================

  /// Validates description or bio field (optional)
  /// 
  /// Includes XSS prevention
  static String? validateDescription(
    String? value, {
    String fieldName = 'Description',
    int minLength = 10,
    int maxLength = 500,
    bool required = false,
  }) {
    // Optional field - can be empty
    if (value == null || value.isEmpty) {
      if (required) {
        return 'Please enter $fieldName';
      }
      return null;
    }

    // Check for SQL injection
    if (_containsSQLInjection(value)) {
      return 'Invalid characters detected';
    }

    // Block XSS attempts
    if (_containsXSS(value)) {
      return '$fieldName contains forbidden content';
    }

    // Length validation
    if (value.trim().length < minLength) {
      return '$fieldName should be at least $minLength characters';
    }

    if (value.length > maxLength) {
      return '$fieldName is too long (max $maxLength characters)';
    }

    return null;
  }

  // ============================================================================
  // NUMERIC VALIDATION
  // ============================================================================

  /// Validates integer number
  static String? validateInteger(
    String? value, {
    required String fieldName,
    int? min,
    int? max,
  }) {
    if (value == null || value.isEmpty) {
      return 'Please enter $fieldName';
    }

    final number = int.tryParse(value);
    if (number == null) {
      return '$fieldName must be a valid number';
    }

    if (min != null && number < min) {
      return '$fieldName must be at least $min';
    }

    if (max != null && number > max) {
      return '$fieldName must be at most $max';
    }

    return null;
  }

  /// Validates decimal number
  static String? validateDecimal(
    String? value, {
    required String fieldName,
    double? min,
    double? max,
  }) {
    if (value == null || value.isEmpty) {
      return 'Please enter $fieldName';
    }

    final number = double.tryParse(value);
    if (number == null) {
      return '$fieldName must be a valid number';
    }

    if (min != null && number < min) {
      return '$fieldName must be at least $min';
    }

    if (max != null && number > max) {
      return '$fieldName must be at most $max';
    }

    return null;
  }

  /// Validates positive integer (e.g., age, quantity)
  static String? validatePositiveInteger(String? value, {required String fieldName}) {
    return validateInteger(value, fieldName: fieldName, min: 1);
  }

  // ============================================================================
  // URL VALIDATION
  // ============================================================================

  /// Validates URL format
  static String? validateUrl(String? value, {String fieldName = 'URL', bool required = true}) {
    if (value == null || value.isEmpty) {
      if (required) {
        return 'Please enter $fieldName';
      }
      return null;
    }

    // Check for SQL injection
    if (_containsSQLInjection(value)) {
      return 'Invalid characters detected';
    }

    // Basic URL validation
    final urlRegex = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
      caseSensitive: false,
    );

    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }

    return null;
  }

  // ============================================================================
  // DATE VALIDATION
  // ============================================================================

  /// Validates date is not in the future
  static String? validatePastDate(DateTime? value, {String fieldName = 'Date'}) {
    if (value == null) {
      return 'Please select $fieldName';
    }

    if (value.isAfter(DateTime.now())) {
      return '$fieldName cannot be in the future';
    }

    return null;
  }

  /// Validates date is in the future
  static String? validateFutureDate(DateTime? value, {String fieldName = 'Date'}) {
    if (value == null) {
      return 'Please select $fieldName';
    }

    if (value.isBefore(DateTime.now())) {
      return '$fieldName must be in the future';
    }

    return null;
  }

  // ============================================================================
  // DROPDOWN VALIDATION
  // ============================================================================

  /// Validates dropdown selection
  /// 
  /// Example:
  /// ```dart
  /// if (_selectedType == null) {
  ///   showSnackBar(FormValidators.validateDropdown(_selectedType, 'Type'));
  /// }
  /// ```
  static String? validateDropdown(dynamic value, String fieldName) {
    if (value == null) {
      return 'Please select $fieldName';
    }
    return null;
  }

  /// Validates dropdown with list of valid options
  static String? validateDropdownWithOptions(
    String? value,
    List<String> validOptions,
    String fieldName,
  ) {
    if (value == null || value.isEmpty) {
      return 'Please select $fieldName';
    }

    if (!validOptions.contains(value)) {
      return 'Invalid $fieldName selected';
    }

    return null;
  }

  // ============================================================================
  // INPUT FORMATTERS (for TextField inputFormatters property)
  // ============================================================================

  /// Allows only letters and spaces
  static final lettersOnly = FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'));

  /// Allows only numbers
  static final numbersOnly = FilteringTextInputFormatter.digitsOnly;

  /// Allows letters, numbers, and spaces
  static final alphanumeric = FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]'));

  /// Allows phone number characters (digits, +, -, space, parentheses)
  static final phoneCharacters = FilteringTextInputFormatter.allow(RegExp(r'[0-9\+\-\s\(\)]'));

  /// Blocks special characters that could be used for injection
  static final noSpecialCharacters = FilteringTextInputFormatter.deny(RegExp(r'[<>{}\\[\];\"=]'));

  }
