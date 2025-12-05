import 'package:equatable/equatable.dart';
import '../../../data/models/student_model.dart';

abstract class StudentProfileState extends Equatable {
  const StudentProfileState();

  @override
  List<Object?> get props => [];
}

class StudentProfileInitial extends StudentProfileState {}

class StudentProfileLoading extends StudentProfileState {}

class StudentProfileLoaded extends StudentProfileState {
  final StudentModel profile;

  const StudentProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class StudentProfileUpdated extends StudentProfileState {
  final StudentModel profile;

  const StudentProfileUpdated(this.profile);

  @override
  List<Object?> get props => [profile];
}

class StudentProfileError extends StudentProfileState {
  final String message;

  const StudentProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
