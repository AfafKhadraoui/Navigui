import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/application_repo.dart';
import 'application_state.dart';

class ApplicationCubit extends Cubit<ApplicationState> {
  final ApplicationRepository _applicationRepository;

  ApplicationCubit(this._applicationRepository) : super(ApplicationInitial());

  Future<void> loadMyApplications({String? statusFilter}) async {
    try {
      emit(ApplicationLoading());
      final applications = await _applicationRepository.getMyApplications(
        statusFilter: statusFilter,
      );
      emit(ApplicationsLoaded(
        applications: applications,
        statusFilter: statusFilter,
      ));
    } catch (e) {
      emit(ApplicationError(e.toString()));
    }
  }

  Future<void> submitApplication({
    required int jobId,
    required String coverLetter,
    String? resumeUrl,
    Map<String, dynamic>? additionalInfo,
  }) async {
    try {
      emit(ApplicationLoading());
      final application = await _applicationRepository.submitApplication(
        jobId: jobId,
        coverLetter: coverLetter,
        resumeUrl: resumeUrl,
        additionalInfo: additionalInfo,
      );
      emit(ApplicationSubmitted(application));
    } catch (e) {
      emit(ApplicationError(e.toString()));
    }
  }

  Future<void> withdrawApplication(int applicationId) async {
    try {
      emit(ApplicationLoading());
      await _applicationRepository.withdrawApplication(applicationId);
      emit(ApplicationWithdrawn(applicationId));
      // Reload applications after withdrawal
      await loadMyApplications();
    } catch (e) {
      emit(ApplicationError(e.toString()));
    }
  }

  Future<void> filterByStatus(String status) async {
    await loadMyApplications(statusFilter: status);
  }

  Future<void> refreshApplications() async {
    final currentState = state;
    if (currentState is ApplicationsLoaded) {
      await loadMyApplications(statusFilter: currentState.statusFilter);
    } else {
      await loadMyApplications();
    }
  }
}
