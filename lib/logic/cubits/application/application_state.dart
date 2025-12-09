import 'package:equatable/equatable.dart';
import '../../../data/models/applications_model.dart';

abstract class ApplicationState extends Equatable {
  const ApplicationState();

  @override
  List<Object?> get props => [];
}

class ApplicationInitial extends ApplicationState {}

class ApplicationLoading extends ApplicationState {}

class ApplicationsLoaded extends ApplicationState {
  final List<Application> applications;
  final String? statusFilter;

  const ApplicationsLoaded({
    required this.applications,
    this.statusFilter,
  });

  @override
  List<Object?> get props => [applications, statusFilter];
}

class ApplicationSubmitted extends ApplicationState {
  final Application application;

  const ApplicationSubmitted(this.application);

  @override
  List<Object?> get props => [application];
}

class ApplicationUpdated extends ApplicationState {
  final Application application;

  const ApplicationUpdated(this.application);

  @override
  List<Object?> get props => [application];
}

class ApplicationWithdrawn extends ApplicationState {
  final int applicationId;

  const ApplicationWithdrawn(this.applicationId);

  @override
  List<Object?> get props => [applicationId];
}

class ApplicationError extends ApplicationState {
  final String message;

  const ApplicationError(this.message);

  @override
  List<Object?> get props => [message];
}
