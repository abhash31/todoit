import 'package:flutter/material.dart';

class SelectableButton  extends StatelessWidget {
  const SelectableButton ({super.key, required this.buttonText, required this.selectedPriority, required this.color, required this.onPress});

  final String selectedPriority;
  final String buttonText;
  final Color color;
  final Function(String s) onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onPress(buttonText);
      },
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            color: selectedPriority == buttonText ? color : null,
            border: Border.all(color: color, width: 2),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            buttonText,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 12,
                color: selectedPriority == buttonText ? Colors.white : color),
          )),
    );
  }
}
