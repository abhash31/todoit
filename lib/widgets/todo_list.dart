import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos/providers/todo_provider.dart';

class TodoList extends ConsumerStatefulWidget {
  const TodoList({super.key});


  @override
  ConsumerState<TodoList> createState() => _TodoListState();
}

class _TodoListState extends ConsumerState<TodoList> {
  late Future<void> _savedTodosFuture;
  // final 
  @override
  void initState() {
    _savedTodosFuture = ref.read(todoProvider.notifier).loadTodo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var todoList = ref.watch(todoProvider);
    Widget content = const Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.file_copy_rounded,
          color: Colors.black38,
          size: 40,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'No Todos left',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black38,
            fontSize: 17,
          ),
        ),
        Text(
          'What are you up to next?',
          style: TextStyle(
              fontFamily: 'Poppins', color: Colors.black38, fontSize: 17),
        )
      ],
    ));

    if (todoList.isNotEmpty) {
      content = FutureBuilder(
        future: _savedTodosFuture,
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.yellow[800],
                  ),
                )
              : ListView.builder(
                  itemCount: todoList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 5.0, left: 10),
                      child: Dismissible(
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerRight,
                                  end: Alignment.centerLeft,
                                  colors: [
                                Colors.red[700]!,
                                Colors.white,
                              ])),
                          child: const Icon(Icons.delete, color: Colors.white, size: 25,),
                        ),
                        key: ValueKey(todoList[index].title),
                        direction: DismissDirection.endToStart,
                        onDismissed: (dir) {
                          setState(() {
                            ref
                                .read(todoProvider.notifier)
                                .removeTodo(todoList[index]);
                          });
                        },
                        child: ListTile(
                          onLongPress: (){
                            setState(() {
                              ref.read(todoProvider.notifier).toggleImportant(todoList[index]);
                            });
                          },
                          onTap: () {
                            setState(() {
                              ref
                                  .read(todoProvider.notifier)
                                  .toggleChecked(todoList[index]);
                            });
                          },
                          leading: Icon(
                            todoList[index].isChecked
                                ? Icons.check_box_outlined
                                : Icons.check_box_outline_blank_rounded,
                            size: 20,
                          ),
                          title: Text(
                            todoList[index].title,
                            style: TextStyle(
                                color: todoList[index].isChecked
                                    ? Colors.black54
                                    : null,
                                fontSize: 20,
                                fontFamily: 'Poppins',
                                decoration: todoList[index].isChecked
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none),
                          ),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                color: todoList[index].isImportant
                                    ? Colors.red
                                    : null,
                                ),
                                width: 10,
                                height: 10,
                              ),
                              Text(
                                todoList[index].dateCreated,
                                style: const TextStyle(fontFamily: 'Poppins'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
        },
      );
    }
    return content;
  }
}
