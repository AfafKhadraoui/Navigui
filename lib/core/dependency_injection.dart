import 'package:get_it/get_it.dart';
// TODO: Update to new repository structure
// import '../data/repositories/auth_repo.dart';
// import '../data/repositories/job_repo.dart';
// import '../data/repositories/application_repo.dart';
// import '../data/repositories/user_repo.dart';
// import '../data/repositories/review_repo.dart';
import '../logic/cubits/auth/auth_cubit.dart';
// import '../logic/cubits/job/job_cubit.dart';
// import '../logic/cubits/application/application_cubit.dart';
// import '../logic/cubits/student_profile/student_profile_cubit.dart';
import '../logic/cubits/employer_profile/employer_profile_cubit.dart';
import '../logic/cubits/employer_job/employer_job_cubit.dart';
import '../logic/cubits/employer_application/employer_application_cubit.dart';
// import '../logic/cubits/saved_jobs/saved_jobs_cubit.dart';
// import '../logic/cubits/review/review_cubit.dart';
import '../data/repositories/education/education_repo_abstract.dart';
import '../data/repositories/education/education_repo_impl.dart';
import '../data/repositories/notifications/notifications_repo_abstract.dart';
import '../data/repositories/notifications/notifications_repo_impl.dart';
import '../logic/cubits/education/education_cubit.dart';
import '../logic/cubits/notification/notification_cubit.dart';
import '../logic/cubits/search/search_cubit.dart';
import '../logic/cubits/admin/admin_cubit.dart';

final getIt = GetIt.instance;

/// Initialize all dependencies using GetIt
/// Call this method in main() before runApp()
Future<void> setupDependencies() async {
  // ========== REPOSITORIES ==========
  // Repositories are registered as lazy singletons
  // They will be created only when first accessed
  // TODO: Update to new repository structure

  // getIt.registerLazySingleton<AuthRepository>(
  //   () => AuthRepository(),
  // );

  // getIt.registerLazySingleton<JobRepository>(
  //   () => JobRepository(),
  // );

  // getIt.registerLazySingleton<ApplicationRepository>(
  //   () => ApplicationRepository(),
  // );

  // getIt.registerLazySingleton<UserRepository>(
  //   () => UserRepository(),
  // );

  // getIt.registerLazySingleton<ReviewRepository>(
  //   () => ReviewRepository(),
  // );

  // Register Education Repository
  getIt.registerLazySingleton<EducationRepositoryBase>(
    () => EducationRepositoryImpl(),
  );

  // Register Notification Repository
  getIt.registerLazySingleton<NotificationRepositoryBase>(
    () => NotificationRepositoryImpl(),
  );

  // ========== CUBITS ==========
  // Cubits are registered as factories
  // A new instance will be created each time they are accessed
  // This is important for BLoC pattern to ensure proper lifecycle
  // TODO: Update to new repository structure

  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(),
  );

  // getIt.registerFactory<JobCubit>(
  //   () => JobCubit(getIt<JobRepository>()),
  // );

  // getIt.registerFactory<ApplicationCubit>(
  //   () => ApplicationCubit(getIt<ApplicationRepository>()),
  // );

  // getIt.registerFactory<StudentProfileCubit>(
  //   () => StudentProfileCubit(getIt<UserRepository>()),
  // );

  getIt.registerFactory<EmployerProfileCubit>(
    () => EmployerProfileCubit(),
  );

  getIt.registerFactory<EmployerJobCubit>(
    () => EmployerJobCubit(),
  );

  getIt.registerFactory<EmployerApplicationCubit>(
    () => EmployerApplicationCubit(),
  );

  // getIt.registerFactory<SavedJobsCubit>(
  //   () => SavedJobsCubit(getIt<JobRepository>()),
  // );

  // getIt.registerFactory<ReviewCubit>(
  //   () => ReviewCubit(getIt<ReviewRepository>()),
  // );

  // Register Education Cubit with repository
  getIt.registerFactory<EducationCubit>(
    () => EducationCubit(getIt<EducationRepositoryBase>()),
  );

  // Register Notification Cubit with repository
  // Note: userId should be passed when creating the cubit, not here
  // This is a factory method that requires userId parameter
  getIt.registerFactoryParam<NotificationCubit, String, void>(
    (userId, _) =>
        NotificationCubit(getIt<NotificationRepositoryBase>(), userId),
  );

  // Register Search Cubit (currently without repository - needs job repository)
  getIt.registerFactory<SearchCubit>(
    () => SearchCubit(),
  );

  getIt.registerFactory<AdminCubit>(
    () => AdminCubit(),
  );
}
