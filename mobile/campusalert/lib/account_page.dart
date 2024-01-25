import 'package:campusalert/auth.dart';
import 'package:campusalert/building_prompt_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';
import 'components/drag_activation.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var fcmTokenString = appState.appContext.fcmToken ?? "[No token]";

    return Column(
      children: [
        SizedBox(height: 30.0),
        LogoutButton(),
        Text("FCM Token: $fcmTokenString"),
      ],
    );
  }
}

class LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Handle button press here
        _onPressed(context);
      },
      child: Text('Log out'),
    );
  }

  void _onPressed(BuildContext context) {
    // Display a message when the button is pressed
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Logging out'),
      ),
    );

    Credential.logout();
    Navigator.pushReplacementNamed(context, '/');
  }
}
