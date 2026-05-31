import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/ledger_controller.dart';
import '../../models/account.dart';
import '../../models/transaction.dart';

class TransactionListScreen extends ConsumerWidget {
  final Account account;

  const TransactionListScreen({super.key, required this.account});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // جلب ومراقبة الحركات المالية الخاصة بهذا الحساب المحدد فقط
    final transactions = ref.watch(transactionListProvider(account.id));

    return Scaffold(
      appBar: AppBar(
        title: Text('كشف حساب: ${account.name}'),
      ),
      body: Column(
        children: [
          // --- بطاقة ملخص الحساب بالأعلى ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).primaryColor.withOpacity(0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem('إجمالي له (مدين)', account.totalDebit, Colors.green),
                _buildSummaryItem('إجمالي عليه (دائن)', account.totalCredit, Colors.red),
              ],
            ),
          ),
          const Divider(height: 1),

          // --- قائمة القيود والحركات المضافة ---
          Expanded(
            child: transactions.isEmpty
                ? const Center(
                    child: Text(
                      'لا توجد عمليات مسجلة لهذا الحساب.\nاضغط (+) لإضافة أول قيد.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final tx = transactions[index];
                      final isDebit = tx.type == 'debit';

                      return Card(
                        elevation: 1,
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isDebit ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                            child: Icon(
                              isDebit ? Icons.arrow_downward : Icons.arrow_upward,
                              color: isDebit ? Colors.green : Colors.red,
                            ),
                          ),
                          title: Text(
                            tx.description.isEmpty ? (isDebit ? 'دفعة مدونة (له)' : 'دفعة مستحقة (عليه)') : tx.description,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            '${tx.date.year}-${tx.date.month.toString().padLeft(2, '0')}-${tx.date.day.toString().padLeft(2, '0')}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          trailing: Text(
                            tx.amount.toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDebit ? Colors.green : Colors.red,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      // زر مخصص لإضافة حركة مالية جديدة (قيد)
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTransactionDialog(context, ref),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add_chart),
      ),
    );
  }

  Widget _buildSummaryItem(String label, double val, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          val.toStringAsFixed(2),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  // نافذة منبثقة ذكية لتقييد حركة مالية جديدة (مدين / دائن)
  void _showAddTransactionDialog(BuildContext context, WidgetRef ref) {
    final amountController = TextEditingController();
    final descController = TextEditingController();
    String transactionType = 'debit'; // القيمة الافتراضية: مدين (له)

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('تسجيل قيد مالي جديد', textAlign: TextAlign.center),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // اختيار نوع العملية عبر أزرار الراديو
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio<String>(
                      value: 'debit',
                      groupValue: transactionType,
                      activeColor: Colors.green,
                      onChanged: (val) => setState(() => transactionType = val!),
                    ),
                    const Text('مدين (له)', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 16),
                    Radio<String>(
                      value: 'credit',
                      groupValue: transactionType,
                      activeColor: Colors.red,
                      onChanged: (val) => setState(() => transactionType = val!),
                    ),
                    const Text('دائن (عليه)', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amountController,
                  decoration: const InputDecoration(
                    labelText: 'المبلغ المالي *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  autofocus: true,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: 'البيان / التفاصيل (اختياري)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
              onPressed: () async {
                final amountStr = amountController.text.trim();
                final double? amount = double.tryParse(amountStr);
                if (amount == null || amount <= 0) return;

                final newTx = TransactionModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  accountId: account.id,
                  amount: amount,
                  type: transactionType,
                  description: descController.text.trim(),
                  date: DateTime.now(),
                );

                // حفظ الحركة المالية وتحديث كشف الحساب والصفحة الرئيسية فوراً
                await ref.read(transactionListProvider(account.id).notifier).addTransaction(newTx);
                
                // تحديث بيانات الحساب نفسه ليعكس الإجماليات الجديدة
                await ref.read(accountListProvider.notifier).refreshAccounts();

                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('تسجيل القيد', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
