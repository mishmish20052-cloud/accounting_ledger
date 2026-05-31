import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'views/screens/dashboard_screen.dart';
import 'views/screens/transaction_list_screen.dart';
import 'views/screens/settings_screen.dart';
import 'views/screens/reports_screen.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Accounting Ledger',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light, // ثبتنا الوضع الفاتح مؤقتاً لمنع أي تضارب أو ترجمة خاطئة
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const DashboardScreen(),
        '/accounts': (context) => const TransactionListScreen(),
        '/reports': (context) => const ReportsScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
