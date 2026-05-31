import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/ledger_controller.dart';
import '../../models/account.dart';
import 'transaction_list_screen.dart';

class AccountListScreen extends ConsumerWidget {
  const AccountListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // مراقبة قائمة الحسابات بشكل حي
    final accounts = ref.watch(accountListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الحسابات'),
      ),
      body: accounts.isEmpty
          ? const Center(
              child: Text(
                'لا يوجد حسابات مضافة حتى الآن.\nاضغط على (+) لإضافة حساب جديد.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                final account = accounts[index];
                // حساب صافي رصيد العميل الحالي (مدين - دائن)
                final double balance = account.totalDebit - account.totalCredit;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    title: Text(
                      account.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.topDirectional.only(top: 4),
                      child: Text('هاتف: ${account.phone.isEmpty ? "غير مسجل" : account.phone}'),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('الرصيد الصافي', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text(
                          balance.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: balance >= 0 ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      // الانتقال لكشف حساب العميل وعرض الحركات المالية الخاصة به
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransactionListScreen(account: account),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddAccountDialog(context, ref),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  // نافذة منبثقة سريعة لإضافة حساب/عميل جديد
  void _showAddAccountDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة حساب جديد', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'اسم الحساب / العميل *'),
              autofocus: true,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'رقم الهاتف (اختياري)'),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isEmpty) return;

              final newAccount = Account(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: name,
                phone: phoneController.text.trim(),
                createdAt: DateTime.now(),
              );

              // إرسال البيانات للمتحكم لحفظها وتحديث الواجهة تلقائياً
              await ref.read(accountListProvider.notifier).addAccount(newAccount);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('حفظ', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
