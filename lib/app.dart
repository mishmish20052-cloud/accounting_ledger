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
    // ربط الـ settingsProvider المعرف في شاشة الإعدادات
    final settings = ref.watch(settingsProvider);

    return MaterialApp(
      title: 'دفتر الأستاذ المحاسبي',
      debugShowCheckedModeBanner: false,
      themeMode: settings.themeMode == 'dark' ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
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
