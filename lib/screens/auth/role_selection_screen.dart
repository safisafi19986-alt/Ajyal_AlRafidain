import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_role.dart';
import '../../providers/auth_provider.dart';
import '../../theme/iraqi_theme.dart';
import '../../widgets/iraqi_pattern_background.dart';
import '../../widgets/loading_overlay.dart';
import 'registration_screen.dart';

/// Role selection screen after initial phone auth.
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return Scaffold(
          body: LoadingOverlay(
            isLoading: authProvider.isLoading,
            child: IraqiPatternBackground(
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 60),
                      Text(
                        'اختر نوع الحساب',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(color: IraqiTheme.lightText),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'كيف تريد استخدام أجيال الرافدين؟',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(
                              color: IraqiTheme.lightText.withAlpha(204),
                            ),
                      ),
                      const SizedBox(height: 40),
                      // Role cards
                      _RoleCard(
                        role: UserRole.student,
                        icon: Icons.school_rounded,
                        description: 'تعلّم واستكشف الدروس والألعاب التعليمية',
                        color: IraqiTheme.tigrisTeal,
                      ),
                      const SizedBox(height: 16),
                      _RoleCard(
                        role: UserRole.parent,
                        icon: Icons.family_restroom_rounded,
                        description: 'تابع تقدم أبنائك وتقاريرهم الدراسية',
                        color: IraqiTheme.primaryGold,
                      ),
                      const SizedBox(height: 16),
                      _RoleCard(
                        role: UserRole.teacher,
                        icon: Icons.person_rounded,
                        description: 'أنشئ المحتوى التعليمي وتابع طلابك',
                        color: IraqiTheme.palmGreen,
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RoleCard extends StatelessWidget {
  final UserRole role;
  final IconData icon;
  final String description;
  final Color color;

  const _RoleCard({
    required this.role,
    required this.icon,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => RegistrationScreen(selectedRole: role),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: color.withAlpha(31),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      role.displayName,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_back_ios_new_rounded,
                color: IraqiTheme.darkText.withAlpha(128),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
