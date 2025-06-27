import 'package:hive_flutter/hive_flutter.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject{
  @HiveField(0)
  String? title;

  @HiveField(1)
  String? note;
  
  @HiveField(2)
  DateTime? dueDate;
  
  @HiveField(3)
  bool? completed;

  Todo({this.title, this.note, this.dueDate, this.completed});

  @override
  String toString() {
    return 'Todo(title: $title, note: $note, dueDate: $dueDate, completed: $completed)';
  }

  Todo copyWith({
    String? title,
    String? note,
    DateTime? dueDate,
    bool? completed,
  }) {
    return Todo(
      title: title ?? this.title,
      note: note ?? this.note,
      dueDate: dueDate ?? this.dueDate,
      completed: completed ?? this.completed,
    );
  }
}
