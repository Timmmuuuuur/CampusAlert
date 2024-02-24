import 'package:campusalert/floor_prompt_page.dart';
import 'package:campusalert/style/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';
import 'package:http/http.dart' as http;



class BuildingPromptPage extends StatefulWidget {
  @override
  _BuildingPromptPageState createState() => _BuildingPromptPageState();
}
class _BuildingPromptPageState extends State<BuildingPromptPage> {
  String? _buildingName;
  // String? _password;
  // String? _errorMessage;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: BodyText('BUILDING PROMPT PAGE'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BodyText('WHAT BUILDING ARE YOU IN? PLEASE ENTER BUILDING IN ALPHANUMERIC CHARACTERS WITH NO SPACES',
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
                labelText: 'BUILDING NAME(NO SPACES)',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                sendMessage('HELLO THIS IS A TEST BITCHASS MESSAGE!');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FloorPromptPage()),
                );
              },
              child: BodyText('ENTER BUILDING'),
            ),
          ],
        ),
      ),
    );
  }

}

void sendMessage(String message) async {
  final apiUrl = 'http://127.0.0.1:8080/notificationtest';
  
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {'message': message},
    );

    if (response.statusCode == 200) {
      print('Message sent successfully');
    } else {
      print('Failed to send message');
    }
  } catch (e) {
    print('Error: $e');
  }
}

// class BuildingPromptPage extends StatelessWidget {

//   const BuildingPromptPage({
//     super.key,
//   });

//   final String? _buildingname="E7";

  
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
//         BodyText('WHAT BUILDING ARE YOU IN? PLEASE ENTER BUILDING IN ALPHANUMERIC CHARACTERS WITH NO SPACES',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 30,
//               color: Colors.red,
//               fontWeight: FontWeight.w900,
//             )),
//         // TextField(
//         //   onChanged: (value) {
//         //     // _buildingname = value;
//         //   },
//         //   decoration: InputDecoration(
//         //     labelText: 'Username',
//         //   ),
//         // ),
//         // SizedBox(height: 250.0),

//         ElevatedButton(
//           onPressed: () {
//             // Navigate to the SecondPage when the button is pressed
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => FloorPromptPage()),
//             );
//           },
//           child: BodyText('Go to Floor Prompt Page'),
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
//         //   child: BodyText('Submit'),
//         // ),
//         // SizedBox(height: 16.0),
//         // BodyText('Entered Text: $_enteredText'),
//       // ),
//         // BodyText(appState.appContext.fcmToken ?? "[No token]"),
//         // BodyText(appState.lastMessage),
//         // DragActivationComponent(
//         //   onActivate: () {
//         //     print("Swipping done!");
//         //   },
//         // ),
//         // BodyText(
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
    return BodyText(count.toString());
  }
}
