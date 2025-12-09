import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/jobs/jobs_repo_abstract.dart';
import 'saved_jobs_state.dart';

class SavedJobsCubit extends Cubit<SavedJobsState> {
  final JobRepositoryBase _jobRepository;

  SavedJobsCubit(this._jobRepository) : super(SavedJobsInitial());

  Future<void> loadSavedJobs(String studentId) async {
    try {
      emit(SavedJobsLoading());
      final result = await _jobRepository.getSavedJobs(studentId);
      
      if (result.isSuccess && result.data != null) {
        final savedJobs = result.data!;
        final savedJobIds = savedJobs.map((job) => job.id).toList();
        emit(SavedJobsLoaded(
          savedJobs: savedJobs,
          savedJobIds: savedJobIds,
        ));
      } else {
        emit(SavedJobsError(result.error ?? 'Failed to load saved jobs'));
      }
    } catch (e) {
      emit(SavedJobsError(e.toString()));
    }
  }

  Future<void> saveJob(String jobId) async {
    try {
      final result = await _jobRepository.saveJob(jobId);
      
      if (result.isSuccess) {
        emit(JobSaved(jobId));
      } else {
        emit(SavedJobsError(result.error ?? 'Failed to save job'));
      }
    } catch (e) {
      emit(SavedJobsError(e.toString()));
    }
  }

  Future<void> unsaveJob(String jobId) async {
    try {
      final result = await _jobRepository.unsaveJob(jobId);
      
      if (result.isSuccess) {
        emit(JobUnsaved(jobId));
      } else {
        emit(SavedJobsError(result.error ?? 'Failed to unsave job'));
      }
    } catch (e) {
      emit(SavedJobsError(e.toString()));
    }
  }

  Future<void> toggleSaveJob(String jobId, String studentId) async {
    final currentState = state;
    if (currentState is SavedJobsLoaded) {
      if (currentState.isJobSaved(jobId)) {
        await unsaveJob(jobId);
        // Reload to update the list
        await loadSavedJobs(studentId);
      } else {
        await saveJob(jobId);
        // Reload to update the list
        await loadSavedJobs(studentId);
      }
    } else {
      await saveJob(jobId);
    }
  }

  bool isJobSaved(String jobId) {
    final currentState = state;
    if (currentState is SavedJobsLoaded) {
      return currentState.isJobSaved(jobId);
    }
    return false;
  }

  Future<void> refreshSavedJobs(String studentId) async {
    await loadSavedJobs(studentId);
  }
}
