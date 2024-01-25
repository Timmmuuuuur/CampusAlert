import 'package:campusalert/components/emergency_router.dart';
import 'package:flutter/material.dart';

class AlertRoute {
  final List<AlertRoutePage> list = [];

  void extend(AlertRoutePage p) {
    list.add(p);
  }

  void push(AlertRoutePage p) {
    list.insert(0, p);
  }

  AlertRoutePage? next(BuildContext context) {
    // If we reach the end of the flow, we just return to the main app again.
    if (list.isEmpty) {
      Navigator.pushReplacementNamed(context, '/main_app');
      return null;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => list.removeAt(0)),
    );

    return list.removeAt(0);
  }
}
