import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocket_tasks/common/typedefs.dart';
import 'package:pocket_tasks/models/todo.dart';

class TodoDB {
  Box<Todo> todosBox;

  TodoDB({required this.todosBox});

  Future<int> addTodo({Todo? todo}) async {
    return await todosBox.add(todo!);
  }

  FutureVoid editTodo(int? key, Todo? todo) async {
    await todosBox.put(key!, todo!);
  }

  FutureVoid deleteTodo(Todo? todo) async {
    await todo!.delete();
  }

  ListTodo fetchTodos() {
    final todos = todosBox.values.toList();
    todos.sort((a, b) => b.dueDate!.compareTo(a.dueDate!));
    return todos;
  }

  Todo fetchTodoAt(int key) {
    return todosBox.values.firstWhere((todo) => todo.key == key);
  }

  FutureVoid toggleComplete(Todo todo) async {
    await todosBox.put(todo.key, todo.copyWith(completed: !todo.completed!));
  }
}
