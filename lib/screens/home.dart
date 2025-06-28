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

class _HomeState extends ConsumerState<Home> with TickerProviderStateMixin {
  bool _isDark = false;
  String _filter = 'all';
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _isDark = ref.read(themeProvider);
    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.only(right: 16),
        leadingWidth: 70,
        backgroundColor: _isDark ? Color(0xFF1a1a2e) : Color(0xFFf8f9ff),
        leading: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(left: 16, top: 5),
          height: 65,
          width: 65,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withValues(alpha: .8),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(Icons.task_alt, color: Colors.white, size: 28),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PocketTasks',
              style: kTextStyle(
                24,
                ref,
                color: _isDark ? Colors.white : Colors.black87,
              ),
            ),
            Text(
              'Organize your day',
              style: kTextStyle(
                14,
                ref,
                color: _isDark ? Colors.grey[400] : Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              color: _isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                _isDark ? Icons.light_mode : Icons.dark_mode,
                color: _isDark ? Colors.white : Colors.black87,
              ),
              onPressed: () {
                ref.read(themeProvider.notifier).toggleTheme();
                setState(() {
                  _isDark = !_isDark;
                });
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _isDark
                ? [
                    const Color(0xFF1a1a2e),
                    const Color(0xFF16213e),
                    const Color(0xFF0f3460),
                  ]
                : [
                    const Color(0xFFf8f9ff),
                    const Color(0xFFe8f4fd),
                    const Color(0xFFd1ecf1),
                  ],
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 30),
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: SegmentedButton<String>(
                    segments: [
                      ButtonSegment(
                        value: 'all',
                        label: Text(
                          'All (${ref.watch(todoNotifierProvider).length})',
                          style: kTextStyle(
                            14,
                            ref,
                            color: switch (_filter == 'all') {
                              true => Colors.white,
                              false => _isDark ? Colors.white : Colors.black,
                            },
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ButtonSegment(
                        value: 'active',
                        label: Text(
                          'Active (${ref.watch(todoNotifierProvider).where((todo) => !todo.completed!).length})',
                          style: kTextStyle(
                            14,
                            ref,
                            color: switch (_filter == 'active') {
                              true => Colors.white,
                              false => _isDark ? Colors.white : Colors.black,
                            },
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ButtonSegment(
                        value: 'completed',
                        label: Text(
                          'Completed (${ref.watch(todoNotifierProvider).where((todo) => todo.completed!).length})',
                          style: kTextStyle(
                            14,
                            ref,
                            color: switch (_filter == 'completed') {
                              true => Colors.white,
                              false => _isDark ? Colors.white : Colors.black,
                            },
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                    selected: {_filter},
                    onSelectionChanged: (values) {
                      setState(() {
                        _filter = values.first;
                      });
                      _fadeController.reset();
                      _slideController.reset();
                      _fadeController.forward();
                      _slideController.forward();
                    },
                    showSelectedIcon: false,
                    style: SegmentedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: _isDark
                          ? Colors.grey[400]
                          : Colors.grey[600],
                      selectedForegroundColor: Colors.white,
                      selectedBackgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Consumer(
                builder: (context, ref, _) {
                  final todos = ref.watch(todoNotifierProvider);
                  final filteredTodos = _filter == 'all'
                      ? todos
                      : _filter == 'active'
                      ? todos.where((todo) => !todo.completed!).toList()
                      : todos.where((todo) => todo.completed!).toList();

                  return filteredTodos.isEmpty
                      ? FadeTransition(
                          opacity: _fadeAnimation,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: _isDark
                                        ? Colors.white.withValues(alpha: 0.1)
                                        : Colors.white.withValues(alpha: 0.8),
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.1,
                                        ),
                                        blurRadius: 16,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Image.asset('assets/images/todo.png'),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  switch (_filter) {
                                    'all' => "What do you want to do today?",
                                    "active" => "No active tasks yet",
                                    _ => "No completed tasks yet",
                                  },
                                  style: kTextStyle(
                                    20,
                                    ref,
                                    fontWeight: FontWeight.bold,
                                    color: _isDark
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  switch (_filter) {
                                    'all' =>
                                      "Tap the button below to add your first task",
                                    "active" =>
                                      "Create some tasks to see them here",
                                    _ =>
                                      "Mark some tasks as complete to see them here",
                                  },
                                  style: kTextStyle(
                                    16,
                                    ref,
                                    color: _isDark
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          itemCount: filteredTodos.length,
                          itemBuilder: (context, index) {
                            final todo = filteredTodos[index];
                            return FadeTransition(
                              opacity: _fadeAnimation,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: TodoTile(
                                  todo: todo,
                                  isDark: _isDark,
                                  onTap: () {
                                    context.goTo(ViewTodoDetails(todo: todo));
                                  },
                                ),
                              ),
                            );
                          },
                        );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    context.goTo(AddEditTodo());
                  },
                  child: Container(
                    width: double.infinity,
                    height: 64,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_task, color: Colors.white, size: 24),
                        const SizedBox(width: 12),
                        Text(
                          "Add New Task",
                          style: kTextStyle(18, ref, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
