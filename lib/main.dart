import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/models/save_task.dart';
import 'package:to_do_list/screens/add_todo.dart';
import 'package:to_do_list/screens/todo_list.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SaveTask(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const TodoList(),
        '/add-todo-screen': (context) => AddTodo(),
      },
    );
  }
}
