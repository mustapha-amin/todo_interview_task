import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pocket_tasks/common/extensions.dart';
import 'package:pocket_tasks/common/k_textstyle.dart';
import 'package:pocket_tasks/models/todo.dart';
import 'package:pocket_tasks/notifiers/todo_state_notifier.dart';
import 'package:pocket_tasks/providers/providers.dart';
import 'package:pocket_tasks/screens/add_edit_todo.dart';

class TodoTile extends ConsumerWidget {
  final Todo todo;
  final bool isDark;
  final VoidCallback? onTap;

  const TodoTile({
    super.key,
    required this.todo,
    required this.isDark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: todo.completed == true
            ? isDark
                  ? Colors.grey[800]
                  : Colors.grey[300]
            : Theme.of(context).cardColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
        leading: Checkbox(
          value: todo.completed ?? false,
          onChanged: (bool? value) {
            if (value != null) {
              ref.read(todoNotifierProvider.notifier).toggleComplete(todo);
            }
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          activeColor: Theme.of(context).primaryColor,
          checkColor: Colors.white,
        ),
        title: Text(
          todo.title ?? '',
          style:
              kTextStyle(
                16,
                ref,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.grey[600] : Colors.black,
              ).copyWith(
                decoration: todo.completed == true
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (todo.note != null)
              Text(
                todo.note!,
                style: TextStyle(
                  color: Colors.grey[600],
                  decoration: todo.completed == true
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                context.goTo(AddEditTodo(todo: todo));
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () async {
                final shouldDelete = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Todo'),
                    content: Text(
                      'Are you sure you want to delete "${todo.title}"?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(
                          'Delete',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                );

                if (shouldDelete ?? false) {
                  ref.read(todoNotifierProvider.notifier).deleteTodo(todo);
                }
              },
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
