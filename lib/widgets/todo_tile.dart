import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:PocketTasks/common/extensions.dart';
import 'package:PocketTasks/common/k_textstyle.dart';
import 'package:PocketTasks/models/todo.dart';
import 'package:PocketTasks/notifiers/todo_state_notifier.dart';
import 'package:PocketTasks/providers/providers.dart';
import 'package:PocketTasks/screens/add_edit_todo.dart';

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
    return Container(
      decoration: BoxDecoration(
        color: todo.completed == true
            ? (isDark
                  ? Colors.grey[800]?.withValues(alpha: 0.6)
                  : Colors.grey[200]?.withValues(alpha: 0.8))
            : (isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.white.withValues(alpha: 0.9)),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: todo.completed == true
              ? (isDark ? Colors.grey[700]! : Colors.grey[300]!)
              : Colors.transparent,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: todo.completed == true
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                    border: Border.all(
                      color: todo.completed == true
                          ? Theme.of(context).primaryColor
                          : (isDark ? Colors.grey[600]! : Colors.grey[400]!),
                      width: 2,
                    ),
                  ),
                  child: Checkbox(
                    value: todo.completed ?? false,
                    onChanged: (bool? value) {
                      if (value != null) {
                        ref
                            .read(todoNotifierProvider.notifier)
                            .toggleComplete(todo);
                      }
                    },
                    shape: const CircleBorder(),
                    activeColor: Colors.transparent,
                    checkColor: Colors.white,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todo.title ?? '',
                        style:
                            kTextStyle(
                              16,
                              ref,
                              fontWeight: FontWeight.w600,
                              color: todo.completed == true
                                  ? (isDark
                                        ? Colors.grey[500]
                                        : Colors.grey[600])
                                  : (isDark ? Colors.white : Colors.black87),
                            ).copyWith(
                              decoration: todo.completed == true
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              decorationThickness: 2,
                            ),
                      ),

                      const SizedBox(height: 4),
                      Text(
                        todo.note!,
                        style:
                            kTextStyle(
                              14,
                              ref,
                              color: todo.completed == true
                                  ? (isDark
                                        ? Colors.grey[600]
                                        : Colors.grey[500])
                                  : (isDark
                                        ? Colors.grey[400]
                                        : Colors.grey[600]),
                              fontWeight: FontWeight.w500,
                            ).copyWith(
                              decoration: todo.completed == true
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: todo.completed == true
                                ? (isDark ? Colors.grey[600] : Colors.grey[500])
                                : (isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[600]),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('MMM dd, yyyy').format(todo.dueDate!),
                            style: kTextStyle(
                              12,
                              ref,
                              color: todo.completed == true
                                  ? (isDark
                                        ? Colors.grey[600]
                                        : Colors.grey[500])
                                  : (isDark
                                        ? Colors.grey[400]
                                        : Colors.grey[600]),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.edit_outlined,
                          size: 20,
                          color: isDark ? Colors.grey[300] : Colors.grey[700],
                        ),
                        onPressed: () {
                          context.goTo(AddEditTodo(todo: todo));
                        },
                        constraints: const BoxConstraints(
                          minWidth: 36,
                          minHeight: 36,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          size: 20,
                          color: Colors.red[400],
                        ),
                        onPressed: () async {
                          final shouldDelete = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              title: Text(
                                'Delete Task',
                                style: kTextStyle(
                                  18,
                                  ref,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: Text(
                                'Are you sure you want to delete "${todo.title}"?',
                                style: kTextStyle(
                                  16,
                                  ref,
                                  color: isDark
                                      ? Colors.grey[300]
                                      : Colors.grey[700],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: Text(
                                    'Cancel',
                                    style: kTextStyle(
                                      14,
                                      ref,
                                      color: isDark
                                          ? Colors.grey[400]
                                          : Colors.grey[600],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: Text(
                                      'Delete',
                                      style: kTextStyle(
                                        14,
                                        ref,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );

                          if (shouldDelete ?? false) {
                            ref
                                .read(todoNotifierProvider.notifier)
                                .deleteTodo(todo);
                          }
                        },
                        constraints: const BoxConstraints(
                          minWidth: 36,
                          minHeight: 36,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
