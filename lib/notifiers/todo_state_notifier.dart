import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_tasks/common/typedefs.dart';
import 'package:pocket_tasks/models/todo.dart';
import 'package:pocket_tasks/services/todo_db.dart';

class TodoNotifier extends StateNotifier<List<Todo>> {
  final TodoDB todoDB;
  TodoNotifier({required this.todoDB}) : super([]) {
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    final todos = todoDB.fetchTodos();
    state = todos;
  }

  FutureVoid addTodo({Todo? todo}) async {
    await todoDB.addTodo(todo: todo);
    await fetchTodos();
  }

  FutureVoid editTodo(int? key, Todo? todo) async {
    await todoDB.editTodo(key, todo);
    await fetchTodos();
  }

  FutureVoid deleteTodo(Todo? todo) async {
    await todoDB.deleteTodo(todo);
    await fetchTodos();
  }

  FutureVoid toggleComplete(Todo todo) async {
    await todoDB.toggleComplete(todo);
    await fetchTodos();
  }
}
