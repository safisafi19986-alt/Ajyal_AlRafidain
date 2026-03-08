import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'models/user_role.dart';
import 'providers/auth_provider.dart';
import 'screens/admin/admin_home_screen.dart';
import 'screens/auth/phone_login_screen.dart';
import 'screens/auth/role_selection_screen.dart';
import 'screens/home/parent_home_screen.dart';
import 'screens/home/student_home_screen.dart';
import 'screens/home/teacher_home_screen.dart';
import 'screens/splash_screen.dart';
import 'theme/iraqi_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Lock orientation to portrait for mobile
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const AjyalAlRafidainApp());
}

/// Root widget for Ajyal Al-Rafidain app.
class AjyalAlRafidainApp extends StatelessWidget {
  const AjyalAlRafidainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'أجيال الرافدين',
        debugShowCheckedModeBanner: false,
        theme: IraqiTheme.buildTheme(),
        // RTL support for Arabic
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },
        home: const AuthGate(),
      ),
    );
  }
}

/// Auth gate that routes users based on authentication state.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        switch (authProvider.authState) {
          case AuthState.initial:
            return const SplashScreen();

          case AuthState.unauthenticated:
          case AuthState.error:
          case AuthState.otpSent:
            return const PhoneLoginScreen();

          case AuthState.needsRegistration:
            return const RoleSelectionScreen();

          case AuthState.authenticated:
            return _getHomeScreen(authProvider.currentUser!.role);
        }
      },
    );
  }

  Widget _getHomeScreen(UserRole role) {
    switch (role) {
      case UserRole.student:
        return const StudentHomeScreen();
      case UserRole.parent:
        return const ParentHomeScreen();
      case UserRole.teacher:
        return const TeacherHomeScreen();
      case UserRole.superAdmin:
        return const AdminHomeScreen();
    }
  }
}
