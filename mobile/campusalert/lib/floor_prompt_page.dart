import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';
import 'drag_activation.dart';

class FloorPromptPage extends StatelessWidget {


  const FloorPromptPage({
    super.key,
  });
  
  // void _submitForm() {
  //   if (_formKey.currentState!.validate()) {
  //     setState(() {
  //       _enteredText = _textEditingController.text;
  //     });
  //   }
  // }
  // final String _enteredText = '';
  // final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Column(
      children: [
        Text('WHAT FLOOR ARE YOU ON? PLEASE ENTER THE FLOOR NUMBER:',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              color: Colors.red,
              fontWeight: FontWeight.w900,
            )),
        // TextFormField(
        //   decoration: InputDecoration(
        //     labelText: 'BUILDING NAME WITHOUT SPACES',
        //   ),
        //   // onSaved: (String? value) {
        //   //   // This optional block of code can be used to run
        //   //   // code when the user saves the form.
        //   // },
        //   validator: (String? value) {
        //     return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
        //   },
        // ),
        // SizedBox(height: 16.0),
        // ElevatedButton(
        //   onPressed: _submitForm,
        //   child: Text('Submit'),
        // ),
        // SizedBox(height: 16.0),
        // Text('Entered Text: $_enteredText'),
      // ),
        Text(appState.appContext.fcmToken ?? "[No token]"),
        Text(appState.lastMessage),
        // DragActivationComponent(
        //   onActivate: () {
        //     print("Swipping done!");
        //   },
        // ),
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
