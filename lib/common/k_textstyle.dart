import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_tasks/providers/theme_provider.dart';

TextStyle kTextStyle(
  double fontSize,
  WidgetRef ref, {
  Color? color,
  FontWeight? fontWeight,
}) {
  return TextStyle(
    fontSize: fontSize,
    color: color ??= ref.watch(themeProvider) ? Colors.white : Colors.black,
    fontWeight: FontWeight.bold,
  );
}
