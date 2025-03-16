import 'package:bloc_sqlite_db_app/model/todo_model.dart';

abstract class DBState {}

class DBInitialState extends DBState {}

class DBLoadingState extends DBState {}

class DBLoadedState extends DBState {
  List<TodoModel> mData;
  DBLoadedState({required this.mData});
}

class DBErrorState extends DBState {
  String errorMsg;
  DBErrorState({required this.errorMsg});
}
