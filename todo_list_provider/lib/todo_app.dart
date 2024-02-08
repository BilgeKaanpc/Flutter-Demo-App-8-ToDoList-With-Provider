import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_provider/future_provider.dart';
import 'package:todo_list_provider/providers/all_providers.dart';
import 'package:todo_list_provider/widgets/title_widget.dart';
import 'package:todo_list_provider/widgets/todo_list_item.dart';
import 'package:todo_list_provider/widgets/toolbar_widget.dart';

class ToDoApp extends ConsumerWidget {
  ToDoApp({super.key});
  final newTodoController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var allTodos = ref.watch(filteredTodoList);
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        children: [
          const TitleWidget(),
          TextField(
            onSubmitted: (value) {
              ref.read(todoListProvider.notifier).addTodo(value);
            },
            controller: newTodoController,
            decoration: const InputDecoration(
              label: Text("What will you do?"),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ToolBarWidget(),
          allTodos.isEmpty
              ? const Center(child: Text("You are free"))
              : const SizedBox(),
          for (int i = 0; i < allTodos.length; i++)
            Dismissible(
              key: ValueKey(allTodos[i].id),
              onDismissed: (direction) {
                ref.read(todoListProvider.notifier).remove(allTodos[i]);
              },
              child: ProviderScope(
                overrides: [
                  currentTodoProvider.overrideWithValue(allTodos[i]),
                ],
                child: const TodoListItems(),
              ),
            ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: ((context) => const FutureProviderExample()),
                ),
              );
            },
            child: const Text("Future Provider Example"),
          )
        ],
      ),
    );
  }
}
