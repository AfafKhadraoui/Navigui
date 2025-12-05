import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/user_repo.dart';
import 'student_profile_state.dart';

class StudentProfileCubit extends Cubit<StudentProfileState> {
  final UserRepository _userRepository;

  StudentProfileCubit(this._userRepository) : super(StudentProfileInitial());

  Future<void> loadProfile(int userId) async {
    try {
      emit(StudentProfileLoading());
      final profile = await _userRepository.getStudentProfile(userId);
      emit(StudentProfileLoaded(profile));
    } catch (e) {
      emit(StudentProfileError(e.toString()));
    }
  }

  Future<void> updateProfile({
    required int userId,
    String? bio,
    String? phone,
    String? university,
    String? major,
    int? graduationYear,
    List<String>? skills,
    List<Map<String, dynamic>>? education,
    List<Map<String, dynamic>>? experience,
    String? resumeUrl,
    String? profilePictureUrl,
  }) async {
    try {
      emit(StudentProfileLoading());
      final updatedProfile = await _userRepository.updateStudentProfile(
        userId: userId,
        bio: bio,
        phone: phone,
        university: university,
        major: major,
        graduationYear: graduationYear,
        skills: skills,
        education: education,
        experience: experience,
        resumeUrl: resumeUrl,
        profilePictureUrl: profilePictureUrl,
      );
      emit(StudentProfileUpdated(updatedProfile));
    } catch (e) {
      emit(StudentProfileError(e.toString()));
    }
  }

  Future<void> refreshProfile(int userId) async {
    await loadProfile(userId);
  }
}
