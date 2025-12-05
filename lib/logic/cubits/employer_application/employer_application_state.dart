import 'package:equatable/equatable.dart';
import '../../../data/models/application_model.dart';

abstract class EmployerApplicationState extends Equatable {
  const EmployerApplicationState();

  @override
  List<Object?> get props => [];
}

class EmployerApplicationInitial extends EmployerApplicationState {}

class EmployerApplicationLoading extends EmployerApplicationState {}

class EmployerApplicationsLoaded extends EmployerApplicationState {
  final List<ApplicationModel> applications;
  final int? jobId;
  final String? statusFilter;

  const EmployerApplicationsLoaded({
    required this.applications,
    this.jobId,
    this.statusFilter,
  });

  @override
  List<Object?> get props => [applications, jobId, statusFilter];
}

class EmployerApplicationUpdated extends EmployerApplicationState {
  final ApplicationModel application;

  const EmployerApplicationUpdated(this.application);

  @override
  List<Object?> get props => [application];
}

class EmployerApplicationError extends EmployerApplicationState {
  final String message;

  const EmployerApplicationError(this.message);

  @override
  List<Object?> get props => [message];
}
