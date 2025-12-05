import 'package:equatable/equatable.dart';
import '../../../data/models/application_model.dart';

abstract class ApplicationState extends Equatable {
  const ApplicationState();

  @override
  List<Object?> get props => [];
}

class ApplicationInitial extends ApplicationState {}

class ApplicationLoading extends ApplicationState {}

class ApplicationsLoaded extends ApplicationState {
  final List<ApplicationModel> applications;
  final String? statusFilter;

  const ApplicationsLoaded({
    required this.applications,
    this.statusFilter,
  });

  @override
  List<Object?> get props => [applications, statusFilter];
}

class ApplicationSubmitted extends ApplicationState {
  final ApplicationModel application;

  const ApplicationSubmitted(this.application);

  @override
  List<Object?> get props => [application];
}

class ApplicationUpdated extends ApplicationState {
  final ApplicationModel application;

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
