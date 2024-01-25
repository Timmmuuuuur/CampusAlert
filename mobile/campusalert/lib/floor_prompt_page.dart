
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campusalert/emergency_alert_page.dart';

import 'main.dart';
import 'components/drag_activation.dart';

class FloorPromptPage extends StatefulWidget {
  @override
  _FloorPromptPageState createState() => _FloorPromptPageState();
}
class _FloorPromptPageState extends State<FloorPromptPage> {
  String? _buildingName;
  // String? _password;
  // String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('BUILDING PROMPT PAGE'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('WHAT FLOOR ARE YOU ON? PLEASE ENTER FLOOR NUMBER WITHOUT ANY SPACES:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 27,
                  color: Colors.red,
                  fontWeight: FontWeight.w900,
                )),
            TextField(
              onChanged: (value) {
                setState(() {
                  _buildingName = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'FLOOR NUMBER:',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {

                Navigator.pushReplacementNamed(context, '/main_app');
              },
              child: Text('ENTER FLOOR'),
            ),
          ],
        ),
      ),
    );
  }

}

// class FloorPromptPage extends StatelessWidget {


//   const FloorPromptPage({
//     super.key,
//   });
  
//   // void _submitForm() {
//   //   if (_formKey.currentState!.validate()) {
//   //     setState(() {
//   //       _enteredText = _textEditingController.text;
//   //     });
//   //   }
//   // }
//   // final String _enteredText = '';
//   // final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<AppState>();

//     return Column(
//       children: [
//         Text('WHAT FLOOR ARE YOU ON? PLEASE ENTER FLOOR NUMBER:',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 30,
//               color: Colors.red,
//               fontWeight: FontWeight.w900,
//             )),
//         ElevatedButton(
//           onPressed: () {
//             // Navigate to the SecondPage when the button is pressed
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => FloorPromptPage()),
//             );
//           },
//           child: Text('Go to Floor Prompt Page'),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             // Navigate to the SecondPage when the button is pressed
//             Navigator.pushReplacementNamed(context, '/main_app');
//           },
//           child: Text('Go to EMERGENCY ALERT Page'),
//         ),
//         // TextFormField(
//         //   decoration: InputDecoration(
//         //     labelText: 'BUILDING NAME WITHOUT SPACES',
//         //   ),
//         //   // onSaved: (String? value) {
//         //   //   // This optional block of code can be used to run
//         //   //   // code when the user saves the form.
//         //   // },
//         //   validator: (String? value) {
//         //     return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
//         //   },
//         // ),
//         // SizedBox(height: 16.0),
//         // ElevatedButton(
//         //   onPressed: _submitForm,
//         //   child: Text('Submit'),
//         // ),
//         // SizedBox(height: 16.0),
//         // Text('Entered Text: $_enteredText'),
//       // ),
//         // Text(appState.appContext.fcmToken ?? "[No token]"),
//         // Text(appState.lastMessage),
//         // DragActivationComponent(
//         //   onActivate: () {
//         //     print("Swipping done!");
//         //   },
//         // ),
//         // Text(
//         //     'Swiping the above switch will activate the alarm campus-wide.\nONLY USE THIS IF ANYONE MAY BE IN IMMEDIATE/POTENTIAL DANGER.\nKNOWINGLY ACTIVATING A FALSE ALARM WILL RESULT IN DISCIPLINARY ACTIONS.',
//         //     textAlign: TextAlign.center,
//         //     style: TextStyle(
//         //         fontSize: 25, color: Colors.red, fontWeight: FontWeight.w900))
//       ],
//     );
//   }
// }

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
