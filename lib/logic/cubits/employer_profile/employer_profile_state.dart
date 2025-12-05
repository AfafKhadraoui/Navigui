import 'package:equatable/equatable.dart';
import '../../../data/models/employer_model.dart';

abstract class EmployerProfileState extends Equatable {
  const EmployerProfileState();

  @override
  List<Object?> get props => [];
}

class EmployerProfileInitial extends EmployerProfileState {}

class EmployerProfileLoading extends EmployerProfileState {}

class EmployerProfileLoaded extends EmployerProfileState {
  final EmployerModel profile;

  const EmployerProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class EmployerProfileUpdated extends EmployerProfileState {
  final EmployerModel profile;

  const EmployerProfileUpdated(this.profile);

  @override
  List<Object?> get props => [profile];
}

class EmployerProfileError extends EmployerProfileState {
  final String message;

  const EmployerProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
