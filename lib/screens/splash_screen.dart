import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/iraqi_theme.dart';

/// Splash screen shown on app start while checking auth state.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();

    // Check existing session
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        context.read<AuthProvider>().checkExistingSession();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: IraqiTheme.mesopotamianGradient,
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo placeholder
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: IraqiTheme.primaryGold.withAlpha(51),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: IraqiTheme.primaryGold,
                      width: 3,
                    ),
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    size: 70,
                    color: IraqiTheme.primaryGold,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'أجيال الرافدين',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: IraqiTheme.lightText,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ajyal Al-Rafidain',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: IraqiTheme.primaryGold,
                        letterSpacing: 2,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'تعليم عراقي بهوية حضارية',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: IraqiTheme.lightText.withAlpha(179),
                      ),
                ),
                const SizedBox(height: 48),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    IraqiTheme.primaryGold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
