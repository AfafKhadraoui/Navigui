import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'commons/themes/style_simple/theme.dart';
import 'routes/app_router.dart';
import 'core/dependency_injection.dart';
// TODO: Update to new repository structure
// import 'logic/cubits/auth/auth_cubit.dart';
// import 'logic/cubits/job/job_cubit.dart';
// import 'logic/cubits/application/application_cubit.dart';
// import 'logic/cubits/notification/notification_cubit.dart';
// import 'logic/cubits/saved_jobs/saved_jobs_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

// Seed database with mock data
  // await DatabaseSeeder.seedDatabase();



  // Initialize dependency injection
  await setupDependencies();

  runApp(const NaviguiApp());
}

class NaviguiApp extends StatelessWidget {
  const NaviguiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Navigui',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
    // TODO: Re-enable when implementing new repository structure
    // return MultiBlocProvider(
    //   providers: [
    //     // Core cubits that are needed globally
    //     BlocProvider(
    //       create: (_) => getIt<AuthCubit>(),
    //     ),
    //     BlocProvider(
    //       create: (_) => getIt<JobCubit>(),
    //     ),
    //     BlocProvider(
    //       create: (_) => getIt<ApplicationCubit>(),
    //     ),
    //     BlocProvider(
    //       create: (_) => getIt<NotificationCubit>(),
    //     ),
    //     BlocProvider(
    //       create: (_) => getIt<SavedJobsCubit>(),
    //     ),
    //   ],
    //   child: MaterialApp.router(
    //     title: 'Navigui',
    //     theme: AppTheme.lightTheme,
    //     debugShowCheckedModeBanner: false,
    //     routerConfig: AppRouter.router,
    //   ),
    // );
  }
}
