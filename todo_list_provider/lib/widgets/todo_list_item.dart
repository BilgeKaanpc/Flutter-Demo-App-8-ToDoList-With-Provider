import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list_provider/providers/all_providers.dart';

class TodoListItems extends ConsumerStatefulWidget {
  const TodoListItems({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TodoListItemsState();
}

class _TodoListItemsState extends ConsumerState<TodoListItems> {
  late FocusNode textFocusNode;
  late TextEditingController controller;
  bool hasFocus = false;

  @override
  void initState() {
    super.initState();
    textFocusNode = FocusNode();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    textFocusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  final currentTodo = ref.watch(currentTodoProvider);
    return Focus(
      onFocusChange: (value) {
        if (!value) {
          setState(() {
            hasFocus = false;
          });
          ref
              .read(todoListProvider.notifier)
              .edit(id: currentTodo.id, newDescription: controller.text);
        } else {}
      },
      child: ListTile(
        onTap: () {
          setState(() {
            textFocusNode.requestFocus();
            hasFocus = true;

            controller.text = currentTodo.description;
          });
        },
        title: hasFocus
            ? TextField(
                controller: controller,
                focusNode: textFocusNode,
              )
            : Text(currentTodo.description),
        leading: Checkbox(
          value: currentTodo.completed,
          onChanged: (value) {
            ref.read(todoListProvider.notifier).toggle(currentTodo.id);
          },
        ),
      ),
    );
  }
}
