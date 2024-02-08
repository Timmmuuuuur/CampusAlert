import 'package:campusalert/components/alert_route_page.dart';
import 'package:flutter/material.dart';

class AlertRoute {
  final List<AlertRoutePage> list = [];

  void clear() {
    list.clear();
  }

  void begin(BuildContext context, List<AlertRoutePage> ps) {
    clear();
    extendSome(ps);
    next(context);
  }

  // Adding at the end
  void extend(AlertRoutePage p) {
    list.add(p);
  }

  // Adding multiple at the end
  void extendSome(List<AlertRoutePage> ps) {
    for (var e in ps) {
      list.add(e);
    }
  }

  // Adding at the start
  void push(AlertRoutePage p) {
    list.insert(0, p);
  }

  AlertRoutePage? next(BuildContext context) {
    // If we reach the end of the flow, we just return to the main app again.
    if (list.isEmpty) {
      Navigator.pushReplacementNamed(context, '/main_app');
      return null;
    }

    var page = list.removeAt(0);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );

    return page;
  }
}
