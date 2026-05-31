import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsState {
  final String themeMode;
  final String language;
  SettingsState({required this.themeMode, required this.language});
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(SettingsState(themeMode: 'light', language: 'ar'));

  void toggleTheme(String mode) {
    state = SettingsState(themeMode: mode, language: state.language);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('المظهر الداكن'),
            trailing: Switch(
              value: settings.themeMode == 'dark',
              onChanged: (value) {
                ref.read(settingsProvider.notifier).toggleTheme(value ? 'dark' : 'light');
              },
            ),
          ),
        ],
      ),
    );
  }
}
