import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_tasks/models/todo.dart';
import 'package:pocket_tasks/notifiers/todo_state_notifier.dart';
import 'package:pocket_tasks/providers/providers.dart';

class ViewTodoDetails extends ConsumerStatefulWidget {
  final Todo todo;
  const ViewTodoDetails({super.key, required this.todo});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ViewTodoDetailsState();
}

class _ViewTodoDetailsState extends ConsumerState<ViewTodoDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Details'),
        actions: [
          IconButton(
            icon: Icon(widget.todo.completed! ? Icons.check_box : Icons.check_box_outline_blank),
            onPressed: () {
              ref.read(todoNotifierProvider.notifier).toggleComplete(widget.todo.key);
              Navigator.pop(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/add-todo',
                arguments: widget.todo,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              ref.read(todoNotifierProvider.notifier).deleteTodo(widget.todo);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.todo.title ?? 'No title',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                decoration: widget.todo.completed!
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            const SizedBox(height: 16),
            if (widget.todo.note != null && widget.todo.note!.isNotEmpty)
              Text(
                widget.todo.note!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            const SizedBox(height: 16),
            if (widget.todo.dueDate != null)
              Text(
                'Due Date: ${widget.todo.dueDate!.toLocal()}'.split(' ')[0],
                style: Theme.of(context).textTheme.bodyMedium,
              ),
          ],
        ),
      ),
    );
  }
}