import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Title extends StatelessWidget {
  
  final String text;

  Title({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 50,
          color: Colors.red,
          fontWeight: FontWeight.w900,
        ));
  }
}
