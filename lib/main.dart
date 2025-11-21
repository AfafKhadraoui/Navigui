import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'commons/themes/style_simple/theme.dart';
import 'routes/app_router.dart';
import 'logic/services/auth_service.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthService(),
      child: const NaviguiApp(),
    ),
  );
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
  }
}
