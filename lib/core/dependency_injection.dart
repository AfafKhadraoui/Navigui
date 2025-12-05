import 'package:get_it/get_it.dart';
import '../data/repositories/auth_repo.dart';
import '../data/repositories/job_repo.dart';
import '../data/repositories/application_repo.dart';
import '../data/repositories/user_repo.dart';
import '../data/repositories/notification_repo.dart';
import '../data/repositories/review_repo.dart';
import '../logic/cubits/auth/auth_cubit.dart';
import '../logic/cubits/job/job_cubit.dart';
import '../logic/cubits/application/application_cubit.dart';
import '../logic/cubits/student_profile/student_profile_cubit.dart';
import '../logic/cubits/employer_profile/employer_profile_cubit.dart';
import '../logic/cubits/employer_job/employer_job_cubit.dart';
import '../logic/cubits/employer_application/employer_application_cubit.dart';
import '../logic/cubits/notification/notification_cubit.dart';
import '../logic/cubits/search/search_cubit.dart';
import '../logic/cubits/saved_jobs/saved_jobs_cubit.dart';
import '../logic/cubits/review/review_cubit.dart';
import '../logic/cubits/education/education_cubit.dart';
import '../logic/cubits/admin/admin_cubit.dart';

final getIt = GetIt.instance;

/// Initialize all dependencies using GetIt
/// Call this method in main() before runApp()
Future<void> setupDependencies() async {
  // ========== REPOSITORIES ==========
  // Repositories are registered as lazy singletons
  // They will be created only when first accessed

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(),
  );

  getIt.registerLazySingleton<JobRepository>(
    () => JobRepository(),
  );

  getIt.registerLazySingleton<ApplicationRepository>(
    () => ApplicationRepository(),
  );

  getIt.registerLazySingleton<UserRepository>(
    () => UserRepository(),
  );

  getIt.registerLazySingleton<NotificationRepository>(
    () => NotificationRepository(),
  );

  getIt.registerLazySingleton<ReviewRepository>(
    () => ReviewRepository(),
  );

  // ========== CUBITS ==========
  // Cubits are registered as factories
  // A new instance will be created each time they are accessed
  // This is important for BLoC pattern to ensure proper lifecycle

  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(getIt<AuthRepository>()),
  );

  getIt.registerFactory<JobCubit>(
    () => JobCubit(getIt<JobRepository>()),
  );

  getIt.registerFactory<ApplicationCubit>(
    () => ApplicationCubit(getIt<ApplicationRepository>()),
  );

  getIt.registerFactory<StudentProfileCubit>(
    () => StudentProfileCubit(getIt<UserRepository>()),
  );

  getIt.registerFactory<EmployerProfileCubit>(
    () => EmployerProfileCubit(getIt<UserRepository>()),
  );

  getIt.registerFactory<EmployerJobCubit>(
    () => EmployerJobCubit(getIt<JobRepository>()),
  );

  getIt.registerFactory<EmployerApplicationCubit>(
    () => EmployerApplicationCubit(getIt<ApplicationRepository>()),
  );

  getIt.registerFactory<NotificationCubit>(
    () => NotificationCubit(getIt<NotificationRepository>()),
  );

  getIt.registerFactory<SearchCubit>(
    () => SearchCubit(getIt<JobRepository>()),
  );

  getIt.registerFactory<SavedJobsCubit>(
    () => SavedJobsCubit(getIt<JobRepository>()),
  );

  getIt.registerFactory<ReviewCubit>(
    () => ReviewCubit(getIt<ReviewRepository>()),
  );

  getIt.registerFactory<EducationCubit>(
    () => EducationCubit(),
  );

  getIt.registerFactory<AdminCubit>(
    () => AdminCubit(),
  );
}
