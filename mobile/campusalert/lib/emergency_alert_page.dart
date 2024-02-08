import 'package:campusalert/building_prompt_page.dart';
import 'package:campusalert/components/alert_route_page.dart';
import 'package:campusalert/schemas/schema.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';
import 'components/drag_activation.dart';

import 'package:campusalert/components/title.dart' as title;

class EmergencyAlertPage extends StatelessWidget {
  const EmergencyAlertPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var schemaFetcher = context.watch<SchemaFetcher>();

    return Column(
      children: [
        title.Title(text: 'EMERGENCY ALERT SWITCH'),
        Text(appState.lastMessage),
        DragActivationComponent(
          onActivate: () {
            appState.clearEmergency();
            appState.alertRoute.begin(context, defaultPages());
          },
        ),
        Text(
            'Swiping the above switch will activate the alarm campus-wide.\nONLY USE THIS IF ANYONE MAY BE IN IMMEDIATE/POTENTIAL DANGER.\nKNOWINGLY ACTIVATING A FALSE ALARM WILL RESULT IN DISCIPLINARY ACTIONS.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 25, color: Colors.red, fontWeight: FontWeight.w900)),
        // TODO: fetch text with async
        Text(schemaFetcher.lastUpdate ?? "No date found"),
        TextButton(
          onPressed: () => schemaFetcher.checkForUpdateAndUpdate(),
          child: Text('Update database'),
        ),
        // TODO: remove debug button
        TextButton(
          onPressed: () => schemaFetcher.debugDeleteDate(),
          child: Text('DEBUG: clear date'),
        ),
      ],
    );
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