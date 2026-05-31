import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class AuthNotifier extends StateNotifier<bool> {
  AuthNotifier() : super(false);

  // التحقق مما إذا كان المستخدم قد قام بتعيين رمز سري من قبل
  Future<bool> isPinSet() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(AppConstants.pinKey);
  }

  // تعيين رمز سري جديد لأول مرة
  Future<bool> setPin(String pin) async {
    if (pin.length < 4) return false;
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(AppConstants.pinKey, pin);
  }

  // التحقق من صحة الرمز السري عند فتح التطبيق
  Future<bool> verifyPin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    final savedPin = prefs.getString(AppConstants.pinKey);
    if (savedPin == pin) {
      state = true; // تم تسجيل الدخول بنجاح
      return true;
    }
    return false;
  }

  // تسجيل الخروج وقفل التطبيق مجدداً
  void logout() {
    state = false;
  }
}

// توفير المحرك لجميع واجهات التطبيق للاستخدام المباشر
final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier();
});
