import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'commons/themes/style_simple/theme.dart';
import 'routes/app_router.dart';
import 'core/dependency_injection.dart';
import 'logic/cubits/auth/auth_cubit.dart';
import 'logic/cubits/language/language_cubit.dart';
import 'logic/services/session_manager.dart';
import 'data/databases/seed_data.dart';
import 'commons/language_provider.dart';
import 'generated/s.dart';
// TODO: Update to new repository structure
// import 'logic/cubits/job/job_cubit.dart';
// import 'logic/cubits/application/application_cubit.dart';
// import 'logic/cubits/notification/notification_cubit.dart';
// import 'logic/cubits/saved_jobs/saved_jobs_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Seed database with test users
  await DatabaseSeeder.seedDatabase();

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

class NaviguiApp extends StatefulWidget {
  const NaviguiApp({super.key});

  @override
  State<NaviguiApp> createState() => _NaviguiAppState();
}

class _NaviguiAppState extends State<NaviguiApp> {
  late final SessionManager _sessionManager;
  late final AuthCubit _authCubit;

  @override
  void initState() {
    super.initState();
    
    _authCubit = getIt<AuthCubit>();
    
    // Initialize session manager with callback
    _sessionManager = SessionManager(
      onSessionExpired: () {
        // Logout user when session expires
        _authCubit.logout();
        
        // Show snackbar notification
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Your session has expired. Please login again.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
    );

    // Start session monitoring
    _sessionManager.startSessionMonitoring();
    
    // Check auth status on app start
    _authCubit.checkAuthStatus();
  }

  @override
  void dispose() {
    _sessionManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authCubit),
        BlocProvider(create: (_) => getIt<LanguageCubit>()),
      ],
      child: BlocBuilder<LanguageCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp.router(
            key: ValueKey(locale.languageCode), // Force rebuild when locale changes
            title: 'Navigui',
            theme: AppTheme.lightTheme,
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.router,
            locale: locale,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('ar'),
              Locale('fr'),
            ],
          );
        },
      ),
    );
  }
    // TODO: Re-enable MultiBlocProvider when implementing other cubits
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
