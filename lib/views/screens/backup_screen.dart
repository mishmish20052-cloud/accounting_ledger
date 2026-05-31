import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../services/backup_service.dart';

class BackupScreen extends StatelessWidget {
  const BackupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('النسخ الاحتياطي للأمان'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.cloud_sync_outlined,
              size: 100,
              color: Color(0xFF0F5132),
            ),
            const SizedBox(height: 24),
            const Text(
              'احمِ بياناتك المالية من الضياع',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'يمكنك تصدير نسخة احتياطية من جميع الحسابات والقيود ومشاركتها أو حفظها، كما يمكنك استعادتها في أي وقت ومن أي جهاز آخر.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 40),

            // زر التصدير والمشاركة
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                try {
                  await BackupService.exportBackup();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم تصدير النسخة الاحتياطية بنجاح!')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('فشل التصدير، تحقق من الصلاحيات')),
                    );
                  }
                }
              },
              icon: const Icon(Icons.upload_outlined),
              label: const Text('تصدير نسخة احتياطية الآن', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 16),

            // زر الاستيراد والاستعادة
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
                side: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                // فتح مستعرض الملفات لاختيار ملف قاعدة البيانات المستورد
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.any, 
                );

                if (result != null && result.files.single.path != null) {
                  final success = await BackupService.importBackup(result.files.single.path!);
                  if (context.mounted) {
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم استيراد البيانات بنجاح! يرجى إعادة تشغيل التطبيق.')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('فشل الاستيراد، تأكد من صحة الملف')),
                      );
                    }
                  }
                }
              },
              icon: const Icon(Icons.download_outlined),
              label: const Text('استيراد واستعادة نسخة سابقة', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
