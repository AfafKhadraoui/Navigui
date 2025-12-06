import 'dart:async';
import 'package:flutter/material.dart';
import 'secure_storage_service.dart';

/// Session Management Service
/// Handles automatic session timeout and logout
class SessionManager {
  final SecureStorageService _secureStorage;
  Timer? _sessionTimer;
  final VoidCallback? onSessionExpired;
  
  // Check session every 1 minute
  static const Duration _checkInterval = Duration(minutes: 1);

  SessionManager({
    SecureStorageService? secureStorage,
    this.onSessionExpired,
  }) : _secureStorage = secureStorage ?? SecureStorageService();

  /// Start monitoring session timeout
  void startSessionMonitoring() {
    // Cancel existing timer if any
    stopSessionMonitoring();

    // Check session immediately
    _checkSession();

    // Start periodic check
    _sessionTimer = Timer.periodic(_checkInterval, (_) {
      _checkSession();
    });

    print('🕐 Session monitoring started');
  }

  /// Stop monitoring session timeout
  void stopSessionMonitoring() {
    _sessionTimer?.cancel();
    _sessionTimer = null;
    print('🕐 Session monitoring stopped');
  }

  /// Check if session has expired
  Future<void> _checkSession() async {
    final isAuthenticated = await _secureStorage.isAuthenticated();
    if (!isAuthenticated) {
      // User not logged in, no need to check
      return;
    }

    final isExpired = await _secureStorage.isSessionExpired();
    if (isExpired) {
      print('⏰ Session expired - logging out');
      await _handleSessionExpired();
    }
  }

  /// Handle session expiration
  Future<void> _handleSessionExpired() async {
    // Clear session data
    await _secureStorage.clearUserSession();
    
    // Stop monitoring
    stopSessionMonitoring();
    
    // Notify callback
    onSessionExpired?.call();
  }

  /// Update last activity (call this on user interaction)
  Future<void> updateActivity() async {
    await _secureStorage.updateLastActivity();
  }

  /// Get remaining session time
  Future<Duration?> getRemainingSessionTime() async {
    final lastActivity = await _secureStorage.getLastActivity();
    if (lastActivity == null) return null;

    final timeout = await _secureStorage.getSessionTimeout();
    final elapsed = DateTime.now().difference(lastActivity);
    final remaining = Duration(minutes: timeout) - elapsed;

    return remaining.isNegative ? Duration.zero : remaining;
  }

  /// Check if session is about to expire (less than 5 minutes remaining)
  Future<bool> isSessionAboutToExpire() async {
    final remaining = await getRemainingSessionTime();
    if (remaining == null) return false;
    
    return remaining.inMinutes < 5 && remaining.inMinutes > 0;
  }

  /// Extend session (reset last activity time)
  Future<void> extendSession() async {
    await _secureStorage.updateLastActivity();
    print('✅ Session extended');
  }

  /// Dispose resources
  void dispose() {
    stopSessionMonitoring();
  }
}
