import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';
import 'drag_activation.dart';

class EmergencyAlertPage extends StatelessWidget {
  const EmergencyAlertPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Column(
      children: [
        Text('EMERGENCY ALERT SWITCH',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 50,
              color: Colors.red,
              fontWeight: FontWeight.w900,
            )),
        Text(appState.appContext.fcmToken ?? "[No token]"),
        Text(appState.lastMessage),
        DragActivationComponent(
          onActivate: () {
            print("Swipping done!");
          },
        ),
        Text(
            'Swiping the above switch will activate the alarm campus-wide.\nONLY USE THIS IF ANYONE MAY BE IN IMMEDIATE/POTENTIAL DANGER.\nKNOWINGLY ACTIVATING A FALSE ALARM WILL RESULT IN DISCIPLINARY ACTIONS.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 25, color: Colors.red, fontWeight: FontWeight.w900))
      ],
    );
  }
}

class TestCountDisplayer extends StatelessWidget {
  const TestCountDisplayer({
    super.key,
    required this.count,
  });

  final int count;

  @override
  Widget build(BuildContext context) {
    return Text(count.toString());
  }
}
