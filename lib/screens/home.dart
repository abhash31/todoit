import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos/widgets/todo_list.dart';
import 'package:todos/widgets/add_todo.dart';
import 'package:todos/providers/todo_provider.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});
  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  int itemCount = 0;

  // @override
  // void initState() {
  //   super.initState();
  //   _getItemCount();
  // }

  void _getItemCount() {
    setState(() {
      itemCount = ref
          .watch(todoProvider)
          .where((todo) => todo.isChecked == false)
          .length;
    });
  }

  @override
  Widget build(context) {
    _getItemCount();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: SizedBox(
        height: 65,
        width: 65,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return const AddTodoItem();
                  });
            },
            shape: const CircleBorder(),
            backgroundColor: Colors.yellow[700],
            child: const Icon(
              Icons.edit,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.yellow[700],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, right: 20, left: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              ref.read(todoProvider.notifier).removeChecked();
                              _getItemCount();
                            },
                            child: CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.white,
                              child: itemCount > 0
                                  ? Text(
                                      itemCount.toString(),
                                      style: TextStyle(
                                          fontSize: 40,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.yellow[800]),
                                    )
                                  : Icon(
                                      Icons.notes,
                                      size: 35,
                                      color: Colors.yellow[700],
                                    ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        'todoit.',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 50,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.white),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      '${DateTime.now().day.toString()} ${month[DateTime.now().month - 1]}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(
                  top: 10,
                  left: 20,
                ),
                // padding: const EdgeInsets.symmetric(horizontal: 5),
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                  ),
                ),
                child: const TodoList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

const month = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec'
];
