import 'package:campusalert/components/alert_route_page.dart';
import 'package:campusalert/style/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';
import 'components/drag_activation.dart';

class EmergencyAlertPage extends StatelessWidget {
  const EmergencyAlertPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Padding(
      padding: EdgeInsets.all(10.0), 
      child: Column(
        children: [
          SizedBox(height: 40),
          appState.alertPresent
              ? BoxedText("AN EMERGENCY IS ACTIVE\n${appState.lastMessage}")
              : Column(children: [
                  HighlightedTitle('EMERGENCY ALERT SWITCH'),
                  SizedBox(height: 40),
                  DragActivationComponent(
                    onActivate: () {
                      appState.newEmergency();
                      appState.alertRoute.begin(context, defaultPages());
                    },
                  ),
                  SizedBox(height: 100),
                  HighlightedText(
                      'Swiping the above switch will activate the alarm campus-wide.'
                  ),
                  SizedBox(height: 20),
                  HighlightedText(
                      'ONLY USE THIS IF ANYONE MAY BE IN IMMEDIATE/POTENTIAL DANGER.'
                  ),
                  SizedBox(height: 20),
                  HighlightedText(
                      'KNOWINGLY ACTIVATING A FALSE ALARM WILL RESULT IN DISCIPLINARY ACTIONS.'
                  ),
                ]
              ),
          ],
      )
    );
  }
}
