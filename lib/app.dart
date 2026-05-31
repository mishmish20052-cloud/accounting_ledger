import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controllers/auth_controller.dart';
import 'controllers/settings_controller.dart';

import 'views/screens/dashboard_screen.dart';
import 'views/screens/account_list_screen.dart';
import 'views/screens/transaction_list_screen.dart';
import 'views/screens/reports_screen.dart';
import 'views/screens/backup_screen.dart';
import 'views/screens/settings_screen.dart';
import 'views/screens/auth_screen.dart'; 

import 'utils/theme.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final settings = ref.watch(settingsProvider);

    ThemeMode currentThemeMode = ThemeMode.system;
    if (settings.themeMode == 'dark') {
      currentThemeMode = ThemeMode.dark;
    } else if (settings.themeMode == 'light') {
      currentThemeMode = ThemeMode.light;
    }

    Widget getHomeScreen() {
      if (authState.status == AuthStatus.authenticated) {
        return const DashboardScreen();
      } else {
        return const AuthScreen();
      }
    }

    return MaterialApp(
      title: 'دفتر الأستاذ',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: currentThemeMode,
      locale: Locale(settings.language),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', ''),
        Locale('en', ''),
      ],
      home: getHomeScreen(),
      routes: {
        '/dashboard': (context) => const DashboardScreen(),
        '/accounts': (context) => const AccountListScreen(),
        '/reports': (context) => const ReportsScreen(),
        '/backup': (context) => const BackupScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
