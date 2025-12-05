import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../data/repositories/job_repo.dart'; // TODO: Update to new repo structure
import 'saved_jobs_state.dart';

class SavedJobsCubit extends Cubit<SavedJobsState> {
  // TODO: Update to new repo structure
  // final JobRepository _jobRepository;

  SavedJobsCubit() : super(SavedJobsInitial());

  // TODO: Implement with new repository structure
  // Future<void> loadSavedJobs() async {
  //   try {
  //     emit(SavedJobsLoading());
  //     final savedJobs = await _jobRepository.getSavedJobs();
  //     final savedJobIds = savedJobs.map((job) => job.id).toList();
  //     emit(SavedJobsLoaded(
  //       savedJobs: savedJobs,
  //       savedJobIds: savedJobIds,
  //     ));
  //   } catch (e) {
  //     emit(SavedJobsError(e.toString()));
  //   }
  // }

  // Future<void> saveJob(int jobId) async {
  //   try {
  //     await _jobRepository.saveJob(jobId);
  //     emit(JobSaved(jobId));
  //     // Reload saved jobs
  //     await loadSavedJobs();
  //   } catch (e) {
  //     emit(SavedJobsError(e.toString()));
  //   }
  // }

  // Future<void> unsaveJob(int jobId) async {
  //   try {
  //     await _jobRepository.unsaveJob(jobId);
  //     emit(JobUnsaved(jobId));
  //     // Reload saved jobs
  //     await loadSavedJobs();
  //   } catch (e) {
  //     emit(SavedJobsError(e.toString()));
  //   }
  // }

  // Future<void> toggleSaveJob(int jobId) async {
  //   final currentState = state;
  //   if (currentState is SavedJobsLoaded) {
  //     if (currentState.isJobSaved(jobId)) {
  //       await unsaveJob(jobId);
  //     } else {
  //       await saveJob(jobId);
  //     }
  //   } else {
  //     await saveJob(jobId);
  //   }
  // }

  // bool isJobSaved(int jobId) {
  //   final currentState = state;
  //   if (currentState is SavedJobsLoaded) {
  //     return currentState.isJobSaved(jobId);
  //   }
  //   return false;
  // }

  // Future<void> refreshSavedJobs() async {
  //   await loadSavedJobs();
  // }
}
