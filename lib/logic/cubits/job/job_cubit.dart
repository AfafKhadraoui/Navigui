import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../data/repositories/job_repo.dart'; // TODO: Update to new repo structure
import 'job_state.dart';

class JobCubit extends Cubit<JobState> {
  final JobRepository _jobRepository;

  JobCubit(this._jobRepository) : super(JobInitial());

  Future<void> loadJobs({
    String? searchQuery,
    String? categoryFilter,
    String? sortBy,
  }) async {
    try {
      emit(JobLoading());
      final jobs = await _jobRepository.getJobs(
        searchQuery: searchQuery,
        category: categoryFilter,
        sortBy: sortBy,
      );
      emit(JobLoaded(
        jobs: jobs,
        searchQuery: searchQuery,
        categoryFilter: categoryFilter,
        sortBy: sortBy,
      ));
    } catch (e) {
      emit(JobError(e.toString()));
    }
  }

  Future<void> loadJobDetails(int jobId) async {
    try {
      emit(JobLoading());
      final job = await _jobRepository.getJobById(jobId);
      emit(JobDetailLoaded(job));
    } catch (e) {
      emit(JobError(e.toString()));
    }
  }

  Future<void> searchJobs(String query) async {
    final currentState = state;
    if (currentState is JobLoaded) {
      await loadJobs(
        searchQuery: query,
        categoryFilter: currentState.categoryFilter,
        sortBy: currentState.sortBy,
      );
    } else {
      await loadJobs(searchQuery: query);
    }
  }

  Future<void> filterByCategory(String category) async {
    final currentState = state;
    if (currentState is JobLoaded) {
      await loadJobs(
        searchQuery: currentState.searchQuery,
        categoryFilter: category,
        sortBy: currentState.sortBy,
      );
    } else {
      await loadJobs(categoryFilter: category);
    }
  }

  Future<void> sortJobs(String sortBy) async {
    final currentState = state;
    if (currentState is JobLoaded) {
      await loadJobs(
        searchQuery: currentState.searchQuery,
        categoryFilter: currentState.categoryFilter,
        sortBy: sortBy,
      );
    } else {
      await loadJobs(sortBy: sortBy);
    }
  }

  Future<void> refreshJobs() async {
    final currentState = state;
    if (currentState is JobLoaded) {
      await loadJobs(
        searchQuery: currentState.searchQuery,
        categoryFilter: currentState.categoryFilter,
        sortBy: currentState.sortBy,
      );
    } else {
      await loadJobs();
    }
  }
}
