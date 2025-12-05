import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../data/repositories/user_repo.dart'; // TODO: Update to new repo structure
import 'employer_profile_state.dart';

class EmployerProfileCubit extends Cubit<EmployerProfileState> {
  final UserRepository _userRepository;

  EmployerProfileCubit(this._userRepository) : super(EmployerProfileInitial());

  Future<void> loadProfile(int userId) async {
    try {
      emit(EmployerProfileLoading());
      final profile = await _userRepository.getEmployerProfile(userId);
      emit(EmployerProfileLoaded(profile));
    } catch (e) {
      emit(EmployerProfileError(e.toString()));
    }
  }

  Future<void> updateProfile({
    required int userId,
    String? companyName,
    String? companyDescription,
    String? industry,
    String? website,
    String? phone,
    String? address,
    String? logoUrl,
    int? companySize,
    int? foundedYear,
  }) async {
    try {
      emit(EmployerProfileLoading());
      final updatedProfile = await _userRepository.updateEmployerProfile(
        userId: userId,
        companyName: companyName,
        companyDescription: companyDescription,
        industry: industry,
        website: website,
        phone: phone,
        address: address,
        logoUrl: logoUrl,
        companySize: companySize,
        foundedYear: foundedYear,
      );
      emit(EmployerProfileUpdated(updatedProfile));
    } catch (e) {
      emit(EmployerProfileError(e.toString()));
    }
  }

  Future<void> refreshProfile(int userId) async {
    await loadProfile(userId);
  }
}
