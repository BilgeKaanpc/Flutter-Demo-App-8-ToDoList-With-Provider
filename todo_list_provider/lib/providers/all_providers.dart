import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_provider/models/todo_model.dart';
import 'package:todo_list_provider/providers/todo_list_manager.dart';
import 'package:uuid/uuid.dart';

enum TodoListFitler {
  all,
  active,
  completed,
}

final todoListFitler =
    StateProvider<TodoListFitler>((ref) => TodoListFitler.all);

final todoListProvider =
    StateNotifierProvider<TodoListManager, List<TodoModel>>(
  (ref) {
    return TodoListManager([
      TodoModel(id: const Uuid().v4(), description: "Go to gym"),
      TodoModel(id: const Uuid().v4(), description: "Go to market"),
      TodoModel(id: const Uuid().v4(), description: "Shoping"),
      TodoModel(id: const Uuid().v4(), description: "Watch movie"),
    ]);
  },
);

final filteredTodoList = Provider<List<TodoModel>>((ref) {
  final filter = ref.watch(todoListFitler);
  final todoList = ref.watch(todoListProvider);

  switch (filter) {
    case TodoListFitler.all:
      return todoList;
    case TodoListFitler.completed:
      return todoList.where((element) => element.completed).toList();
    case TodoListFitler.active:
      return todoList.where((element) => !element.completed).toList();
  }
});

final unCompletedTodoCount = Provider<int>((ref) {
  final allTodo = ref.watch(todoListProvider);
  final count = allTodo.where((element) => !element.completed).length;
  return count;
});

final currentTodoProvider = Provider<TodoModel>((ref) {
  throw UnimplementedError();
});
