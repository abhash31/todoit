import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos/models/todo_model.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;

Future<Database> _dbInit() async {
  final dbPath = await sqflite.getDatabasesPath();
  final db = await sqflite.openDatabase(
    path.join(dbPath, 'todoDataBase.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE todo_items (title TEXT, isImportant INTEGER, isChecked INTEGER, dateCreated TEXT)');
    },
    version: 1,
  );
  return db;
}

class TodoNotifier extends StateNotifier<List<Todo>> {
  TodoNotifier() : super(const []);

  Future<void> loadTodo() async {
    final db = await _dbInit();
    final data = await db.query('todo_items');
    final todos = data.map((item) {
      return Todo(
          title: item['title'] as String,
          isImportant: (item['isImportant'] as int) == 1,
          isChecked: (item['isChecked'] as int) == 1,
          dateCreated: item['dateCreated'] as String);
    }).toList();

    todos.sort((a, b) {
      if (a.isImportant != b.isImportant) {
        return b.isImportant ? 1 : -1; // Important items first
      }
      return a.dateCreated.compareTo(b.dateCreated); // Then sort by date
    });

    state = todos;
  }

  void addTodo(String title, bool isImportant, bool isChecked,
      String dateCreated) async {
    final newTodo = Todo(
        title: title,
        isImportant: isImportant,
        isChecked: isChecked,
        dateCreated: dateCreated);
    final db = await _dbInit();
    state = [...state, newTodo]..sort((a, b) {
        if (a.isImportant != b.isImportant) {
          return b.isImportant ? 1 : -1; // Important items first
        }
        return a.dateCreated.compareTo(b.dateCreated); // Then sort by date
      });
    db.insert('todo_items', {
      'title': newTodo.title,
      'isImportant': newTodo.isImportant ? 1 : 0,
      'isChecked': newTodo.isChecked ? 1 : 0,
      'dateCreated': newTodo.dateCreated,
    });
  }

  void toggleChecked(Todo item) async {
    item.isChecked = !item.isChecked;
    final db = await _dbInit();
    db.update('todo_items', {'isChecked': item.isChecked ? 1 : 0},
        where: 'title = ?', whereArgs: [item.title]);
  }

  void removeChecked() async {
    state = state.where((todo) => !todo.isChecked).toList();
    final db = await _dbInit();
    await db.delete('todo_items', where: 'isChecked = ?', whereArgs: [1]);
  }

  void removeTodo(Todo item) async {
    state = state.where((todo) => todo != item).toList();
    final db = await _dbInit();
    await db.delete('todo_items', where: 'title = ?', whereArgs: [item.title]);
  }

  void toggleImportant(Todo item) async {
    item.isImportant = !item.isImportant;
    state.sort((a, b) {
      if (a.isImportant != b.isImportant) {
        return b.isImportant ? 1 : -1;
      }
      return a.dateCreated.compareTo(b.dateCreated);
    });

    final db = await _dbInit();
    db.update('todo_items', {'isImportant': item.isImportant ? 1 : 0},
        where: 'title = ?', whereArgs: [item.title]);
    // state = todos;
  }
}

final todoProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
  return TodoNotifier();
});
