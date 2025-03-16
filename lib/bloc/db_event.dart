import 'package:bloc_sqlite_db_app/model/todo_model.dart';

abstract class DBEvent{}

class AddTodoEvent extends DBEvent{
  TodoModel newTodo;
  AddTodoEvent({required this.newTodo});
}

class UpdateTodoEvent extends DBEvent{
  TodoModel updateTodo;
  UpdateTodoEvent({required this.updateTodo});
}

class DeletTodoEvent extends DBEvent{
  int id;
  DeletTodoEvent({required this.id});
}

class  FetchInitialTodoEvent extends DBEvent{}

class FetchFilteredTodoEvent extends DBEvent {
  final String status;
  final int? priority;
  final String? category;
  FetchFilteredTodoEvent({required this.status, this.priority, this.category});
}

class ResetFiltersEvent extends DBEvent {}