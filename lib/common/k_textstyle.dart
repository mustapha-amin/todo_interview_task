import 'package:PocketTasks/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

TextStyle kTextStyle(
  double fontSize,
  WidgetRef ref, {
  Color? color,
  FontWeight? fontWeight,
}) {
  return TextStyle(
    fontSize: fontSize,
    color: color ??= ref.watch(themeProvider) ? Colors.white : Colors.black,
    fontWeight: fontWeight ?? FontWeight.bold,
    fontFamily: 'Geist'
  );
}
