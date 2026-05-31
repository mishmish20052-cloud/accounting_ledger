import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_constants.dart';

enum AuthStatus { authenticated, unauthenticated, initial }

class AuthState {
  final AuthStatus status;
  final String? errorMessage;

  const AuthState({required this.status, this.errorMessage});

  AuthState copyWith({AuthStatus? status, String? errorMessage}) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  AuthController() : super(const AuthState(status: AuthStatus.initial)) {
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final hasPin = prefs.containsKey(AppConstants.pinKey);
    if (hasPin) {
      state = const AuthState(status: AuthStatus.unauthenticated);
    } else {
      state = const AuthState(status: AuthStatus.authenticated);
    }
  }

  Future<bool> verifyPin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    final savedPin = prefs.getString(AppConstants.pinKey);
    if (savedPin == pin) {
      state = const AuthState(status: AuthStatus.authenticated);
      return true;
    }
    state = const AuthState(status: AuthStatus.unauthenticated, errorMessage: 'رمز PIN غير صحيح');
    return false;
  }

  Future<void> savePin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.pinKey, pin);
    state = const AuthState(status: AuthStatus.authenticated);
  }
}

final authProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController();
});
