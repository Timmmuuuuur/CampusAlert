import 'package:campusalert/auth.dart';
import 'package:campusalert/schemas/schema.dart';
import 'package:campusalert/style/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var fcmTokenString = appState.appContext.fcmToken ?? "[No token]";
    var schemaFetcher = context.watch<SchemaFetcher>();

    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          SizedBox(height: 30),
          LogoutButton(),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => schemaFetcher.checkForUpdateAndUpdate(),
            child: BodyText('Update database'),
          ),
          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200], // Light gray color
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "FCM Token",
                  style: TextStyle(
                    fontWeight: FontWeight.bold, // Make "FCM Token" bold
                  ),
                ),
                Text(
                  fcmTokenString,
                  style: TextStyle(
                    fontWeight: FontWeight.normal, // Make FCM token bold
                  ),
                ),
              ],
            ),
          )
        ],
      )
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
      child: BodyText('Log out'),
    );
  }

  void _onPressed(BuildContext context) {
    // Display a message when the button is pressed
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: BodyText('Logging out'),
      ),
    );

    Credential.logout();
    Navigator.pushReplacementNamed(context, '/');
  }
}
