import 'package:equatable/equatable.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/job_post.dart';

abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object?> get props => [];
}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminDashboardLoaded extends AdminState {
  final Map<String, dynamic> statistics;

  const AdminDashboardLoaded(this.statistics);

  @override
  List<Object?> get props => [statistics];
}

class AdminUsersLoaded extends AdminState {
  final List<UserModel> users;
  final String? roleFilter;
  final String? statusFilter;

  const AdminUsersLoaded({
    required this.users,
    this.roleFilter,
    this.statusFilter,
  });

  @override
  List<Object?> get props => [users, roleFilter, statusFilter];
}

class AdminJobsLoaded extends AdminState {
  final List<JobPost> jobs;
  final String? statusFilter;

  const AdminJobsLoaded({
    required this.jobs,
    this.statusFilter,
  });

  @override
  List<Object?> get props => [jobs, statusFilter];
}

class AdminUserUpdated extends AdminState {
  final UserModel user;

  const AdminUserUpdated(this.user);

  @override
  List<Object?> get props => [user];
}

class AdminJobUpdated extends AdminState {
  final JobPost job;

  const AdminJobUpdated(this.job);

  @override
  List<Object?> get props => [job];
}

class AdminError extends AdminState {
  final String message;

  const AdminError(this.message);

  @override
  List<Object?> get props => [message];
}
