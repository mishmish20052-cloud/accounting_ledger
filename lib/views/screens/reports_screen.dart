import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التقارير المالية'),
      ),
      body: const Center(
        child: Text(
          'لا توجد بيانات تقارير كافية حالياً',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
