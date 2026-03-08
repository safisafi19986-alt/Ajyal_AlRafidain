import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/iraqi_theme.dart';

/// Home screen for Super Admin.
class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة تحكم المدير'),
        backgroundColor: IraqiTheme.iraqiRed,
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
            // Admin welcome
            Card(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [IraqiTheme.iraqiRed, IraqiTheme.terracotta],
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.admin_panel_settings_rounded,
                          color: IraqiTheme.lightText,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'مرحباً، ${user?.displayName ?? "مدير"}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(color: IraqiTheme.lightText),
                              ),
                              Text(
                                'لوحة تحكم مدير النظام',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color:
                                          IraqiTheme.lightText.withAlpha(204),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Stats row (placeholders)
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.people_rounded,
                    label: 'المستخدمين',
                    value: '--',
                    color: IraqiTheme.ishtarBlue,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatCard(
                    icon: Icons.school_rounded,
                    label: 'الطلاب',
                    value: '--',
                    color: IraqiTheme.tigrisTeal,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatCard(
                    icon: Icons.subscriptions_rounded,
                    label: 'الاشتراكات',
                    value: '--',
                    color: IraqiTheme.primaryGold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Admin menu
            Text(
              'إدارة النظام',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            _AdminMenuItem(
              icon: Icons.people_rounded,
              title: 'إدارة المستخدمين',
              subtitle: 'طلاب، أولياء أمور، معلمين',
              color: IraqiTheme.ishtarBlue,
              onTap: () {},
            ),
            _AdminMenuItem(
              icon: Icons.library_books_rounded,
              title: 'إدارة المناهج',
              subtitle: 'المواد والدروس والمحتوى',
              color: IraqiTheme.tigrisTeal,
              onTap: () {},
            ),
            _AdminMenuItem(
              icon: Icons.video_library_rounded,
              title: 'إدارة الفيديو',
              subtitle: 'البث التكيفي HLS',
              color: IraqiTheme.palmGreen,
              onTap: () {},
            ),
            _AdminMenuItem(
              icon: Icons.payment_rounded,
              title: 'الاشتراكات والمدفوعات',
              subtitle: 'خطط الاشتراك والإيرادات',
              color: IraqiTheme.primaryGold,
              onTap: () {},
            ),
            _AdminMenuItem(
              icon: Icons.analytics_rounded,
              title: 'التحليلات والتقارير',
              subtitle: 'إحصائيات النظام',
              color: IraqiTheme.terracotta,
              onTap: () {},
            ),
            _AdminMenuItem(
              icon: Icons.security_rounded,
              title: 'الأمان',
              subtitle: 'حماية المحتوى ومكافحة القرصنة',
              color: IraqiTheme.iraqiRed,
              onTap: () {},
            ),
            _AdminMenuItem(
              icon: Icons.notifications_rounded,
              title: 'الإشعارات',
              subtitle: 'إرسال إشعارات للمستخدمين',
              color: IraqiTheme.infoBlue,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _AdminMenuItem({
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
