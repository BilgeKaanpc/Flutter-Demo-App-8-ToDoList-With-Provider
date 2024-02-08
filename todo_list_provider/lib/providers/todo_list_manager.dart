import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_provider/models/todo_model.dart';
import 'package:uuid/uuid.dart';

class TodoListManager extends StateNotifier<List<TodoModel>> {
  TodoListManager([List<TodoModel>? state]) : super(state ?? []);

  void addTodo(String description) {
    var todo = TodoModel(id: const Uuid().v4(), description: description);
    state = [...state, todo];
  }

  void toggle(String id) {
    state = [
      for (var item in state)
        if (item.id == id)
          TodoModel(
            id: item.id,
            description: item.description,
            completed: !item.completed,
          )
        else
          item
    ];
  }

  void edit({required String id, required String newDescription}) {
    state = [
      for (var item in state)
        if (item.id == id)
          TodoModel(
            id: item.id,
            description: newDescription,
            completed: item.completed,
          )
        else
          item
    ];
  }

  void remove(TodoModel todo) {
    state = state.where((element) => element.id != todo.id).toList();
  }




}
