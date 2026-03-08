import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../providers/auth_provider.dart';
import '../../theme/iraqi_theme.dart';

/// Home screen for students showing their unique code and dashboard.
class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;
    final student = authProvider.studentProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('أجيال الرافدين'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => authProvider.signOut(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome card
            Card(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: IraqiTheme.mesopotamianGradient,
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مرحباً، ${user?.displayName ?? "طالب"}!',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: IraqiTheme.lightText,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'الصف ${student?.grade ?? 4} | أجيال الرافدين',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: IraqiTheme.lightText.withAlpha(204),
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Student unique code card
            if (student != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'رمزك الفريد',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'شارك هذا الرمز مع ولي أمرك لربط حسابك',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      // QR Code
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: IraqiTheme.primaryGold,
                            width: 2,
                          ),
                        ),
                        child: QrImageView(
                          data: student.uniqueCode,
                          version: QrVersions.auto,
                          size: 150,
                          eyeStyle: const QrEyeStyle(
                            eyeShape: QrEyeShape.circle,
                            color: IraqiTheme.ishtarBlue,
                          ),
                          dataModuleStyle: const QrDataModuleStyle(
                            dataModuleShape: QrDataModuleShape.circle,
                            color: IraqiTheme.ishtarBlue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Code text
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: IraqiTheme.desertSand,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SelectableText(
                          student.uniqueCode,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                letterSpacing: 2,
                                fontWeight: FontWeight.w700,
                                color: IraqiTheme.ishtarBlue,
                              ),
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            // Dashboard placeholders
            Text(
              'الدروس',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            _DashboardCard(
              icon: Icons.play_lesson_rounded,
              title: 'دروسي',
              subtitle: 'استكمل دروسك التعليمية',
              color: IraqiTheme.tigrisTeal,
              onTap: () {},
            ),
            _DashboardCard(
              icon: Icons.quiz_rounded,
              title: 'الاختبارات',
              subtitle: 'اختبر معلوماتك',
              color: IraqiTheme.primaryGold,
              onTap: () {},
            ),
            _DashboardCard(
              icon: Icons.games_rounded,
              title: 'الألعاب التعليمية',
              subtitle: 'تعلم وأنت تلعب',
              color: IraqiTheme.palmGreen,
              onTap: () {},
            ),
            _DashboardCard(
              icon: Icons.bar_chart_rounded,
              title: 'تقاريري',
              subtitle: 'تابع تقدمك الدراسي',
              color: IraqiTheme.terracotta,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withAlpha(31),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 16,
          color: IraqiTheme.darkText.withAlpha(128),
        ),
        onTap: onTap,
      ),
    );
  }
}
