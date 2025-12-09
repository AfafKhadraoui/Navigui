import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/applications/applications_repo_impl.dart';
import '../../../data/models/applications_model.dart';
import 'application_state.dart';

class ApplicationCubit extends Cubit<ApplicationState> {
  final ApplicationRepositoryImpl _applicationRepository =
      ApplicationRepositoryImpl();

  ApplicationCubit() : super(ApplicationInitial());

  /// Load applications for the current student
  Future<void> loadMyApplications({
    required String studentId,
    String? statusFilter,
  }) async {
    try {
      emit(ApplicationLoading());
      final applications = await _applicationRepository.getStudentApplications(
        studentId: studentId,
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

  /// Submit a new application for a job
  Future<void> submitApplication({
    required String jobId,
    required String studentId,
    required String studentName,
    required String email,
    required String phone,
    required String experience,
    required String coverLetter,
    required List<String> skills,
    required String avatar,
    required String university,
    required String major,
    String? cvUrl,
    bool cvAttached = false,
  }) async {
    try {
      emit(ApplicationLoading());
      
      // Check if already applied
      final hasApplied = await _applicationRepository.hasApplied(
        jobId: jobId,
        studentId: studentId,
      );
      
      if (hasApplied) {
        emit(ApplicationError('You have already applied for this job'));
        return;
      }

      final application = await _applicationRepository.submitApplication(
        jobId: jobId,
        studentId: studentId,
        studentName: studentName,
        email: email,
        phone: phone,
        experience: experience,
        coverLetter: coverLetter,
        skills: skills,
        avatar: avatar,
        university: university,
        major: major,
        cvUrl: cvUrl,
        cvAttached: cvAttached,
      );
      
      emit(ApplicationSubmitted(application));
      
      // Reload applications
      await loadMyApplications(studentId: studentId);
    } catch (e) {
      emit(ApplicationError(e.toString()));
    }
  }

  /// Withdraw an application
  Future<void> withdrawApplication({
    required String applicationId,
    required String studentId,
  }) async {
    try {
      emit(ApplicationLoading());
      await _applicationRepository.withdrawApplication(applicationId);
      emit(ApplicationWithdrawn(applicationId));
      
      // Reload applications after withdrawal
      await loadMyApplications(studentId: studentId);
    } catch (e) {
      emit(ApplicationError(e.toString()));
    }
  }

  /// Filter applications by status
  Future<void> filterByStatus({
    required String studentId,
    required String status,
  }) async {
    await loadMyApplications(
      studentId: studentId,
      statusFilter: status,
    );
  }

  /// Refresh applications list
  Future<void> refreshApplications({required String studentId}) async {
    final currentState = state;
    if (currentState is ApplicationsLoaded) {
      await loadMyApplications(
        studentId: studentId,
        statusFilter: currentState.statusFilter,
      );
    } else {
      await loadMyApplications(studentId: studentId);
    }
  }
}
