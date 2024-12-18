import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos/screens/home.dart';
import 'package:flutter/services.dart';

void main(){
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const ProviderScope(
      child: MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  )));
}
