import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pocket_tasks/common/extensions.dart';
import 'package:pocket_tasks/common/k_textStyle.dart';
import 'package:pocket_tasks/providers/providers.dart';
import 'package:pocket_tasks/providers/theme_provider.dart';
import 'package:pocket_tasks/screens/add_edit_todo.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        titleTextStyle: kTextStyle(22, ref, color: Colors.white),
        title: Text(
          'PocketTasks',
          style: kTextStyle(22, ref, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer(
              builder: (context, ref, _) {
                final todos = ref.watch(todoNotifierProvider);
                return todos.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/todo.png'),
                            Text(
                              "What do you want to do today",
                              style: kTextStyle(
                                18,
                                ref,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.all(16),
                        children: todos
                            .map(
                              (todo) => Card(
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: CheckboxListTile(
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  tileColor: todo.completed == true
                                      ? Colors.grey[200]
                                      : Theme.of(context).cardColor,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 3,
                                  ),
                                  title: Text(
                                    todo.title ?? '',
                                    style: TextStyle(
                                      decoration: todo.completed == true
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (todo.note != null)
                                        Text(
                                          todo.note!,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            decoration: todo.completed == true
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      if (todo.dueDate != null)
                                        Text(
                                          DateFormat(
                                            'dd/MM/yyyy',
                                          ).format(todo.dueDate!),
                                          style:
                                              kTextStyle(
                                                12,
                                                ref,
                                                color: Colors.grey[600],
                                              ).copyWith(
                                                decoration:
                                                    todo.completed == true
                                                    ? TextDecoration.lineThrough
                                                    : TextDecoration.none,
                                              ),
                                        ),
                                    ],
                                  ),
                                  value: todo.completed ?? false,
                                  onChanged: (bool? value) {
                                    if (value != null) {
                                      ref
                                          .read(todoNotifierProvider.notifier)
                                          .toggleComplete(todo);
                                    }
                                  },
                                  checkboxShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  activeColor: Theme.of(context).primaryColor,
                                  checkColor: Colors.white,
                                ),
                              ),
                            )
                            .toList(),
                      );
              },
            ),
          ),
          Hero(
            tag: 'button',
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    context.goTo(AddEditTodo());
                  },
                  child: Text("Add task"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
