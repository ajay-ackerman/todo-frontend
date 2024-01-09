// add_task_screen.dart

import 'package:flutter/material.dart';

class AddTask extends StatelessWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AddTaskForm(),
      ),
    );
  }
}

class AddTaskForm extends StatefulWidget {
  const AddTaskForm({Key? key}) : super(key: key);

  @override
  _AddTaskFormState createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _discriController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _taskController,
          decoration: InputDecoration(
            labelText: 'Task',
          ),
        ),
        TextField(
          controller: _discriController,
          decoration: InputDecoration(
            labelText: 'Description',
          ),
        ),
        SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: () {
            // Handle the task submission here
            String newTask = _taskController.text;
            String newDesc = _discriController.text;
            // You might want to pass the new task back to the previous screen or perform other actions.
            Navigator.pop(context, [newTask, newDesc]);
          },
          child: Text('Add Task'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }
}
