import 'dart:io';
import 'package:bloc_sqlite_db_app/model/todo_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  DbHelper._();
  static final DbHelper _instance = DbHelper._();
  static DbHelper getInstance() => _instance;
  static String TABLE_TODOS = "todos";
  static String COLUMN_ID = "id";
  static String COLUMN_TITLE = "title";
  static String COLUMN_DESC = "description";
  static String COLUMN_CATEGORY = "category";
  static String COLUMN_IS_COMPLETED = "isCompleted";
  static String COLUMN_PRIORITY = "priority";
  static String COLUMN_DUE_DATE = "dueDate";
  static String COLUMN_CREATED_AT = "createdAt";

  // this function check the database and create the table if it does not exist
  Database? _db;
  Future<Database> getDB() async {
    _db ??= await openDB();
    return _db!;
  }

  // this function open the database
  Future<Database> openDB() async {
    Directory appdocDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(appdocDirectory.path, "todoDB.db");
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        db.execute(
            "CREATE TABLE $TABLE_TODOS($COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT, $COLUMN_TITLE TEXT NOT NULL, $COLUMN_DESC TEXT, $COLUMN_CATEGORY TEXT, $COLUMN_IS_COMPLETED INTEGER DEFAULT 0, $COLUMN_PRIORITY INTEGER DEFAULT 1, $COLUMN_DUE_DATE TEXT, $COLUMN_CREATED_AT TEXT DEFAULT CURRENT_TIMESTAMP)");
      },
    );
  }

  // insert Todo Fuction
  Future<bool> addTodo({required TodoModel todo}) async {
    var db = await getDB();
    int rowsEffected = await db.insert(TABLE_TODOS, todo.toMap());
    return rowsEffected > 0;
  }

  // fetch All todos function
  Future<List<TodoModel>> fetchAllTodos() async {
    var db = await getDB();
    List<Map<String, dynamic>> mTodo = await db.query(TABLE_TODOS);
    return mTodo.map((eachTodo) => TodoModel.fromMap(eachTodo)).toList();
  }

  // update Todo Function
  Future<bool> updateTodo(TodoModel updatedTodo) async {
    var db = await getDB();
    int rowsEffected = await db.update(TABLE_TODOS, updatedTodo.toMap(),
        where: "$COLUMN_ID = ?", whereArgs: ["${updatedTodo.id}"]);
    return rowsEffected > 0;
  }

  //  delete Todo Function
  Future<bool> deleteTodo(int id) async {
    var db = await getDB();
    int rowsEffected = await db.delete(TABLE_TODOS, where: "$COLUMN_ID = $id");
    return rowsEffected > 0;
  }
}
