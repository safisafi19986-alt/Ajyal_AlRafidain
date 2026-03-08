import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_role.dart';
import '../../providers/auth_provider.dart';
import '../../theme/iraqi_theme.dart';
import '../../widgets/iraqi_pattern_background.dart';
import '../../widgets/loading_overlay.dart';

/// Registration screen for new users after selecting a role.
class RegistrationScreen extends StatefulWidget {
  final UserRole selectedRole;

  const RegistrationScreen({super.key, required this.selectedRole});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthProvider>().completeRegistration(
          role: widget.selectedRole,
          displayName: _nameController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return Scaffold(
          body: LoadingOverlay(
            isLoading: authProvider.isLoading,
            message: 'جاري إنشاء الحساب...',
            child: IraqiPatternBackground(
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      // Back button
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: IraqiTheme.lightText,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Role icon
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: IraqiTheme.primaryGold.withAlpha(51),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getRoleIcon(widget.selectedRole),
                          size: 50,
                          color: IraqiTheme.primaryGold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'إنشاء حساب ${widget.selectedRole.displayName}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(color: IraqiTheme.lightText),
                      ),
                      const SizedBox(height: 32),
                      // Registration form
                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'المعلومات الشخصية',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                                // Name field
                                TextFormField(
                                  controller: _nameController,
                                  textDirection: TextDirection.rtl,
                                  decoration: const InputDecoration(
                                    labelText: 'الاسم الكامل',
                                    prefixIcon: Icon(
                                      Icons.person_outline_rounded,
                                      color: IraqiTheme.ishtarBlue,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().isEmpty) {
                                      return 'يرجى إدخال الاسم';
                                    }
                                    if (value.trim().length < 3) {
                                      return 'الاسم يجب أن يكون 3 أحرف على الأقل';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                // Error message
                                if (authProvider.errorMessage != null)
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 16),
                                    child: Text(
                                      authProvider.errorMessage!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: IraqiTheme.errorRed,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                // Register button
                                ElevatedButton(
                                  onPressed: authProvider.isLoading
                                      ? null
                                      : _onRegister,
                                  child: const Text('إنشاء الحساب'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.student:
        return Icons.school_rounded;
      case UserRole.parent:
        return Icons.family_restroom_rounded;
      case UserRole.teacher:
        return Icons.person_rounded;
      case UserRole.superAdmin:
        return Icons.admin_panel_settings_rounded;
    }
  }
}
