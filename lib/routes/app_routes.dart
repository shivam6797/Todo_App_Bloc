
import 'package:bloc_sqlite_db_app/splash_screen.dart';
import 'package:bloc_sqlite_db_app/ui/add_task_screen.dart';
import 'package:bloc_sqlite_db_app/ui/todo_screen.dart';
import 'package:flutter/cupertino.dart';

class AppRoutes {
  static const String ROUTE_SPLASH = "/";
  static const String ROUTE_TODOS= "/todos";
  static const String ROUTE_ADD_UPDATE_TODOS= "/add_update_todos";


  static Map<String, WidgetBuilder> getRoutes() => {
        ROUTE_SPLASH: (context) => SplashScreen(),
        ROUTE_TODOS: (context) => TodoScreen(),
        ROUTE_ADD_UPDATE_TODOS: (context) => AddTaskScreen(),

      };
}
