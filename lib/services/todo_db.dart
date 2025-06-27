import 'package:hive_flutter/hive_flutter.dart';
import 'package:pocket_tasks/common/typedefs.dart';
import 'package:pocket_tasks/models/todo.dart';

class TodoDB {
  Box<Todo> todosBox;

  TodoDB({required this.todosBox});

  FutureVoid addTodo({Todo? todo}) async {
    await todosBox.add(todo!);
  }

  FutureVoid editTodo(int? key, Todo? todo) async {
    await todosBox.putAt(key!, todo!);
  }

  FutureVoid deleteTodo(Todo? todo) async {
    await todo!.delete();
  }

  ListTodo? fetchTodos() {
    return todosBox.values.toList()
      ..sort((a, b) => b.dueDate!.compareTo(a.dueDate!));
  }

  FutureVoid toggleComplete(Todo todo) async {
    todosBox.put(todo.key, todo.copyWith(completed: !todo.completed!));
  }
}
