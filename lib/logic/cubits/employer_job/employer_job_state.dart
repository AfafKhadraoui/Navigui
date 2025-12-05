import 'package:equatable/equatable.dart';
import '../../../data/models/job_post.dart';

abstract class EmployerJobState extends Equatable {
  const EmployerJobState();

  @override
  List<Object?> get props => [];
}

class EmployerJobInitial extends EmployerJobState {}

class EmployerJobLoading extends EmployerJobState {}

class EmployerJobsLoaded extends EmployerJobState {
  final List<JobPost> jobs;
  final String? statusFilter;

  const EmployerJobsLoaded({
    required this.jobs,
    this.statusFilter,
  });

  @override
  List<Object?> get props => [jobs, statusFilter];
}

class EmployerJobCreated extends EmployerJobState {
  final JobPost job;

  const EmployerJobCreated(this.job);

  @override
  List<Object?> get props => [job];
}

class EmployerJobUpdated extends EmployerJobState {
  final JobPost job;

  const EmployerJobUpdated(this.job);

  @override
  List<Object?> get props => [job];
}

class EmployerJobDeleted extends EmployerJobState {
  final int jobId;

  const EmployerJobDeleted(this.jobId);

  @override
  List<Object?> get props => [jobId];
}

class EmployerJobError extends EmployerJobState {
  final String message;

  const EmployerJobError(this.message);

  @override
  List<Object?> get props => [message];
}
