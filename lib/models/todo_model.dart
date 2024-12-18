// import 'package:flutter/material.dart';

enum Importance {
  high,
  normal,
  low,
}

class Todo {
  final String title;
  bool isImportant;
  bool isChecked;
  final String dateCreated;
  Todo({required this.title, required this.isImportant, required this.isChecked, required this.dateCreated});
}