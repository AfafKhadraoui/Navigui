import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/auth/auth_repo_abstract.dart';
import '../../../data/models/student_model.dart';
import '../../../data/models/employer_model.dart';
import 'auth_state.dart';

/// AuthCubit - Manages authentication state using BLoC pattern
/// Coordinates with AuthRepository for data operations
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());

  /// Login with email and password
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());
      final user = await _authRepository.login(email, password);
      await _authRepository.updateLastLogin(user.id);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Signup new user
  Future<void> signup({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    required String location,
    required String accountType,
    String? profilePicture,
  }) async {
    try {
      emit(AuthLoading());
      final user = await _authRepository.signup(
        email: email,
        password: password,
        name: name,
        phoneNumber: phoneNumber,
        location: location,
        accountType: accountType,
        profilePicture: profilePicture,
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Create student profile after signup
  Future<StudentModel?> createStudentProfile({
    required String userId,
    required String university,
    required String faculty,
    required String major,
    required String yearOfStudy,
    String? bio,
    List<String>? skills,
    String? availability,
    String? websiteUrl,
    List<String>? portfolio,
  }) async {
    try {
      final profile = await _authRepository.createStudentProfile(
        userId: userId,
        university: university,
        faculty: faculty,
        major: major,
        yearOfStudy: yearOfStudy,
        bio: bio,
        skills: skills,
        availability: availability,
        websiteUrl: websiteUrl,
        portfolio: portfolio,
      );
      return profile;
    } catch (e) {
      emit(AuthError(e.toString()));
      return null;
    }
  }

  /// Create employer profile after signup
  Future<EmployerModel?> createEmployerProfile({
    required String userId,
    required String businessName,
    required String businessType,
    required String industry,
    String? description,
    String? address,
    String? logo,
  }) async {
    try {
      final profile = await _authRepository.createEmployerProfile(
        userId: userId,
        businessName: businessName,
        businessType: businessType,
        industry: industry,
        description: description,
        address: address,
        logo: logo,
      );
      return profile;
    } catch (e) {
      emit(AuthError(e.toString()));
      return null;
    }
  }

  /// Logout current user
  Future<void> logout() async {
    try {
      await _authRepository.logout();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Check authentication status on app start
  Future<void> checkAuthStatus() async {
    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  /// Request password reset
  Future<void> requestPasswordReset(String email) async {
    try {
      emit(AuthLoading());
      await _authRepository.requestPasswordReset(email);
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Reset password with token
  Future<void> resetPassword(String token, String newPassword) async {
    try {
      emit(AuthLoading());
      await _authRepository.resetPassword(token, newPassword);
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Verify email with token
  Future<void> verifyEmail(String token) async {
    try {
      await _authRepository.verifyEmail(token);
      // Refresh user data after verification
      await checkAuthStatus();
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
