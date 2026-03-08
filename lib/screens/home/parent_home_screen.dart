import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/iraqi_theme.dart';
import '../auth/link_student_screen.dart';

/// Home screen for parents.
class ParentHomeScreen extends StatelessWidget {
  const ParentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;
    final parent = authProvider.parentProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('أجيال الرافدين - ولي أمر'),
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
                  gradient: IraqiTheme.goldGradient,
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مرحباً، ${user?.displayName ?? "ولي أمر"}!',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: IraqiTheme.darkText,
                              ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'عدد الطلاب المرتبطين: ${parent?.linkedStudentIds.length ?? 0}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: IraqiTheme.darkText.withAlpha(179),
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Link student button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const LinkStudentScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add_link_rounded),
              label: const Text('ربط طالب جديد'),
              style: ElevatedButton.styleFrom(
                backgroundColor: IraqiTheme.ishtarBlue,
                foregroundColor: IraqiTheme.lightText,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 24),
            // Linked students section
            Text(
              'أبنائي',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            if (parent == null || parent.linkedStudentIds.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.people_outline_rounded,
                        size: 64,
                        color: IraqiTheme.darkText.withAlpha(77),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'لا يوجد طلاب مرتبطين بعد',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: IraqiTheme.darkText.withAlpha(128),
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'اضغط "ربط طالب جديد" وأدخل الرمز الفريد للطالب',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              ...parent.linkedStudentIds.map(
                (studentId) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: IraqiTheme.tigrisTeal.withAlpha(31),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.school_rounded,
                        color: IraqiTheme.tigrisTeal,
                      ),
                    ),
                    title: Text('طالب: $studentId'),
                    subtitle: const Text('اضغط لعرض التقارير'),
                    trailing: const Icon(Icons.arrow_back_ios_new_rounded,
                        size: 16),
                    onTap: () {},
                  ),
                ),
              ),
            const SizedBox(height: 24),
            // Dashboard items
            Text(
              'لوحة المتابعة',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: IraqiTheme.terracotta.withAlpha(31),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.analytics_rounded,
                      color: IraqiTheme.terracotta),
                ),
                title: const Text('تقارير الأداء'),
                subtitle: const Text('تقارير ذكية مدعومة بالذكاء الاصطناعي'),
                trailing: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
                onTap: () {},
              ),
            ),
            Card(
              child: ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: IraqiTheme.palmGreen.withAlpha(31),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.subscriptions_rounded,
                      color: IraqiTheme.palmGreen),
                ),
                title: const Text('الاشتراكات'),
                subtitle: const Text('إدارة خطط الاشتراك'),
                trailing: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
