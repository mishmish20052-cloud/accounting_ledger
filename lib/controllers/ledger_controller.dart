import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/account.dart';
import '../models/transaction.dart';
import '../services/database_service.dart';

// متحكم الحسابات
class AccountListNotifier extends StateNotifier<List<Account>> {
  AccountListNotifier() : super([]) {
    refreshAccounts();
  }

  Future<void> refreshAccounts() async {
    final accounts = await DatabaseService.instance.getAllAccounts();
    state = accounts;
  }

  Future<void> addAccount(Account account) async {
    await DatabaseService.instance.insertAccount(account);
    await refreshAccounts();
  }
}

final accountListProvider =
    StateNotifierProvider<AccountListNotifier, List<Account>>((ref) {
  return AccountListNotifier();
});

// متحكم الحركات المالية - يقبل accountId
class TransactionListNotifier extends StateNotifier<List<TransactionModel>> {
  final String accountId;

  TransactionListNotifier(this.accountId) : super([]) {
    _load();
  }

  Future<void> _load() async {
    final list =
        await DatabaseService.instance.getTransactionsForAccount(accountId);
    state = list;
  }

  Future<void> addTransaction(TransactionModel tx) async {
    await DatabaseService.instance.insertTransaction(tx);
    await _load();
  }
}

final transactionListProvider = StateNotifierProvider.family<
    TransactionListNotifier,
    List<TransactionModel>,
    String>((ref, accountId) {
  return TransactionListNotifier(accountId);
});
