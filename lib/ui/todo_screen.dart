import 'package:bloc_sqlite_db_app/bloc/db_bloc.dart';
import 'package:bloc_sqlite_db_app/bloc/db_event.dart';
import 'package:bloc_sqlite_db_app/bloc/db_state.dart';
import 'package:bloc_sqlite_db_app/model/todo_model.dart';
import 'package:bloc_sqlite_db_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../routes/app_routes.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? selectedCategory;
  int? selectedPriority;

  @override
  void initState() {
    super.initState();
    context.read<DBBloc>().add(FetchInitialTodoEvent());
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_applyFilters);
    _applyFilters();
  }

  void _applyFilters() {
    context.read<DBBloc>().add(FetchFilteredTodoEvent(
          status: _getSelectedStatus(),
          category: selectedCategory,
          priority: selectedPriority,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Color(0xFFFEC89A),
        centerTitle: true,
        title: Text(
          "My Tasks",
          style: TextStyle(
              color: AppColors.darkBlack,
              fontSize: 18,
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.darkBlack,
          indicatorColor: Colors.orange.shade700,
          tabs: [
            Tab(text: "All"),
            Tab(text: "Completed"),
            Tab(text: "Pending"),
          ],
        ),
      ),
      body: Column(
        children: [
          // Filter Options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  hint: Text("Category"),
                  value: selectedCategory,
                  onChanged: (value) {
                    setState(() => selectedCategory = value);
                    _applyFilters();
                  },
                  items: ["Work", "Personal", "Shopping"].map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                ),
                DropdownButton<int>(
                  hint: Text("Priority"),
                  value: selectedPriority,
                  onChanged: (value) {
                    setState(() => selectedPriority = value);
                    _applyFilters();
                  },
                  items: [3, 2, 1].map((priority) {
                    return DropdownMenuItem(
                      value: priority,
                      child: Text(_priorityLabel(priority)),
                    );
                  }).toList(),
                ),
                IconButton(
                  icon: Icon(Icons.refresh, color: Colors.orange.shade700),
                  onPressed: () {
                    setState(() {
                      selectedCategory = null;
                      selectedPriority = null;
                    });
                    _applyFilters();
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<DBBloc, DBState>(
              builder: (context, state) {
                if (state is DBLoadingState) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: AppColors.white,
                      color: AppColors.darkBlack.withOpacity(0.6),
                      strokeWidth: 2,
                    ),
                  );
                }
                if (state is DBErrorState) {
                  return Center(
                    child: Text("Error: ${state.errorMsg}"),
                  );
                }
                if (state is DBLoadedState) {
                  return state.mData.isNotEmpty
                      ? ListView.builder(
                          itemCount: state.mData.length,
                          padding: EdgeInsets.only(top: 10),
                          itemBuilder: (context, index) {
                            return _buildTodoTile(state.mData[index], context);
                          },
                        )
                      : _buildNoTodosFound();
                }
                return Container();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFFEC89A),
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.ROUTE_ADD_UPDATE_TODOS);
        },
        child: Icon(Icons.add, size: 22, color: AppColors.darkBlack),
      ),
    );
  }

  String _getSelectedStatus() {
    switch (_tabController.index) {
      case 1:
        return "Completed";
      case 2:
        return "Pending";
      default:
        return "All";
    }
  }

  Widget _buildNoTodosFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/boy_data.png",
            fit: BoxFit.contain,
            width: 150,
          ),
          SizedBox(height: 10),
          Text(
            "No Todos Found!",
            style: TextStyle(
              color: AppColors.darkGrey,
              fontFamily: "Poppins",
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodoTile(TodoModel todo, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: todo.isCompleted == true ? Color(0xFFF6E8C3) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              spreadRadius: 2,
              offset: Offset(2, 4)),
        ],
      ),
      child: ListTile(
        tileColor: Colors.white,
        dense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        leading: Checkbox(
          activeColor: Colors.orange.shade500,
          checkColor: Colors.white,
          value: todo.isCompleted ?? false,
          onChanged: (value) {
            context.read<DBBloc>().add(
                UpdateTodoEvent(updateTodo: todo.copyWith(isCompleted: value)));
          },
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 15,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600,
            decoration:
                todo.isCompleted == true ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _priorityColor(todo.priority),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _priorityLabel(todo.priority),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    todo.category,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3),
            Text(
              "Due Date: ${todo.dueDate}",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 13,
                fontFamily: "Poppins",
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            todo.isCompleted == false
                ? IconButton(
                    padding: EdgeInsets.all(4),
                    constraints: BoxConstraints(),
                    icon: Icon(
                      FontAwesomeIcons.edit,
                      color: Colors.blue.shade400,
                      size: 18,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                          context, AppRoutes.ROUTE_ADD_UPDATE_TODOS,
                          arguments: todo);
                    },
                  )
                : Container(),
            IconButton(
              padding: EdgeInsets.all(4),
              constraints: BoxConstraints(),
              icon: Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () {
                context.read<DBBloc>().add(DeletTodoEvent(id: todo.id!));
              },
            ),
          ],
        ),
      ),
    );
  }

  String _priorityLabel(int priority) {
    switch (priority) {
      case 1:
        return "Low";
      case 2:
        return "Medium";
      case 3:
        return "High";
      default:
        return "Unknown";
    }
  }

  Color _priorityColor(int priority) {
    switch (priority) {
      case 3:
        return Colors.red.shade400;
      case 2:
        return Colors.orange.shade400;
      case 1:
        return Colors.green.shade400;
      default:
        return Colors.grey.shade400;
    }
  }
}
