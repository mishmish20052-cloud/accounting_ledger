import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/account.dart';
import '../models/transaction.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('ledger.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // إنشاء جدول الحسابات
    await db.execute('''
    CREATE TABLE accounts (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      phone TEXT,
      total_debit REAL DEFAULT 0.0,
      total_credit REAL DEFAULT 0.0,
      created_at TEXT NOT NULL
    )
    ''');

    // إنشاء جدول العمليات المالية
    await db.execute('''
    CREATE TABLE transactions (
      id TEXT PRIMARY KEY,
      account_id TEXT NOT NULL,
      amount REAL NOT NULL,
      type TEXT NOT NULL,
      description TEXT,
      date TEXT NOT NULL,
      FOREIGN KEY (account_id) REFERENCES accounts (id) ON DELETE CASCADE
    )
    ''');
  }

  // --- عمليات الحسابات (Accounts Operations) ---
  Future<void> insertAccount(Account account) async {
    final db = await instance.database;
    await db.insert('accounts', account.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Account>> getAllAccounts() async {
    final db = await instance.database;
    final result = await db.query('accounts', orderBy: 'name ASC');
    return result.map((json) => Account.fromMap(json)).toList();
  }

  // --- عمليات القيود والعمليات المالية (Transactions Operations) ---
  Future<void> insertTransaction(TransactionModel tx) async {
    final db = await instance.database;
    
    await db.transaction((txn) async {
      // 1. حفظ الحركة المالية
      await txn.insert('transactions', tx.toMap());

      // 2. تحديث الأرصدة الإجمالية في جدول الحساب الخاص بها تلقائياً
      if (tx.type == 'debit') {
        await txn.execute(
          'UPDATE accounts SET total_debit = total_debit + ? WHERE id = ?',
          [tx.amount, tx.accountId],
        );
      } else {
        await txn.execute(
          'UPDATE accounts SET total_credit = total_credit + ? WHERE id = ?',
          [tx.amount, tx.accountId],
        );
      }
    });
  }

  Future<List<TransactionModel>> getTransactionsForAccount(String accountId) async {
    final db = await instance.database;
    final result = await db.query(
      'transactions',
      where: 'account_id = ?',
      whereArgs: [accountId],
      orderBy: 'date DESC',
    );
    return result.map((json) => TransactionModel.fromMap(json)).toList();
  }

  Future<void> close() async {
    final db = await _database;
    if (db != null) {
      await db.close();
    }
  }
}
