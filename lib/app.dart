import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'controllers/auth_controller.dart';
import 'controllers/settings_controller.dart';
import 'utils/theme.dart';
import 'views/screens/pin_screen.dart';
import 'views/screens/dashboard_screen.dart';
import 'views/screens/account_list_screen.dart';
import 'views/screens/transaction_form_screen.dart';
import 'views/screens/reports_screen.dart';
import 'views/screens/settings_screen.dart';
import 'views/screens/backup_restore_screen.dart';

class App extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final settings = ref.watch(settingsProvider);
    final locale = settings.language == LanguageType.ar ? Locale('ar') : Locale('en');
    final themeMode = settings.themeMode == ThemeModeType.light
        ? ThemeMode.light
        : settings.themeMode == ThemeModeType.dark
            ? ThemeMode.dark
            : ThemeMode.system;

    return MaterialApp(
      title: 'دفتر الأستاذ',
      theme: AppTheme.lightTheme(null),
      darkTheme: AppTheme.darkTheme(null),
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('en'), Locale('ar')],
      home: auth.status == AuthStatus.authenticated ? DashboardScreen() : PinScreen(),
      routes: {
        '/accounts': (_) => AccountListScreen(),
        '/addTransaction': (_) => TransactionFormScreen(),
        '/reports': (_) => ReportsScreen(),
        '/settings': (_) => SettingsScreen(),
        '/backup': (_) => BackupRestoreScreen(),
      },
      builder: (context, child) {
        final direction = settings.language == LanguageType.ar ? TextDirection.rtl : TextDirection.ltr;
        return Directionality(textDirection: direction, child: child!);
      },
    );
  }
}
