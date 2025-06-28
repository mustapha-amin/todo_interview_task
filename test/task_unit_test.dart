import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_test/hive_test.dart';
import 'package:pocket_tasks/models/todo.dart';
import 'package:pocket_tasks/providers/theme_provider.dart';
import 'package:pocket_tasks/services/todo_db.dart';

void main() {
  late Box<Todo> todoBox;
  late Box<bool> themeBox;
  late TodoDB todoDB;

  setUp(() async {
    await setUpTestHive();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TodoAdapter());
    }

    todoBox = await Hive.openBox<Todo>('testTodoBox');
    todoDB = TodoDB(todosBox: todoBox);

    themeBox = await Hive.openBox<bool>('theme');
  });

  tearDown(() async {
    await tearDownTestHive();
  });

  group("Todo related tests", () {
    test('confirm that todo is saved', () async {
      Todo todo = Todo(
        title: "test title",
        note: "test note",
        dueDate: DateTime.now().add(Duration(days: 3)),
        completed: false,
      );
      log(todo.toString());
      await todoDB.addTodo(todo: todo);

      final result = todoDB.fetchTodoAt(todo.key);
      expect(result, todo);
    });

    test('confirm that saved todos are fetched from DB', () async {
      Todo todo = Todo(
        title: "test title",
        note: "test note",
        dueDate: DateTime.now().add(Duration(days: 3)),
        completed: false,
      );
      Todo todo2 = Todo(
        title: "test title",
        note: "test note",
        dueDate: DateTime.now().add(Duration(days: 3)),
        completed: false,
      );
      await todoDB.addTodo(todo: todo);
      await todoDB.addTodo(todo: todo2);
      final result = todoDB.fetchTodos();
      expect(result.isNotEmpty, true);
    });

    test("confirm that toggling of todo status works", () async {
      Todo todo = Todo(
        title: "test title",
        note: "test note",
        dueDate: DateTime.now().add(Duration(days: 3)),
        completed: false,
      );

      final key = await todoDB.addTodo(todo: todo);
      final result1 = todoDB.fetchTodoAt(key);
      expect(result1.completed, false);

      await todoDB.toggleComplete(todo);
      final result2 = todoDB.fetchTodoAt(key);
      expect(result2.completed, true);
    });
  });

  group("theme related tests", () {
    test("test theme mode", () {
      final container = ProviderContainer(
        overrides: [
          themeProvider.overrideWith((_) => ThemeNotifier(themeBox: themeBox)),
        ],
      );
      
      var themenotifier = container.read(themeProvider);
      expect(themenotifier, false);

      container.read(themeProvider.notifier).toggleTheme();
      themenotifier = container.read(themeProvider);
      expect(themenotifier, true);
    });
  });
}
