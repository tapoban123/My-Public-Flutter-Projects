import 'package:flutter_bloc/flutter_bloc.dart';

class TaskFunctionsCubit extends Cubit<List<String>> {
  TaskFunctionsCubit() : super([]);

  void addTask(String task) {
    state.add(task);
    print(state);

    emit(state.toList());
  }

  void removeTask(String task) {
    state.remove(task);

    emit(state.toList());
  }

  void updateTask(String newTask, String oldTask) {
    int oldTaskIndex = state.indexOf(oldTask);

    state[oldTaskIndex] = newTask;

    emit(state.toList());
  }
}
