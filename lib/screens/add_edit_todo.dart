import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pocket_tasks/common/extensions.dart';
import 'package:pocket_tasks/common/k_textstyle.dart';
import 'package:pocket_tasks/models/todo.dart';
import 'package:pocket_tasks/notifiers/todo_state_notifier.dart';
import 'package:pocket_tasks/providers/providers.dart';
import 'package:pocket_tasks/providers/theme_provider.dart';

class AddEditTodo extends ConsumerStatefulWidget {
  final Todo? todo;
  const AddEditTodo({super.key, this.todo});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddEditTodoState();
}

class _AddEditTodoState extends ConsumerState<AddEditTodo> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  final _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      _titleController.text = widget.todo!.title ?? '';
      _noteController.text = widget.todo!.note ?? '';
      _dateController.text = widget.todo!.dueDate != null
          ? DateFormat('dd/MM/yyyy').format(widget.todo!.dueDate!)
          : '';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateController.text.isNotEmpty
          ? DateFormat('dd/MM/yyyy').parse(_dateController.text)
          : DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  void _saveTodo() {
    final todo = Todo(
      title: _titleController.text,
      note: _noteController.text,
      dueDate: _dateController.text.isNotEmpty
          ? DateFormat('dd/MM/yyyy').parse(_dateController.text)
          : null,
      completed: false,
    );

    if (widget.todo != null) {
      ref.read(todoNotifierProvider.notifier).editTodo(widget.todo!.key, todo);
    } else {
      ref.read(todoNotifierProvider.notifier).addTodo(todo: todo);
    }

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.todo != null ? 'Edit Todo' : 'Add Todo',
            style: kTextStyle(22, ref, color: Colors.white),
          ),
          centerTitle: true,
          foregroundColor: Colors.white,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _noteController,
                      decoration: InputDecoration(
                        labelText: 'Note',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Due Date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(context),
                        ),
                      ),
                      readOnly: true,
                      controller: _dateController,
                      onTap: () => _selectDate(context),
                    ),
                  ],
                ),
                Hero(
                  tag: 'button',
                  child: ListenableBuilder(
                    listenable: Listenable.merge([
                      _titleController,
                      _noteController,
                      _dateController,
                    ]),
                    builder: (context, _) {
                      return SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed:
                              _titleController.text.isNotEmpty &&
                                  _dateController.text.isNotEmpty &&
                                  _noteController.text.isNotEmpty
                              ? _saveTodo
                              : null,
                          child: Text(widget.todo != null ? 'Update' : 'Add'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
