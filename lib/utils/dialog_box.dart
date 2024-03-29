import 'package:flutter/material.dart';
import 'package:todo/utils/my_button.dart';
import 'package:intl/intl.dart';
import 'package:todo/utils/priority.dart';

class DialogBox extends StatelessWidget {
  // making a controller to get the task
  final taskController;
  final descriptionController;
  final dueDateController;
  final Priority? priority;
  final ValueChanged<Priority?> onPriorityChanged; // Callback function
  // making the functions to get the functionality of the save and cancel button in the homescreen
  VoidCallback onSave;
  VoidCallback onCancel;

  DialogBox({
    super.key,
    required this.taskController,
    required this.descriptionController,
    required this.dueDateController,
    required this.priority,
    required this.onPriorityChanged, // Accept callback function
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    // Priority selectedPriority = Priority.low;

    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 163, 177, 138),
      content: Container(
        height: 350,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // to get the task name from the user
            TextField(
              controller: taskController,
              decoration: InputDecoration(
                hintText: "Enter task name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                hintText: "Enter description(optional)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            TextField(
              controller: dueDateController,
              readOnly: true, // Make due date field read-only
              onTap: () async {
                // Open date picker on tap
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(
                      Duration(days: 365)), // Allow past dates (optional)
                  lastDate: DateTime.now().add(
                      Duration(days: 365)), // Allow future dates (optional)
                );
                if (pickedDate != null) {
                  dueDateController.text = DateFormat('yyyy-MM-dd')
                      .format(pickedDate); // Format date string
                }
              },
              decoration: InputDecoration(
                hintText: "Select Due Date (optional)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                suffixIcon: Icon(Icons.calendar_today),
              ),
            ),

            // add the priority here

            DropdownButtonFormField<Priority>(
              value: priority, // Set initial value
              isExpanded: true, // Expand the dropdown
              icon: Icon(Icons.keyboard_arrow_down),
              items: [
                DropdownMenuItem(
                  value: Priority.low,
                  child: Text('Low'),
                ),
                DropdownMenuItem(
                  value: Priority.medium,
                  child: Text('Medium'),
                ),
                DropdownMenuItem(
                  value: Priority.high,
                  child: Text('High'),
                ),
              ],
              onChanged: onPriorityChanged,
              decoration: InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // save button

                  MyButton(text: "Save", onPressed: onSave),

                  SizedBox(width: 10),

                  // cancel button
                  MyButton(text: "Cancel", onPressed: onCancel)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
