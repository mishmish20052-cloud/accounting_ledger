import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/ledger_controller.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountListProvider);

    double totalDebit = 0;
    double totalCredit = 0;

    for (final acc in accounts) {
      totalDebit += acc.totalDebit;
      totalCredit += acc.totalCredit;
    }

    final double sum = totalDebit + totalCredit;
    // حساب النسب المئوية للتمثيل المرئي المبسط
    final double debitPercentage = sum > 0 ? (totalDebit / sum) : 0.5;
    final double creditPercentage = sum > 0 ? (totalCredit / sum) : 0.5;

    return Scaffold(
      appBar: AppBar(
        title: const Text('التقارير المالية الإحصائية'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'التحليل النسبي للرصيد العام',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // --- شريط مرئي يعبر عن الموازنة بين الديون (له / عليه) ---
            if (sum > 0) ...[
              Container(
                height: 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade200,
                ),
                clipBehavior: Clip.antiAlias,
                child: Row(
                  children: [
                    Expanded(
                      flex: (debitPercentage * 100).toInt(),
                      child: Container(color: Colors.green, child: const Center(child: Text('له', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)))),
                    ),
                    Expanded(
                      flex: (creditPercentage * 100).toInt(),
                      child: Container(color: Colors.red, child: const Center(child: Text('عليه', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)))),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('مدين (له): ${(debitPercentage * 100).toStringAsFixed(1)}%', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  Text('دائن (عليه): ${(creditPercentage * 100).toStringAsFixed(1)}%', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ],
              ),
            ] else ...[
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text('لا توجد بيانات كافية لإصدار تقرير نسبي حالياً.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                ),
              )
            ],

            const SizedBox(height: 32),
            const Text(
              'ملخص الأرقام الإجمالية',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // كارت إجمالي ما لك في السوق
            Card(
              child: ListTile(
                leading: const CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.trending_up, color: Colors.white)),
                title: const Text('إجمالي الديون الخارجية (لك)'),
                trailing: Text(totalDebit.toStringAsFixed(2), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
              ),
            ),
            const SizedBox(height: 8),

            // كارت إجمالي ما عليك التزامات
            Card(
              child: ListTile(
                leading: const CircleAvatar(backgroundColor: Colors.red, child: Icon(Icons.trending_down, color: Colors.white)),
                title: const Text('إجمالي الالتزامات (عليك)'),
                trailing: Text(totalCredit.toStringAsFixed(2), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
