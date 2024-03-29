import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/data/database.dart';
import 'package:todo/utils/dialog_box.dart';
import 'package:todo/utils/todo_tiles.dart';

import '../utils/priority.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // to use hive box
  final _myBox = Hive.box('mybox');
  ToDoDatabase db = ToDoDatabase();

  // to work with the database we need to check if the app is oipening first time or what
  @override
  void initState() {
    // if this is first time
    // then the database is empty therefore
    if (_myBox.get("TODOLIST") == null) {
      // creating initial data
      db.createInitialData();
    }
    // else there is already data present
    else {
      db.loadData();
    }
    super.initState();
  }

  // making a textcontroller to manage the text from the user
  final _taskController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dueDateController = TextEditingController();
  // list of todo list task

  // List todoList = [
  //   ["Task1 Name", "desciption", false, null, Priority.high],
  //   ["Task2 Name", "desciption2", false, null, Priority.medium]
  // ];
  Priority? selectedPriority = Priority.low;

  // to check checkbox was clicked
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.todoList[index][2] = !db.todoList[index][2];
    });
    db.updateDataBase();
  }

  // to update the priority

  void updatePriority(Priority? newPriority) {
    setState(() {
      selectedPriority = newPriority; // Update priority
    });
    db.updateDataBase();
  }

  // to save the new task
  void saveNewTask() {
    setState(() {
      DateTime? dueDate;
      try {
        dueDate = DateTime.parse(_dueDateController.text);
      } catch (e) {
        print("Due Date is wrong");
      }
      db.todoList.add([
        _taskController.text,
        _descriptionController.text,
        false,
        dueDate,
        selectedPriority, // Save selected priority
      ]);
      _taskController.clear();
      _descriptionController.clear();
      _dueDateController.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  // to create a new task
  void createNewTask() {
    // showing a dialog box to take details from the user
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            taskController: _taskController,
            descriptionController: _descriptionController,
            dueDateController: _dueDateController,
            priority: selectedPriority,
            onPriorityChanged: updatePriority,
            // saving the current task
            onSave: saveNewTask,

            // just to cancel the creation of the task
            onCancel: () => Navigator.of(context).pop(),
          );
        });
  }

  // to delete the task
  void deleteTask(int index) {
    setState(() {
      db.todoList.removeAt(index);
    });
    db.updateDataBase();
  }

  // to edit the task
  void handleEdit(int index) {
    // showing a dialog box to take details from the user
    _taskController.text = db.todoList[index][0];
    _descriptionController.text = db.todoList[index][1];
    _dueDateController.text = db.todoList[index][3]?.toString() ?? '';
    Priority priority = db.todoList[index][4];
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            taskController: _taskController,
            descriptionController: _descriptionController,
            dueDateController: _dueDateController,
            priority: priority,
            // onPriorityChanged: updatePriority,
            onPriorityChanged: (newPriority) {
              // Update priority when user selects a new one
              setState(() {
                priority = newPriority!;
              });
            },
            // saving the current task
            onSave: () {
              setState(() {
                db.todoList[index][0] = _taskController.text;
                db.todoList[index][1] = _descriptionController.text;
                db.todoList[index][2] = false;
                DateTime? dueDate;
                try {
                  dueDate = DateTime.parse(
                      _dueDateController.text); // Update due date
                } catch (e) {
                  // Handle parsing error
                }
                db.todoList[index][3] = dueDate;
                db.todoList[index][4] = priority;
                _taskController.clear();
                _descriptionController.clear();
                _dueDateController.clear();
              });
              Navigator.of(context).pop();
              db.updateDataBase();
            },

            // just to cancel the creation of the task
            onCancel: () => Navigator.of(context).pop(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 254, 250, 224),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "TO DO",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // making a floating button
        floatingActionButton: FloatingActionButton(
          onPressed: createNewTask,
          child: Icon(Icons.add),
        ),

        // adding tiles for the tasks
        body: ListView.builder(
          itemCount: db.todoList.length,
          itemBuilder: (context, index) {
            return ToDoTile(
              taskName: db.todoList[index][0],
              taskDescription: db.todoList[index][1],
              taskCompleted: db.todoList[index][2],
              onChanged: (value) => checkBoxChanged(value, index),
              deleteFunction: (context) => deleteTask(index),
              onEdit: (context) => handleEdit(index),
              dueDate: db.todoList[index][3],
              priority: db.todoList[index][4],
            );
          },
        ));
  }
}
