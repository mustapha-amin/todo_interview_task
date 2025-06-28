import 'package:PocketTasks/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeNotifier extends StateNotifier<bool> {
  Box<bool>? themeBox;
  ThemeNotifier({this.themeBox}) : super(false) {
    _loadTheme();
  }

  void _loadTheme() {
    final isDark = themeBox!.get('isDark', defaultValue: false);
    state = isDark!;
  }

  void toggleTheme() {
    state = !state;
    themeBox!.put('isDark', state);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier(themeBox: ref.read(themeBoxProvider));
});
