import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'commons/themes/style_simple/theme.dart';
import 'routes/app_router.dart';
import 'core/dependency_injection.dart';
import 'data/databases/db_helper.dart';
import 'logic/cubits/auth/auth_cubit.dart';
import 'commons/language_provider.dart';
import 'generated/s.dart';
// import 'logic/cubits/job/job_cubit.dart';
// import 'logic/cubits/application/application_cubit.dart';
// import 'logic/cubits/notification/notification_cubit.dart';
// import 'logic/cubits/saved_jobs/saved_jobs_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Uncomment to reset database (delete and recreate with fresh seed data)
  await DBHelper.deleteDB();
  print('Database deleted, will be recreated on next access');

  // Initialize dependency injection
  await setupDependencies();

  runApp(
    // Wrap with ChangeNotifierProvider for language management
    ChangeNotifierProvider(
      create: (_) => LanguageProvider(),
      child: const NaviguiApp(),
    ),
  );
}

class NaviguiApp extends StatelessWidget {
  const NaviguiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<AuthCubit>(),
        ),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp.router(
            title: 'Navigui',
            theme: AppTheme.lightTheme,
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.router,
            // Localization setup
            locale: languageProvider.currentLocale,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'), // English
              Locale('ar'), // Arabic
              Locale('fr'), // French
            ],
          );
        },
      ),
    );
    // TODO: Re-enable other cubits when implementing new repository structure
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
