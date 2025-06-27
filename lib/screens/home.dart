import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pocket_tasks/common/extensions.dart';
import 'package:pocket_tasks/common/k_textStyle.dart';
import 'package:pocket_tasks/providers/providers.dart';
import 'package:pocket_tasks/providers/theme_provider.dart';
import 'package:pocket_tasks/screens/add_edit_todo.dart';
import 'package:pocket_tasks/screens/view_todo_details.dart';
import 'package:pocket_tasks/widgets/todo_tile.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  bool _isDark = false;
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    _isDark = ref.read(themeProvider);
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
              _isDark ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: () {
              ref.read(themeProvider.notifier).toggleTheme();
              setState(() {
                _isDark = !_isDark;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: InkWell(
              child: SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'all', label: Text('All')),
                  ButtonSegment(value: 'active', label: Text('Active')),
                  ButtonSegment(value: 'completed', label: Text('Completed')),
                ],
                selected: {_filter},
                onSelectionChanged: (values) {
                  setState(() {
                    _filter = values.first;
                  });
                },
                showSelectedIcon: false,
                style: SegmentedButton.styleFrom(
                  backgroundColor: Theme.of(context).cardColor,
                  foregroundColor: Theme.of(context).primaryColor,
                  selectedForegroundColor: Colors.white,
                  selectedBackgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer(
              builder: (context, ref, _) {
                final todos = ref.watch(todoNotifierProvider);

                final filteredTodos = _filter == 'active'
                    ? todos.where((todo) => !todo.completed!).toList()
                    : _filter == 'completed'
                    ? todos.where((todo) => todo.completed!).toList()
                    : todos;

                return filteredTodos.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/todo.png'),
                            Text(
                              switch (_filter) {
                                'all' => "What do you want to do today",
                                "active" => "No active todos",
                                _ => "No completed todos",
                              },

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
                        children: [
                          ...filteredTodos.map(
                            (todo) => TodoTile(
                              todo: todo,
                              isDark: _isDark,
                              onTap: () {
                                context.goTo(ViewTodoDetails(todo: todo));
                              },
                            ),
                          ),
                        ],
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
