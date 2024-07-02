import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_using_bloc/cubits/task_cubit.dart';

class TasksFunctionScreen extends StatelessWidget {
  TasksFunctionScreen({super.key});

  final TextEditingController newTaskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final taskFunctions = BlocProvider.of<TaskFunctionsCubit>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Tasks"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              controller: newTaskController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(width: 2),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                taskFunctions.addTask(newTaskController.text);
                newTaskController.clear();
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.amber.shade200),
              child: const Text(
                "Add new task",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
