import 'package:equatable/equatable.dart';
import '../../../data/models/job_post.dart';

abstract class JobState extends Equatable {
  const JobState();

  @override
  List<Object?> get props => [];
}

class JobInitial extends JobState {}

class JobLoading extends JobState {}

class JobLoaded extends JobState {
  final List<JobPost> jobs;
  final String? searchQuery;
  final String? categoryFilter;
  final String? sortBy;

  const JobLoaded({
    required this.jobs,
    this.searchQuery,
    this.categoryFilter,
    this.sortBy,
  });

  @override
  List<Object?> get props => [jobs, searchQuery, categoryFilter, sortBy];

  JobLoaded copyWith({
    List<JobPost>? jobs,
    String? searchQuery,
    String? categoryFilter,
    String? sortBy,
  }) {
    return JobLoaded(
      jobs: jobs ?? this.jobs,
      searchQuery: searchQuery ?? this.searchQuery,
      categoryFilter: categoryFilter ?? this.categoryFilter,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

class JobDetailLoaded extends JobState {
  final JobPost job;

  const JobDetailLoaded(this.job);

  @override
  List<Object?> get props => [job];
}

class JobError extends JobState {
  final String message;

  const JobError(this.message);

  @override
  List<Object?> get props => [message];
}
