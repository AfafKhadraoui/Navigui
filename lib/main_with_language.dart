import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'commons/themes/style_simple/theme.dart';
import 'routes/app_router.dart';
import 'core/dependency_injection.dart';
import 'logic/cubits/auth/auth_cubit.dart';
import 'logic/cubits/job/job_cubit.dart';
import 'logic/cubits/application/application_cubit.dart';
import 'logic/cubits/notification/notification_cubit.dart';
import 'logic/cubits/saved_jobs/saved_jobs_cubit.dart';
import 'commons/language_provider.dart';
import 'generated/s.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
        // Core cubits that are needed globally
        BlocProvider(
          create: (_) => getIt<AuthCubit>()..checkAuthStatus(),
        ),
        BlocProvider(
          create: (_) => getIt<JobCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<ApplicationCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<NotificationCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<SavedJobsCubit>(),
        ),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp.router(
            title: 'Navigui',
            theme: AppTheme.lightTheme,
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.router,

            // 🌍 LOCALIZATION SETUP
            locale: languageProvider.currentLocale, // Current selected language
            localizationsDelegates: const [
              S.delegate, // Your custom translations
              GlobalMaterialLocalizations.delegate, // Material widgets
              GlobalWidgetsLocalizations.delegate, // Text direction
              GlobalCupertinoLocalizations.delegate, // iOS-style widgets
            ],
            supportedLocales: S.delegate.supportedLocales, // [en, ar, fr]
          );
        },
      ),
    );
  }
}
