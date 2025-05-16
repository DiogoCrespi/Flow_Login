import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';
import 'shared/controllers/auth_controller.dart';
import 'shared/controllers/theme_controller.dart';
import 'shared/database/database_helper.dart';
import 'shared/repositories/user_repository.dart';
import 'shared/themes/light_theme.dart';
import 'shared/themes/dark_theme.dart';
import 'features/splash/splash_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/login/login_screen.dart';
import 'features/login/register_screen.dart';
import 'features/login/forgot_password_screen.dart';
import 'features/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o SQLite para desktop
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  final prefs = await SharedPreferences.getInstance();
  final databaseHelper = DatabaseHelper();
  final userRepository = UserRepository(databaseHelper);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeController(prefs),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthController(userRepository),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();

    return MaterialApp(
      title: 'FlowLogin',
      theme: LightTheme.theme,
      darkTheme: DarkTheme.theme,
      themeMode: themeController.themeMode.value,
      home: const SplashScreen(),
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
