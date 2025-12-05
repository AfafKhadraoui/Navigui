import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../data/repositories/application_repo.dart'; // TODO: Update to new repo structure
import 'employer_application_state.dart';

class EmployerApplicationCubit extends Cubit<EmployerApplicationState> {
  final ApplicationRepository _applicationRepository;

  EmployerApplicationCubit(this._applicationRepository)
      : super(EmployerApplicationInitial());

  Future<void> loadJobApplications({
    int? jobId,
    String? statusFilter,
  }) async {
    try {
      emit(EmployerApplicationLoading());
      final applications = await _applicationRepository.getJobApplications(
        jobId: jobId,
        statusFilter: statusFilter,
      );
      emit(EmployerApplicationsLoaded(
        applications: applications,
        jobId: jobId,
        statusFilter: statusFilter,
      ));
    } catch (e) {
      emit(EmployerApplicationError(e.toString()));
    }
  }

  Future<void> updateApplicationStatus({
    required int applicationId,
    required String status,
    String? employerNotes,
  }) async {
    try {
      emit(EmployerApplicationLoading());
      final application = await _applicationRepository.updateApplicationStatus(
        applicationId: applicationId,
        status: status,
        employerNotes: employerNotes,
      );
      emit(EmployerApplicationUpdated(application));
      // Reload applications after status update
      final currentState = state;
      if (currentState is EmployerApplicationsLoaded) {
        await loadJobApplications(
          jobId: currentState.jobId,
          statusFilter: currentState.statusFilter,
        );
      }
    } catch (e) {
      emit(EmployerApplicationError(e.toString()));
    }
  }

  Future<void> acceptApplication(int applicationId, {String? notes}) async {
    await updateApplicationStatus(
      applicationId: applicationId,
      status: 'accepted',
      employerNotes: notes,
    );
  }

  Future<void> rejectApplication(int applicationId, {String? notes}) async {
    await updateApplicationStatus(
      applicationId: applicationId,
      status: 'rejected',
      employerNotes: notes,
    );
  }

  Future<void> shortlistApplication(int applicationId) async {
    await updateApplicationStatus(
      applicationId: applicationId,
      status: 'shortlisted',
    );
  }

  Future<void> filterByStatus(String status) async {
    final currentState = state;
    if (currentState is EmployerApplicationsLoaded) {
      await loadJobApplications(
        jobId: currentState.jobId,
        statusFilter: status,
      );
    } else {
      await loadJobApplications(statusFilter: status);
    }
  }

  Future<void> refreshApplications() async {
    final currentState = state;
    if (currentState is EmployerApplicationsLoaded) {
      await loadJobApplications(
        jobId: currentState.jobId,
        statusFilter: currentState.statusFilter,
      );
    } else {
      await loadJobApplications();
    }
  }
}
