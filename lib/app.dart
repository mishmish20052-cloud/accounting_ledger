import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// استيراد المتحكمات (Controllers) لربط حالة التطبيق
import 'controllers/auth_controller.dart';
import 'controllers/settings_controller.dart';

// استيراد الواجهات والشاشات (Screens) التي قمت بإنشائها بنجاح
import 'views/screens/dashboard_screen.dart';
import 'views/screens/account_list_screen.dart';
import 'views/screens/transaction_list_screen.dart';
import 'views/screens/reports_screen.dart';
import 'views/screens/backup_screen.dart';
import 'views/screens/settings_screen.dart';
import 'views/screens/auth_screen.dart'; // شاشة قفل الأمان والـ PIN

// استيراد التنسيقات والقوالب (Themes) لضمان اتساق الألوان والخطوط
import 'utils/theme.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // مراقبة حالة المصادقة (هل التطبيق مقفل أم مفتوح؟)
    final authState = ref.watch(authProvider);
    // مراقبة إعدادات المستخدم (اللغة، والمظهر الليلي/النهاري)
    final settings = ref.watch(settingsProvider);

    // ضبط المظهر (ThemeMode) ديناميكياً بناءً على تفضيلات المستخدم
    ThemeMode currentThemeMode;
    if (settings.themeMode == 'dark') {
      currentThemeMode = ThemeMode.dark;
    } else if (settings.themeMode == 'light') {
      currentThemeMode = ThemeMode.light;
    } else {
      currentThemeMode = ThemeMode.system;
    }

    // تحديد واجهة البداية (Home) بناءً على حالة الأمان والـ PIN كود
    Widget getHomeScreen() {
      if (authState.status == AuthStatus.authenticated) {
        // إذا كان المستخدم مسجلاً لدخول صحيح أو أدخل الـ PIN بنجاح، يفتح لوحة التحكم فوراً
        return const DashboardScreen();
      } else {
        // إذا كان التطبيق مقفلاً بـ PIN كود، يوجه المستخدم لصفحة التحقق والأمان أولاً
        return const AuthScreen();
      }
    }

    return MaterialApp(
      title: 'دفتر الأستاذ المحاسبي',
      debugShowCheckedModeBanner: false,
      
      // إعدادات المظهر الموحد للتطبيق (النهاري والليلي)
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: currentThemeMode,

      // إعدادات اللغة الافتراضية والاتجاهات (دعم كامل وقوي للغة العربية والخطوط المحاسبية)
      locale: Locale(settings.language), // 'ar' أو 'en' تلقائياً
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', ''), // دعم العربية كخيار رئيسي وافتراضي
        Locale('en', ''), // دعم الإنجليزية
      ],

      // واجهة البداية الذكية
      home: getHomeScreen(),

      // شجرة المسارات (Routes) للتنقل السلس والسريع بين أجزاء التطبيق
      routes: {
        '/dashboard': (context) => const DashboardScreen(),
        '/accounts': (context) => const AccountListScreen(),
        '/reports': (context) => const ReportsScreen(),
        '/backup': (context) => const BackupScreen(),
        '/settings': (context) => const SettingsScreen(),
      },

      // بناء الاتجاهات لضمان انسيابية النصوص العربية من اليمين إلى اليسار تلقائياً
      builder: (context, child) {
        return Directionality(
          textDirection: settings.language == 'ar' ? TextDirection.rtl : TextDirection.ltr,
          child: child!,
        );
      },
    );
  }
}
