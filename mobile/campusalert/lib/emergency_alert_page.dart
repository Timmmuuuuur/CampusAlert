import 'package:campusalert/building_prompt_page.dart';
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
        // ElevatedButton(
        //   onPressed: () {
        //     // Navigate to the SecondPage when the button is pressed
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => BuildingPromptPage()),
        //     );
        //   },
        //   child: Text('Go to Second Page'),
        // ),

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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BuildingPromptPage()),
            );
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

//   void _login(VoidCallback onSuccess, AppState appState) async {
//     // Implement the login logic here
//     // You can validate the username and password, make API requests, etc.

//     if (_username == null) {
//       setState(() {
//         _errorMessage = 'Please enter the username';
//       });
//       return;
//     }

//     if (_password == null) {
//       setState(() {
//         _errorMessage = 'Please enter the password';
//       });
//       return;
//     }

//     if (await appState.login(_username!, _password!)) {
//       onSuccess();
//     } else {
//       setState(() {
//         _errorMessage = 'Invalid username or password';
//       });
//     }
//   }
// }