import 'package:todos/providers/todo_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:todos/widgets/selectable_button.dart';

class AddTodoItem extends ConsumerStatefulWidget {
  const AddTodoItem({
    super.key,
  });

  @override
  ConsumerState<AddTodoItem> createState() => _AddTodoItemState();
}

class _AddTodoItemState extends ConsumerState<AddTodoItem> {
  bool _isImportant = false;
  DateTime selectedDate = DateTime.now();

  final _inputController = TextEditingController();
  final _dateController = FixedExtentScrollController();

  // void _selectPriority(String buttonText) {
  //   setState(() {
  //     _selectedPriority = buttonText;
  //   });
  // }

  @override
  void dispose() {
    _inputController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      title: const Text(
        'Add a new todo',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 17, fontFamily: 'Poppins', fontWeight: FontWeight.w600),
      ),
      content: SizedBox(
        // height: 200,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              
              TextField(
                autofocus: true,
                controller: _inputController,
                decoration: const InputDecoration(
                  hintText: 'Enter todo here',
                  hintStyle: TextStyle(color: Colors.black54),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                style: const TextStyle(fontFamily: 'Poppins'),
                cursorColor: Colors.black54,
              ),
              
              const SizedBox(height: 20,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    // 'xxcss',
                    'Task Date: ${DateFormat('dd MMM').format(selectedDate)}',
                    style: const TextStyle(fontSize: 17, fontFamily: 'Poppins'),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: 100,
                    width: 200, // Adjust height based on your preference
                    child: ListWheelScrollView.useDelegate(
                      itemExtent: 30,
                      useMagnifier: true,
                      onSelectedItemChanged: (index) {
                        if (index >= 0) {
                          setState(() {
                            selectedDate =
                                DateTime.now().add(Duration(days: index));
                          });
                        } else {
                          // Reset the scroll position to today if index goes below 0
                          _dateController.jumpToItem(0);
                          selectedDate = DateTime.now();
                        }
                      },
                      // diameterRatio: 1,
                      overAndUnderCenterOpacity: 0.2,
                      physics: const FixedExtentScrollPhysics(),
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, index) {
                          if (index < 0) return null;
                          DateTime date =
                              DateTime.now().add(Duration(days: index));
                          return Center(
                            child: Text(
                                  DateFormat('dd MMM').format(date),
                              style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'Poppins',
                                  fontWeight: selectedDate.day == date.day
                                      ? FontWeight.w600
                                      : null),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              GestureDetector(
                onTap: (){
                  setState(() {
                    _isImportant = !_isImportant;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(_isImportant? Icons.check_box_rounded  :Icons.check_box_outline_blank_rounded, size: 20,),
                    const SizedBox(width: 7,),
                    const Text('Mark as important', style: TextStyle(fontFamily: 'Poppins'),),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          style: const ButtonStyle(
            overlayColor: WidgetStatePropertyAll(Colors.black12),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (_inputController.text.isNotEmpty) {
              ref.read(todoProvider.notifier).addTodo(
                  _inputController.text,
                  _isImportant,
                  false,
                  DateFormat('dd MMM').format(selectedDate));
            }
              Navigator.of(context).pop();
            // print(_inputController.text);
          },
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.yellow[700]),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          child: const Text(
            'Submit',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
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
