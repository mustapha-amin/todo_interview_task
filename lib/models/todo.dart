// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive_flutter/hive_flutter.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject {
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
    return 'Todo(title: $title, note: $note, dueDate: $dueDate, completed: $completed, key: $key)';
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

  @override
  bool operator ==(covariant Todo other) {
    if (identical(this, other)) return true;
  
    return 
      other.title == title &&
      other.note == note &&
      other.dueDate == dueDate &&
      other.completed == completed;
  }

  @override
  int get hashCode {
    return title.hashCode ^
      note.hashCode ^
      dueDate.hashCode ^
      completed.hashCode;
  }
}
