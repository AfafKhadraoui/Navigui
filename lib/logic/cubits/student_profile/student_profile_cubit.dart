import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/user/user_repo_abstract.dart';
import 'student_profile_state.dart';

class StudentProfileCubit extends Cubit<StudentProfileState> {
  final UserRepository _userRepository;

  StudentProfileCubit(this._userRepository) : super(StudentProfileInitial());

  /// Load student profile by user ID
  Future<void> loadProfile(String userId) async {
    try {
      emit(StudentProfileLoading());
      final profile = await _userRepository.getStudentProfile(userId);
      emit(StudentProfileLoaded(profile));
    } catch (e) {
      emit(StudentProfileError(e.toString()));
    }
  }

  /// Update student profile with provided fields
  Future<void> updateProfile({
    required String userId,
    String? university,
    String? faculty,
    String? major,
    String? yearOfStudy,
    String? bio,
    String? cvUrl,
    List<String>? skills,
    List<String>? languages,
    String? availability,
    String? transportation,
    String? previousExperience,
    String? websiteUrl,
    List<String>? socialMediaLinks,
    List<String>? portfolio,
    bool? isPhonePublic,
    String? profileVisibility,
  }) async {
    try {
      emit(StudentProfileLoading());
      final updatedProfile = await _userRepository.updateStudentProfile(
        userId: userId,
        university: university,
        faculty: faculty,
        major: major,
        yearOfStudy: yearOfStudy,
        bio: bio,
        cvUrl: cvUrl,
        skills: skills,
        languages: languages,
        availability: availability,
        transportation: transportation,
        previousExperience: previousExperience,
        websiteUrl: websiteUrl,
        socialMediaLinks: socialMediaLinks,
        portfolio: portfolio,
        isPhonePublic: isPhonePublic,
        profileVisibility: profileVisibility,
      );
      emit(StudentProfileUpdated(updatedProfile));
      // Also emit loaded state to show updated profile
      emit(StudentProfileLoaded(updatedProfile));
    } catch (e) {
      emit(StudentProfileError(e.toString()));
    }
  }

  /// Refresh profile (reload from repository)
  Future<void> refreshProfile(String userId) async {
    await loadProfile(userId);
  }
}
