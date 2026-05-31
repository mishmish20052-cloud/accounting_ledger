import 'package:flutter/material.dart';
import 'views/screens/dashboard_screen.dart';
import 'views/screens/transaction_list_screen.dart';
import 'views/screens/settings_screen.dart';
import 'views/screens/reports_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Accounting Ledger',
      debugShowCheckedModeBanner: false,
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
