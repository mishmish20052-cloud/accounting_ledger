import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/account.dart';
import '../models/transaction.dart';
import '../services/database_service.dart';

// --- 1. متحكم إدارة الحسابات (Accounts Controller) ---
class AccountListNotifier extends StateNotifier<List<Account>> {
  AccountListNotifier() : super([]) {
    refreshAccounts(); // جلب الحسابات تلقائياً عند تشغيل التطبيق
  }

  // تحديث قائمة الحسابات من قاعدة البيانات
  Future<void> refreshAccounts() async {
    final accounts = await DatabaseService.instance.getAllAccounts();
    state = accounts;
  }

  // إضافة حساب جديد وتحديث القائمة فوراً
  Future<void> addAccount(Account account) async {
    await DatabaseService.instance.insertAccount(account);
    await refreshAccounts();
  }
}

// توفير متحكم الحسابات للواجهات
final accountListProvider = StateNotifierProvider<AccountListNotifier, List<Account>>((ref) {
  return AccountListNotifier();
});


// --- 2. متحكم إدارة القيود والعمليات (Transactions Controller) ---
class TransactionNotifier extends StateNotifier<List<TransactionModel>> {
  TransactionNotifier() : super([]);

  // جلب العمليات الخاصة بحساب معين
  Future<void> refreshTransactions(String accountId) async {
    final transactions = await DatabaseService.instance.getTransactionsForAccount(accountId);
    state = transactions;
  }

  // إضافة حركة مالية جديدة (له / عليه) وتحديث واجهة الحساب والحسابات العامة
  Future<void> addTransaction(TransactionModel tx, WidgetRef ref) async {
    await DatabaseService.instance.insertTransaction(tx);
    // تحديث قائمة الحركات للحساب الحالي
    await refreshTransactions(tx.accountId);
    // تحديث الأرصدة في قائمة الحسابات الرئيسية تلقائياً
    await ref.read(accountListProvider.notifier).refreshAccounts();
  }
}

// توفير متحكم العمليات للواجهات
final transactionProvider = StateNotifierProvider<TransactionNotifier, List<TransactionModel>>((ref) {
  return TransactionNotifier();
});
