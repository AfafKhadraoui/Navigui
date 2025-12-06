import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/user/user_repo_abstract.dart';
import 'employer_profile_state.dart';

class EmployerProfileCubit extends Cubit<EmployerProfileState> {
  final UserRepository _userRepository;

  EmployerProfileCubit(this._userRepository) : super(EmployerProfileInitial());

  /// Load employer profile by user ID
  Future<void> loadProfile(String userId) async {
    try {
      emit(EmployerProfileLoading());
      final profile = await _userRepository.getEmployerProfile(userId);
      emit(EmployerProfileLoaded(profile));
    } catch (e) {
      emit(EmployerProfileError(e.toString()));
    }
  }

  /// Update employer profile with provided fields
  Future<void> updateProfile({
    required String userId,
    String? businessName,
    String? businessType,
    String? industry,
    String? description,
    String? location,
    String? address,
    String? logo,
    String? websiteUrl,
    String? verificationDocumentUrl,
    List<String>? socialMediaLinks,
    Map<String, dynamic>? contactInfo,
  }) async {
    try {
      emit(EmployerProfileLoading());
      final updatedProfile = await _userRepository.updateEmployerProfile(
        userId: userId,
        businessName: businessName,
        businessType: businessType,
        industry: industry,
        description: description,
        location: location,
        address: address,
        logo: logo,
        websiteUrl: websiteUrl,
        verificationDocumentUrl: verificationDocumentUrl,
        socialMediaLinks: socialMediaLinks,
        contactInfo: contactInfo,
      );
      emit(EmployerProfileUpdated(updatedProfile));
      // Also emit loaded state to show updated profile
      emit(EmployerProfileLoaded(updatedProfile));
    } catch (e) {
      emit(EmployerProfileError(e.toString()));
    }
  }

  /// Refresh profile (reload from repository)
  Future<void> refreshProfile(String userId) async {
    await loadProfile(userId);
  }
}
