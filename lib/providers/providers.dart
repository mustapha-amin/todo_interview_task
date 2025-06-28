import 'package:PocketTasks/common/typedefs.dart';
import 'package:PocketTasks/models/todo.dart';
import 'package:PocketTasks/notifiers/todo_state_notifier.dart';
import 'package:PocketTasks/services/todo_db.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
final todoBoxProvider = Provider<Box<Todo>>((ref) {
  return Hive.box<Todo>('todos');
});

final themeBoxProvider = Provider<Box<bool>>((ref) {
  return Hive.box<bool>('theme');
});

final todoDBProvider = Provider<TodoDB>((ref) {
  return TodoDB(todosBox: ref.read(todoBoxProvider));
});

final todoNotifierProvider = StateNotifierProvider<TodoNotifier, ListTodo>((
  ref,
) {
  return TodoNotifier(todoDB: ref.read(todoDBProvider));
});
