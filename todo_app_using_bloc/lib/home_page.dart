import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_using_bloc/cubits/task_cubit.dart';
import 'package:todo_app_using_bloc/tasks_function_screen.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final TextEditingController editTaskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final taskList = BlocProvider.of<TaskFunctionsCubit>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasks"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TasksFunctionScreen(),
          ));
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          BlocBuilder(
            bloc: taskList,
            builder: (context, List<String> state) {
              return Expanded(
                child: ListView.builder(
                  itemCount: state.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(state[index]),
                      subtitle: const Divider(),
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: TextField(
                            controller: editTaskController,
                            decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(),
                              focusedBorder: UnderlineInputBorder(),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                taskList.updateTask(
                                  editTaskController.text,
                                  state[index],
                                );

                                Navigator.of(context).pop();
                              },
                              child: const Text("Update"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Cancel"),
                            ),
                          ],
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          taskList.removeTask(state[index]);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Task Deleted"),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
