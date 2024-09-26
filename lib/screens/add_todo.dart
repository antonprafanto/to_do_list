
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/models/save_task.dart';
import 'package:to_do_list/models/task_model.dart';


class AddTodo extends StatelessWidget {
  AddTodo({super.key});

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Title',
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                context.read<SaveTask>().addTask(
                      Task(
                        title: controller.text,
                        isCompleted: false,
                      ),
                    );
                controller.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
