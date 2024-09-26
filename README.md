## Pembuatan Aplikasi To-Do List dengan Flutter dan Provider

### Pendahuluan

Aplikasi To-Do List adalah aplikasi sederhana yang memungkinkan pengguna untuk menambahkan, menandai selesai, dan menghapus tugas. Dalam materi ini, kita akan membangun aplikasi To-Do List menggunakan Flutter dan state management dengan Provider. Aplikasi ini akan terdiri dari dua layar utama: satu untuk melihat daftar tugas (`TodoList`) dan satu untuk menambahkan tugas baru (`AddTodo`).

### Struktur Proyek

1. **main.dart**: Entry point dari aplikasi.
2. **models/task_model.dart**: Model untuk tugas.
3. **models/save_task.dart**: Model untuk menyimpan dan mengelola daftar tugas.
4. **screens/add_todo.dart**: Halaman untuk menambahkan tugas baru.
5. **screens/todo_list.dart**: Halaman utama untuk menampilkan daftar tugas.

### 1. Membuat Model Tugas

**models/task_model.dart**

```dart
class Task {
  final String title;
  bool isCompleted;

  Task({
    required this.title,
    required this.isCompleted,
  });

  void isDone() {
    isCompleted = !isCompleted;
  }
}
```

- **Task**: Kelas model yang merepresentasikan tugas dengan dua properti: `title` (judul tugas) dan `isCompleted` (status penyelesaian tugas).
  - **isDone**: Metode untuk mengubah status penyelesaian tugas.

### 2. Membuat Model untuk Menyimpan dan Mengelola Daftar Tugas

**models/save_task.dart**

```dart
import 'package:flutter/material.dart';
import 'package:to_do_list/models/task_model.dart';

class SaveTask extends ChangeNotifier {
  final List<Task> _tasks = [
    Task(title: 'Flutter Mudah', isCompleted: true),
    Task(title: 'Flutter Keren', isCompleted: false),
  ];

  List<Task> get tasks => _tasks;

  void addTask(Task task) {
    tasks.add(task);
    notifyListeners();
  }

  void removeTask(Task task) {
    tasks.remove(task);
    notifyListeners();
  }

  void checkTask(int index) {
    tasks[index].isDone();
    notifyListeners();
  }
}
```

- **SaveTask**: Kelas yang mengelola daftar tugas menggunakan `ChangeNotifier` untuk memberikan notifikasi jika ada perubahan pada daftar tugas.
  - **_tasks**: Daftar tugas yang disimpan secara privat dan diinisialisasi dengan beberapa tugas awal.
  - **tasks**: Getter untuk mengakses daftar tugas.
  - **addTask**: Menambahkan tugas baru ke dalam daftar dan memberi tahu pendengar.
  - **removeTask**: Menghapus tugas dari daftar dan memberi tahu pendengar.
  - **checkTask**: Mengubah status penyelesaian tugas berdasarkan indeks dan memberi tahu pendengar.

### 3. Membuat Halaman untuk Menambahkan Tugas Baru

**screens/add_todo.dart**

```dart
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
```

- **AddTodo**: Halaman untuk menambahkan tugas baru.
  - **controller**: `TextEditingController` untuk mengelola input teks dari `TextField`.
  - **TextField**: Input teks untuk memasukkan judul tugas.
  - **ElevatedButton**: Tombol untuk menambahkan tugas baru ke dalam daftar dan kembali ke halaman sebelumnya.

### 4. Membuat Halaman Utama untuk Menampilkan Daftar Tugas

**screens/todo_list.dart**

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/models/save_task.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/add-todo-screen');
        },
        child: const Icon(Icons.add),
      ),
      body: Consumer<SaveTask>(
        builder: (context, task, child) {
          return ListView.builder(
            itemCount: task.tasks.length,
            itemBuilder: (BuildContext context, index) {
              return ListTile(
                title: Text(
                  task.tasks[index].title,
                  style: TextStyle(
                    decoration: task.tasks[index].isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                trailing: Wrap(
                  children: [
                    Checkbox(
                      value: task.tasks[index].isCompleted,
                      onChanged: (_) {
                        context.read<SaveTask>().checkTask(index);
                      },
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<SaveTask>().removeTask(
                              task.tasks[index],
                            );
                      },
                      icon: const Icon(
                        Icons.delete,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
```

- **TodoList**: Halaman utama yang menampilkan daftar tugas.
  - **FloatingActionButton**: Tombol untuk menavigasi ke halaman penambahan tugas baru.
  - **Consumer<SaveTask>**: Widget yang mendengarkan perubahan pada `SaveTask` dan membangun ulang UI saat ada perubahan.
  - **ListView.builder**: Widget untuk membangun daftar tugas secara dinamis.
    - **ListTile**: Widget untuk setiap item dalam daftar, menampilkan judul tugas dan opsi untuk menandai selesai atau menghapus tugas.

### 5. Mengintegrasikan Semua Komponen dalam Aplikasi Utama

**main.dart**

```dart
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const TodoList(),
        '/add-todo-screen': (context) => AddTodo(),
      },
    );
  }
}
```

- **main.dart**: Entry point dari aplikasi.
  - **ChangeNotifierProvider**: Membungkus aplikasi dengan `Provider` untuk menyediakan instance `SaveTask` ke seluruh widget di dalam aplikasi.
  - **MyApp**: Widget utama aplikasi.
    - **MaterialApp**: Widget utama untuk aplikasi yang menyediakan routing dan tema.
    - **initialRoute**: Rute awal aplikasi, yaitu halaman utama (`TodoList`).
    - **routes**: Mendefinisikan rute-rute dalam aplikasi, termasuk halaman utama (`TodoList`) dan halaman penambahan tugas (`AddTodo`).

### Kesimpulan

Dengan mengikuti langkah-langkah di atas, kita telah membangun sebuah aplikasi To-Do List yang lengkap menggunakan Flutter dan Provider. Aplikasi ini memungkinkan pengguna untuk menambahkan, menandai selesai, dan menghapus tugas dengan mudah. Dengan memanfaatkan state management dari Provider, kita dapat memastikan bahwa perubahan pada daftar tugas secara otomatis memperbarui UI tanpa perlu pengelolaan state manual yang rumit.
