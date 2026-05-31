import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/ledger_controller.dart';
import '../../utils/app_constants.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // مراقبة جلب الحسابات لحساب الإجماليات بشكل حي ومباشر
    final accounts = ref.watch(accountListProvider);

    double totalDebit = 0;  // إجمالي المبالغ المخلوقة (لنا)
    double totalCredit = 0; // إجمالي المبالغ المستحقة (علينا)

    for (final acc in accounts) {
      totalDebit += acc.totalDebit;
      totalCredit += acc.totalCredit;
    }

    final double netBalance = totalDebit - totalCredit;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        automaticallyImplyLeading: false, // منع زر الرجوع لشاشة الـ PIN
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- كارت ملخص صافي الرصيد العام ---
            Card(
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      'صافي الرصيد العام',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${netBalance.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- صف يحتوي على إجمالي الدائن وإجمالي المدين ---
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text('إجمالي المدين (لنا)', style: TextStyle(color: Colors.grey)),
                          const SizedBox(height: 6),
                          Text(
                            totalDebit.toStringAsFixed(2),
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text('إجمالي الدائن (علينا)', style: TextStyle(color: Colors.grey)),
                          const SizedBox(height: 6),
                          Text(
                            totalCredit.toStringAsFixed(2),
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            const Text(
              'الوصول السريع للأقسام',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // --- شبكة الأزرار للانتقال لملفات الشاشات الأخرى ---
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
              children: [
                _buildMenuButton(
                  context,
                  title: 'إدارة الحسابات',
                  icon: Icons.people_alt_outlined,
                  color: Colors.blue.shade700,
                  route: '/accounts',
                ),
                _buildMenuButton(
                  context,
                  title: 'التقارير المالية',
                  icon: Icons.analytics_outlined,
                  color: Colors.purple.shade700,
                  route: '/reports',
                ),
                _buildMenuButton(
                  context,
                  title: 'النسخ الاحتياطي',
                  icon: Icons.cloud_upload_outlined,
                  color: Colors.amber.shade800,
                  route: '/backup',
                ),
                _buildMenuButton(
                  context,
                  title: 'إعدادات التطبيق',
                  icon: Icons.settings_outlined,
                  color: Colors.blueGrey.shade700,
                  route: '/settings',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // دالة مساعدة لبناء أزرار القائمة الرائعة
  Widget _buildMenuButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required String route,
  }) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
