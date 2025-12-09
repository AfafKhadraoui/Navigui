import 'package:get_it/get_it.dart';
import '../data/repositories/auth/auth_repo_abstract.dart';
// import '../data/repositories/auth/auth_repo.dart';  // Real API implementation
// import '../data/repositories/auth/mock_auth_repo.dart';  // Mock implementation (REMOVED)
import '../data/repositories/auth/database_auth_repo.dart';  // Database implementation
import '../data/repositories/user/user_repo_abstract.dart';
// import '../data/repositories/user/user_repo_impl.dart';  // Real API implementation
import '../data/repositories/user/mock_user_repo.dart';  // Mock implementation
import '../data/repositories/user/database_user_repo.dart';  // Database implementation
import '../data/repositories/admin/admin_repo_abstract.dart';
import '../data/repositories/admin/admin_repo_impl.dart';
import '../logic/cubits/auth/auth_cubit.dart';
import '../logic/cubits/student_profile/student_profile_cubit.dart';
import '../logic/cubits/employer_profile/employer_profile_cubit.dart';
import '../logic/services/secure_storage_service.dart';
// TODO: Update to new repository structure
// import '../data/repositories/job_repo.dart';
// import '../data/repositories/application_repo.dart';
// import '../data/repositories/notification_repo.dart';
// import '../data/repositories/review_repo.dart';
// import '../logic/cubits/job/job_cubit.dart';
// import '../logic/cubits/application/application_cubit.dart';
import '../logic/cubits/employer_job/employer_job_cubit.dart';
import '../logic/cubits/employer_application/employer_application_cubit.dart';
import '../logic/cubits/employer_profile/employer_profile_cubit.dart';
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
import '../logic/cubits/language/language_cubit.dart';
import '../data/repositories/jobs/jobs_repo_abstract.dart';
import '../data/repositories/jobs/jobs_repo_impl.dart';
import '../logic/cubits/job/job_cubit.dart';
import '../logic/cubits/saved_jobs/saved_jobs_cubit.dart';

final getIt = GetIt.instance;

/// Initialize all dependencies using GetIt
/// Call this method in main() before runApp()
Future<void> setupDependencies() async {
  // Global Services
  getIt.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(),
  );

  // ========== REPOSITORIES ==========
  // Repositories are registered as lazy singletons
  // They will be created only when first accessed

  // Auth Repository
  // OPTION 1: Use Database Repository (with SQLite)
  getIt.registerLazySingleton<AuthRepository>(
    () => DatabaseAuthRepository(),
  );
  
  // OPTION 2: Use Real API Repository (when backend is ready)
  // getIt.registerLazySingleton<AuthRepository>(
  //   () => AuthRepositoryImpl(
  //     baseUrl: 'http://localhost:5000/api', // TODO: Replace with your backend URL
  //   ),
  // );

  // User Repository (for profile management)
  // Using Database Repository for local SQLite storage
  getIt.registerLazySingleton<UserRepository>(
    () => DatabaseUserRepository(),
  );

  // Admin Repository (for admin operations)
  getIt.registerLazySingleton<AdminRepository>(
    () => AdminRepositoryImpl(),
  );

  // OPTION 2: Use Real API Repository (when backend is ready)
  // Note: UserRepositoryImpl requires auth token from AuthRepository
  // getIt.registerLazySingleton<UserRepository>(
  //   () => UserRepositoryImpl(
  //     baseUrl: 'http://localhost:5000/api', // TODO: Replace with your backend URL
  //     getAuthToken: () {
  //       // Get current auth token from AuthRepository
  //       // You may need to add a getToken() method to AuthRepository
  //       return null; // TODO: Implement token retrieval
  //     },
  //   ),
  // );

  // TODO: Update to new repository structure

  // getIt.registerLazySingleton<JobRepository>(
  //   () => JobRepository(),
  // );

  // getIt.registerLazySingleton<ApplicationRepository>(
  //   () => ApplicationRepository(),
  // );

  // getIt.registerLazySingleton<NotificationRepository>(
  //   () => NotificationRepository(),
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

  // Register Job Repository
  getIt.registerLazySingleton<JobRepositoryBase>(
    () => JobRepositoryImpl(),
  );

  // ========== CUBITS ==========
  // Cubits are registered as factories
  // A new instance will be created each time they are accessed
  // This is important for BLoC pattern to ensure proper lifecycle

  // Auth Cubit
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(getIt<AuthRepository>()),
  );

  // Profile Cubits
  getIt.registerFactory<StudentProfileCubit>(
    () => StudentProfileCubit(getIt<UserRepository>()),
  );

  getIt.registerFactory<EmployerProfileCubit>(
    () => EmployerProfileCubit(getIt<UserRepository>()),
  );

  // Job Cubit
  getIt.registerFactory<JobCubit>(
    () => JobCubit(getIt<JobRepositoryBase>()),
  );

  // Saved Jobs Cubit
  getIt.registerFactory<SavedJobsCubit>(
    () => SavedJobsCubit(getIt<JobRepositoryBase>()),
  );

  // TODO: Update to new repository structure

  // getIt.registerFactory<JobCubit>(
  //   () => JobCubit(getIt<JobRepository>()),
  // );

  // getIt.registerFactory<ApplicationCubit>(
  //   () => ApplicationCubit(getIt<ApplicationRepository>()),
  // );



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
    () => AdminCubit(getIt<AdminRepository>()),
  );

  // Language Cubit (Singleton - maintains language state globally)
  getIt.registerLazySingleton<LanguageCubit>(
    () => LanguageCubit(),
  );
}

