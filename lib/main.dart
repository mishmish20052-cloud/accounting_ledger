import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'services/database_service.dart';

void main() async {
  // التأكد من تهيئة روابط منصة فلاتر بشكل صحيح قبل بدء أي عمليات خلفية
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // تهيئة قاعدة البيانات المحاسبية المحسنة (Local SQLite Database) عند الإقلاع
    await DatabaseService.instance.database;
  } catch (e) {
    // طباعة الخطأ في بيئة التطوير إذا حدثت مشكلة أثناء تهيئة قاعدة البيانات
    debugPrint('Database initialization error: $e');
  }

  runApp(
    // تغليف التطبيق بالكامل داخل ProviderScope لتفعيل إدارة الحالة الذكية عبر Riverpod
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
