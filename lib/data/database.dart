import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/utils/priority.dart';

class ToDoDatabase {
  List todoList = [];
  // referencing to the box
  final _myBox = Hive.box('mybox');

  // opening the app first time ever
  void createInitialData() {
    todoList = [
      ["Make a Tutorial", "desciption", false, null, Priority.high],
      ["Do exercise", "desciption2", false, null, Priority.medium]
    ];
  }

  // to load the data from the database
  void loadData() {
    todoList = _myBox.get("TODOLIST");
  }

  // to update the data in the database
  void updateDataBase() {
    _myBox.put("TODOLIST", todoList);
  }
}
