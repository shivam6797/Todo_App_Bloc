import 'package:bloc_sqlite_db_app/bloc/db_event.dart';
import 'package:bloc_sqlite_db_app/bloc/db_state.dart';
import 'package:bloc_sqlite_db_app/db/db_helper.dart';
import 'package:bloc_sqlite_db_app/model/todo_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DBBloc extends Bloc<DBEvent, DBState> {
  DbHelper dbHelper;
  List<TodoModel> _allTodos = [];
  String _selectedStatus = "All";
  int? _selectedPriority;
  String? _selectedCategory;

  DBBloc({required this.dbHelper}) : super(DBInitialState()) {
    on<AddTodoEvent>(_onAddTodo);
    on<UpdateTodoEvent>(_onUpdateTodo);
    on<DeletTodoEvent>(_onDeleteTodo);
    on<FetchInitialTodoEvent>(_onFetchInitialTodos);
    on<FetchFilteredTodoEvent>(_onFetchFilteredTodos);
    on<ResetFiltersEvent>(_onResetFilters);
  }

  void _onAddTodo(AddTodoEvent event, Emitter<DBState> emit) async {
    emit(DBLoadingState());
    bool check = await dbHelper.addTodo(todo: event.newTodo);
    await updateState(check, "Todo not Added!", emit);
  }

  void _onUpdateTodo(UpdateTodoEvent event, Emitter<DBState> emit) async {
    emit(DBLoadingState());
    bool check = await dbHelper.updateTodo(event.updateTodo);
    await updateState(check, "Todo not Updated!", emit);
  }

  void _onDeleteTodo(DeletTodoEvent event, Emitter<DBState> emit) async {
    emit(DBLoadingState());
    bool check = await dbHelper.deleteTodo(event.id);
    await updateState(check, "Todo not Deleted!", emit);
  }

  void _onFetchInitialTodos(
      FetchInitialTodoEvent event, Emitter<DBState> emit) async {
    emit(DBLoadingState());
    _allTodos = await dbHelper.fetchAllTodos();
    emit(DBLoadedState(mData: _allTodos));
  }

  void _onFetchFilteredTodos(FetchFilteredTodoEvent event, Emitter<DBState> emit) async {
    emit(DBLoadingState());
    _selectedStatus = event.status;
    _selectedPriority = event.priority;
    _selectedCategory = event.category;
    _applyFilters(emit);
  }

  void _onResetFilters(ResetFiltersEvent event, Emitter<DBState> emit) {
    _selectedStatus = "All";
    _selectedPriority = null;
    _selectedCategory = null;
    emit(DBLoadedState(mData: List.from(_allTodos)));
  }

  void _applyFilters(Emitter<DBState> emit) {
    List<TodoModel> filteredList = List.from(_allTodos);

    if (_selectedStatus == "Completed") {
      filteredList =
          filteredList.where((todo) => todo.isCompleted == true).toList();
    } else if (_selectedStatus == "Pending") {
      filteredList =
          filteredList.where((todo) => todo.isCompleted == false).toList();
    }

    if (_selectedPriority != null && _selectedPriority != -1) {
      filteredList = filteredList
          .where((todo) => todo.priority == _selectedPriority)
          .toList();
    }

    if (_selectedCategory != null) {
      filteredList = filteredList
          .where((todo) => todo.category == _selectedCategory)
          .toList();
    }

    emit(DBLoadedState(mData: filteredList));
  }

  Future<void> updateState(
      bool check, String errorMsg, Emitter<DBState> emit) async {
    if (check) {
      _allTodos = await dbHelper.fetchAllTodos();
      await Future.delayed(Duration.zero);
      emit(DBLoadedState(mData: _allTodos));
    } else {
      emit(DBErrorState(errorMsg: errorMsg));
    }
  }
}


