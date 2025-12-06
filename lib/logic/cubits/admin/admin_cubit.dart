import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/admin/admin_repo_abstract.dart';
import 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  final AdminRepository _adminRepository;

  AdminCubit(this._adminRepository) : super(AdminInitial());

  Future<void> loadDashboard() async {
    try {
      emit(AdminLoading());
      final statistics = await _adminRepository.getDashboardStatistics();
      emit(AdminDashboardLoaded(statistics));
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  Future<void> loadUsers({
    String? roleFilter,
    String? statusFilter,
  }) async {
    try {
      emit(AdminLoading());
      final users = await _adminRepository.getUsers(
        roleFilter: roleFilter,
        statusFilter: statusFilter,
      );

      emit(AdminUsersLoaded(
        users: users,
        roleFilter: roleFilter,
        statusFilter: statusFilter,
      ));
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  Future<void> loadJobs({String? statusFilter}) async {
    try {
      emit(AdminLoading());
      final jobs = await _adminRepository.getJobs(statusFilter: statusFilter);

      emit(AdminJobsLoaded(
        jobs: jobs,
        statusFilter: statusFilter,
      ));
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  Future<void> updateUserStatus({
    required String userId,
    required String status,
  }) async {
    try {
      emit(AdminLoading());
      final user = await _adminRepository.updateUserStatus(userId, status);
      emit(AdminUserUpdated(user));

      // Reload users
      await loadUsers();
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  Future<void> verifyEmployer(String userId) async {
    await updateUserStatus(userId: userId, status: 'verified');
  }

  Future<void> suspendUser(String userId) async {
    await updateUserStatus(userId: userId, status: 'suspended');
  }

  Future<void> deleteJob(String jobId) async {
    try {
      emit(AdminLoading());
      await _adminRepository.deleteJob(jobId);

      // Reload jobs
      await loadJobs();
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  Future<void> filterUsersByRole(String role) async {
    final currentState = state;
    if (currentState is AdminUsersLoaded) {
      await loadUsers(
        roleFilter: role,
        statusFilter: currentState.statusFilter,
      );
    } else {
      await loadUsers(roleFilter: role);
    }
  }

  Future<void> filterJobsByStatus(String status) async {
    await loadJobs(statusFilter: status);
  }
}
