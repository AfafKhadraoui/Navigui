import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/applications/applications_repo_impl.dart';
import '../../../data/models/applications_model.dart';
import 'employer_application_state.dart';

class EmployerApplicationCubit extends Cubit<EmployerApplicationState> {
  final ApplicationRepositoryImpl _applicationRepository =
      ApplicationRepositoryImpl();

  EmployerApplicationCubit() : super(EmployerApplicationInitial());

  /// Load all applications for a specific job
  Future<void> loadJobApplications({
    required String jobId,
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

  /// Update application status and reload list
  Future<void> updateApplicationStatus({
    required String applicationId,
    required ApplicationStatus status,
  }) async {
    try {
      emit(EmployerApplicationLoading());
      final application = await _applicationRepository.updateApplicationStatus(
        applicationId: applicationId,
        status: status,
      );
      emit(EmployerApplicationUpdated(application));
      
      // Reload applications after status update
      final currentState = state;
      if (currentState is EmployerApplicationsLoaded) {
        await loadJobApplications(
          jobId: currentState.jobId!,
          statusFilter: currentState.statusFilter,
        );
      }
    } catch (e) {
      emit(EmployerApplicationError(e.toString()));
    }
  }

  /// Accept an application
  Future<void> acceptApplication(String applicationId) async {
    await updateApplicationStatus(
      applicationId: applicationId,
      status: ApplicationStatus.accepted,
    );
  }

  /// Reject an application
  Future<void> rejectApplication(String applicationId) async {
    await updateApplicationStatus(
      applicationId: applicationId,
      status: ApplicationStatus.rejected,
    );
  }

  /// Filter applications by status
  Future<void> filterByStatus({
    required String jobId,
    required String status,
  }) async {
    try {
      emit(EmployerApplicationLoading());
      final statusEnum = ApplicationStatus.values.firstWhere(
        (e) => e.dbValue == status,
        orElse: () => ApplicationStatus.pending,
      );

      final applications = await _applicationRepository.filterByStatus(
        jobId: jobId,
        status: statusEnum,
      );

      emit(EmployerApplicationsLoaded(
        applications: applications,
        jobId: jobId,
        statusFilter: status,
      ));
    } catch (e) {
      emit(EmployerApplicationError(e.toString()));
    }
  }

  /// Refresh applications (reload with current filters)
  Future<void> refreshApplications() async {
    final currentState = state;
    if (currentState is EmployerApplicationsLoaded) {
      await loadJobApplications(
        jobId: currentState.jobId!,
        statusFilter: currentState.statusFilter,
      );
    }
  }

  /// Get application details
  Future<void> viewApplicationDetails(String applicationId) async {
    try {
      final application = await _applicationRepository.getApplicationById(applicationId);
      if (application != null) {
        emit(EmployerApplicationUpdated(application));
      } else {
        emit(EmployerApplicationError('Application not found'));
      }
    } catch (e) {
      emit(EmployerApplicationError(e.toString()));
    }
  }
}
