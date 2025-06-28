import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocket_tasks/models/todo.dart';
import 'package:pocket_tasks/providers/theme_provider.dart';
import 'package:pocket_tasks/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  await Hive.openBox<Todo>('todos');
  await Hive.openBox<bool>('theme');
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
    ),
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final isDark = ref.watch(themeProvider);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Pocket Tasks',
          theme: ThemeData.light().copyWith(
            primaryColor: Colors.deepPurple,
            scaffoldBackgroundColor: Colors.grey[200],
          ),
          darkTheme: ThemeData.dark().copyWith(
            primaryColor: Colors.deepPurpleAccent,
            scaffoldBackgroundColor: Colors.grey[900],
          ),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          home: const Home(),
        );
      },
    );
  }
}
