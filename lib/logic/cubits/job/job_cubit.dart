import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/jobs/jobs_repo_abstract.dart';
import 'job_state.dart';

class JobCubit extends Cubit<JobState> {
  final JobRepositoryBase _jobRepository;

  JobCubit(this._jobRepository) : super(JobInitial());

  Future<void> loadJobs({
    String? searchQuery,
    String? categoryFilter,
    String? sortBy,
  }) async {
    try {
      print('🎯 JobCubit: Loading jobs...');
      emit(JobLoading());
      final result = await _jobRepository.getActiveJobs();
      
      if (result.isSuccess && result.data != null) {
        print('✅ JobCubit: Loaded ${result.data!.length} jobs successfully');
        emit(JobLoaded(
          jobs: result.data!,
          searchQuery: searchQuery,
          categoryFilter: categoryFilter,
          sortBy: sortBy,
        ));
      } else {
        print('❌ JobCubit Error: ${result.error}');
        emit(JobError(result.error ?? 'Failed to load jobs'));
      }
    } catch (e) {
      print('❌ JobCubit Exception: $e');
      emit(JobError(e.toString()));
    }
  }

  Future<void> loadJobDetails(String jobId) async {
    try {
      emit(JobLoading());
      final result = await _jobRepository.getJobById(jobId);
      
      if (result.isSuccess && result.data != null) {
        emit(JobDetailLoaded(result.data!));
      } else {
        emit(JobError(result.error ?? 'Failed to load job details'));
      }
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
