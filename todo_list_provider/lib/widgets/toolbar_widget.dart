// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_provider/providers/all_providers.dart';

class ToolBarWidget extends ConsumerWidget {
  ToolBarWidget({super.key});
  var currentFilter = TodoListFitler.all;

  Color changeTextColor(TodoListFitler filt) {
    return currentFilter == filt ? Colors.orange : Colors.black;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onCompletedTodoCount = ref.watch(unCompletedTodoCount);
    currentFilter = ref.watch(todoListFitler);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            onCompletedTodoCount == 0
                ? "All Todo Completed"
                : "$onCompletedTodoCount todo incomplete",
            overflow: TextOverflow.clip,
          ),
        ),
        Tooltip(
          message: "All Todos",
          child: TextButton(
            style: TextButton.styleFrom(
                foregroundColor: changeTextColor(TodoListFitler.all)),
            onPressed: () {
              ref.read(todoListFitler.notifier).state = TodoListFitler.all;
            },
            child: const Text("All"),
          ),
        ),
        Tooltip(
          message: "Active Todos",
          child: TextButton(
            style: TextButton.styleFrom(
                foregroundColor: changeTextColor(TodoListFitler.active)),
            onPressed: () {
              ref.read(todoListFitler.notifier).state = TodoListFitler.active;
            },
            child: const Text("Active"),
          ),
        ),
        Tooltip(
          message: "Completed Todos",
          child: TextButton(
            style: TextButton.styleFrom(
                foregroundColor: changeTextColor(TodoListFitler.completed)),
            onPressed: () {
              ref.read(todoListFitler.notifier).state =
                  TodoListFitler.completed;
            },
            child: const Text("Completed"),
          ),
        ),
      ],
    );
  }
}
