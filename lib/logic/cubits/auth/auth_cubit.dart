import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../data/repositories/auth_repo.dart'; // TODO: Update to new repo structure
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  // TODO: Update to new repo structure
  // final AuthRepository _authRepository;

  AuthCubit() : super(AuthInitial());

  // TODO: Implement with new repository structure
  // Future<void> login({
  //   required String email,
  //   required String password,
  // }) async {
  //   try {
  //     emit(AuthLoading());
  //     final user = await _authRepository.login(email, password);
  //     emit(AuthAuthenticated(user));
  //   } catch (e) {
  //     emit(AuthError(e.toString()));
  //   }
  // }

  // Future<void> signup({
  //   required String email,
  //   required String password,
  //   required String fullName,
  //   required String role,
  //   Map<String, dynamic>? additionalData,
  // }) async {
  //   try {
  //     emit(AuthLoading());
  //     final user = await _authRepository.signup(
  //       email: email,
  //       password: password,
  //       fullName: fullName,
  //       role: role,
  //       additionalData: additionalData,
  //     );
  //     emit(AuthAuthenticated(user));
  //   } catch (e) {
  //     emit(AuthError(e.toString()));
  //   }
  // }

  // Future<void> logout() async {
  //   try {
  //     await _authRepository.logout();
  //     emit(AuthUnauthenticated());
  //   } catch (e) {
  //     emit(AuthError(e.toString()));
  //   }
  // }

  // Future<void> checkAuthStatus() async {
  //   try {
  //     final user = await _authRepository.getCurrentUser();
  //     if (user != null) {
  //       emit(AuthAuthenticated(user));
  //     } else {
  //       emit(AuthUnauthenticated());
  //     }
  //   } catch (e) {
  //     emit(AuthUnauthenticated());
  //   }
  // }
}
