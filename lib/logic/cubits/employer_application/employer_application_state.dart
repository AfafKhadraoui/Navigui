import 'package:equatable/equatable.dart';
import '../../../data/models/applications_model.dart';

abstract class EmployerApplicationState extends Equatable {
  const EmployerApplicationState();

  @override
  List<Object?> get props => [];
}

class EmployerApplicationInitial extends EmployerApplicationState {}

class EmployerApplicationLoading extends EmployerApplicationState {}

class EmployerApplicationsLoaded extends EmployerApplicationState {
  final List<Application> applications;
  final String? jobId;
  final String? statusFilter;

  const EmployerApplicationsLoaded({
    required this.applications,
    this.jobId,
    this.statusFilter,
  });

  @override
  List<Object?> get props => [applications, jobId, statusFilter];
  
  /// Get filtered applications based on status
  List<Application> getFilteredByStatus(String status) {
    if (status == 'all') {
      return applications;
    }
    return applications
        .where((app) => app.status.dbValue == status)
        .toList();
  }

  /// Get count of applications by status
  Map<String, int> getStatusCounts() {
    final counts = <String, int>{};
    for (final app in applications) {
      final status = app.status.dbValue;
      counts[status] = (counts[status] ?? 0) + 1;
    }
    return counts;
  }
}

class EmployerApplicationUpdated extends EmployerApplicationState {
  final Application application;

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
