import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_tasks/common/typedefs.dart';
import 'package:pocket_tasks/models/todo.dart';
import 'package:pocket_tasks/services/todo_db.dart';

class TodoNotifier extends StateNotifier<List<Todo>> {
  final TodoDB todoDB;
  TodoNotifier({required this.todoDB}) : super([]) {
    fetchTodos();
  }

  void fetchTodos() {
    state = todoDB.fetchTodos()!;
  }

  FutureVoid addTodo({Todo? todo}) async {
    await todoDB.addTodo(todo: todo);
    fetchTodos();
  }

  FutureVoid editTodo(int? key, Todo? todo) async {
    await todoDB.editTodo(key, todo);
    fetchTodos();
  }

  FutureVoid deleteTodo(Todo? todo) async {
    await todoDB.deleteTodo(todo);
    fetchTodos();
  }

  FutureVoid toggleComplete(Todo todo) async {
    await todoDB.toggleComplete(todo);
    fetchTodos();
  }
}
