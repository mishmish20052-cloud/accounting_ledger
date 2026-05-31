import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'database_service.dart';

class BackupService {
  // تصدير قاعدة البيانات كملف للنسخ الاحتياطي ومشاركته
  static Future<void> exportBackup() async {
    final dbPath = await getDatabasesPath();
    final sourcePath = join(dbPath, 'ledger.db');
    final sourceFile = File(sourcePath);

    if (await sourceFile.exists()) {
      // الحصول على مجلد المستندات الخارجي المؤقت للمشاركة
      final outputDir = await getTemporaryDirectory();
      final backupPath = join(outputDir.path, 'دفتر_الأستاذ_نسخة_احتياطية.db');
      
      // نسخ ملف قاعدة البيانات
      await sourceFile.copy(backupPath);

      // مشاركة الملف عبر تطبيقات الهاتف (واتساب، تيليجرام، إلخ)
      await Share.shareXFiles([XFile(backupPath)], text: 'نسخة احتياطية من قاعدة بيانات دفتر الأستاذ');
    }
  }

  // استيراد قاعدة البيانات من ملف خارجي تم اختياره
  static Future<bool> importBackup(String sourceFilePath) async {
    try {
      // إغلاق قاعدة البيانات الحالية أولاً قبل الاستبدال
      await DatabaseService.instance.close();

      final dbPath = await getDatabasesPath();
      final destinationPath = join(dbPath, 'ledger.db');

      final sourceFile = File(sourceFilePath);
      if (await sourceFile.exists()) {
        // استبدال قاعدة البيانات القديمة بالملف المستورد
        await sourceFile.copy(destinationPath);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
