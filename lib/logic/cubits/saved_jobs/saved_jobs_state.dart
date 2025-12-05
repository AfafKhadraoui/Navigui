import 'package:equatable/equatable.dart';
import '../../../data/models/job_post.dart';

abstract class SavedJobsState extends Equatable {
  const SavedJobsState();

  @override
  List<Object?> get props => [];
}

class SavedJobsInitial extends SavedJobsState {}

class SavedJobsLoading extends SavedJobsState {}

class SavedJobsLoaded extends SavedJobsState {
  final List<JobPost> savedJobs;
  final List<String> savedJobIds;

  const SavedJobsLoaded({
    required this.savedJobs,
    required this.savedJobIds,
  });

  @override
  List<Object?> get props => [savedJobs, savedJobIds];

  bool isJobSaved(int jobId) => savedJobIds.contains(jobId);
}

class JobSaved extends SavedJobsState {
  final int jobId;

  const JobSaved(this.jobId);

  @override
  List<Object?> get props => [jobId];
}

class JobUnsaved extends SavedJobsState {
  final int jobId;

  const JobUnsaved(this.jobId);

  @override
  List<Object?> get props => [jobId];
}

class SavedJobsError extends SavedJobsState {
  final String message;

  const SavedJobsError(this.message);

  @override
  List<Object?> get props => [message];
}
