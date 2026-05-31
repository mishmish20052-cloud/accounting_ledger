import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(); // أزل التعليق إذا استخدمت Firebase مستقبلاً
  runApp(ProviderScope(child: App()));
}
