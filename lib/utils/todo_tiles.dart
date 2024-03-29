import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo/utils/priority.dart';
// import 'package:todo/utils/priority.dart';

class ToDoTile extends StatelessWidget {
  final String taskName;
  final String taskDescription;
  final bool taskCompleted;
  final DateTime? dueDate; // Add a field for dueDate
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteFunction;
  final Function(BuildContext)? onEdit; // Callback for editing
  final Priority priority;

  ToDoTile({
    super.key,
    required this.taskName,
    required this.taskCompleted,
    required this.onChanged,
    required this.deleteFunction,
    required this.taskDescription,
    this.dueDate,
    this.onEdit, // Optional edit callback
    required this.priority,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 25.0, left: 25, right: 25),
        child: Slidable(
          // using the sliding motion for deletion
          endActionPane: ActionPane(
            motion: StretchMotion(),
            children: [
              SlidableAction(
                onPressed: deleteFunction,
                icon: Icons.delete,
                backgroundColor: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
            ],
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: const Color.fromARGB(200, 221, 161, 94),
                borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                Checkbox(
                  value: taskCompleted,
                  onChanged: onChanged,
                  activeColor: Color.fromARGB(255, 219, 220, 217),
                  checkColor: Colors.brown[600],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 0.5, color: Colors.black),
                      ),
                      child: Text(
                        taskName,
                        softWrap: true,
                        style: TextStyle(
                            fontSize: 20,
                            decoration: taskCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 200,
                      child: Text(
                        taskDescription,
                        softWrap: true,
                        style: TextStyle(
                            fontSize: 15,
                            decoration: taskCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none),
                      ),
                    ),
                    dueDate != null
                        ? Text('Due: ${dueDate!.toString()}')
                        : SizedBox(),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color:
                            getPriorityColor(priority), // Use priority directly
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        _getPriorityText(priority), // Get priority text
                        style: TextStyle(
                          fontWeight:
                              FontWeight.bold, // Make priority text bold
                        ),
                      ),
                    )
                  ],
                ),
                Spacer(),
                Column(
                  children: [
                    PopupMenuButton<String>(
                      icon: Icon(Icons.arrow_drop_down),
                      onSelected: (value) {
                        if (value == 'Edit') {
                          if (onEdit != null)
                            onEdit!(context); // Call edit function if provided
                        } else if (value == 'Delete') {
                          deleteFunction!(context);
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          value: 'Edit',
                          child: Text('Edit'),
                        ),
                        PopupMenuItem(
                          value: 'Delete',
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getPriorityText(Priority priority) {
    switch (priority) {
      case Priority.low:
        return 'LOW';
      case Priority.medium:
        return 'MEDIUM';
      case Priority.high:
        return 'HIGH';
      default:
        return 'UNKNOWN';
    }
  }

  Color? getPriorityColor(Priority? priority) {
    if (priority == null) return Colors.grey[300]; // Default for no priority
    switch (priority) {
      case Priority.low:
        return Colors.lightGreen[100];
      case Priority.medium:
        return Colors.amber[200];
      case Priority.high:
        return Colors.red[100];
      default:
        return Colors.grey[300];
    }
  }
}
