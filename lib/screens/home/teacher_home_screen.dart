import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/iraqi_theme.dart';

/// Home screen for teachers.
class TeacherHomeScreen extends StatelessWidget {
  const TeacherHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('أجيال الرافدين - معلم'),
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
                  gradient: const LinearGradient(
                    colors: [IraqiTheme.palmGreen, IraqiTheme.tigrisTeal],
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مرحباً، ${user?.displayName ?? "معلم"}!',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: IraqiTheme.lightText,
                              ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'لوحة تحكم المعلم',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: IraqiTheme.lightText.withAlpha(204),
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Dashboard items
            _TeacherDashboardItem(
              icon: Icons.library_books_rounded,
              title: 'المناهج الدراسية',
              subtitle: 'إدارة المحتوى التعليمي',
              color: IraqiTheme.ishtarBlue,
              onTap: () {},
            ),
            _TeacherDashboardItem(
              icon: Icons.video_library_rounded,
              title: 'الدروس',
              subtitle: 'إضافة وتعديل الدروس',
              color: IraqiTheme.tigrisTeal,
              onTap: () {},
            ),
            _TeacherDashboardItem(
              icon: Icons.quiz_rounded,
              title: 'الاختبارات',
              subtitle: 'إنشاء اختبارات جديدة',
              color: IraqiTheme.primaryGold,
              onTap: () {},
            ),
            _TeacherDashboardItem(
              icon: Icons.people_rounded,
              title: 'طلابي',
              subtitle: 'متابعة تقدم الطلاب',
              color: IraqiTheme.palmGreen,
              onTap: () {},
            ),
            _TeacherDashboardItem(
              icon: Icons.analytics_rounded,
              title: 'التقارير',
              subtitle: 'تقارير الأداء والتحليلات',
              color: IraqiTheme.terracotta,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _TeacherDashboardItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _TeacherDashboardItem({
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
