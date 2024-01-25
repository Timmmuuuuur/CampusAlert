import 'package:campusalert/main.dart';
import 'package:campusalert/alert/threat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlertRoutePage extends StatelessWidget {
  final String title;
  final bool canPop; // Whether user is allowed to go to previous apge
  final Widget form;
  final bool Function() nextButtonEnabledCallback;
  final VoidCallback onNextPageCallback;

  AlertRoutePage? nextPage;

  AlertRoutePage({
    required title,
    required canPop,
    required form,
    required nextButtonEnabledCallback,
    required onNextPageCallback,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          form,
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: nextButtonEnabledCallback() ? () {
              if (nextPage == null) {
                onNextPageCallback();
                nextPage = appState.alertRoute.next(context);
              }
            } : null,
            child: Text('Next Page'),
          ),
        ],
      ),
    );
  }
}

class ThreatTypePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return PopScope(
        canPop: false,
        child: Scaffold(
          appBar: AppBar(
            title: Text('WHAT THREAT ARE YOU EXPERIENCING?'),
          ),
          body: Center(
            child: DropdownButton<SyncThreat>(
              value: appState.selectedSyncThreat.value,
              onChanged: (SyncThreat? newValue) {
                if (newValue != null) {
                  appState.selectedSyncThreat.value = newValue;
                }
              },
              items: SyncThreat.values
                  .map<DropdownMenuItem<SyncThreat>>((SyncThreat value) {
                return DropdownMenuItem<SyncThreat>(
                  value: value,
                  child: Text(value.name),
                );
              }).toList(),
            ),
          ),
        ));
  }
}

class BuildingFindingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PLEASE INDICATE WHICH BUILDING THE THREAT OCCURED.'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            onChanged: (input) {
              // Assuming you only have one input field
              Provider.of<AppState>(context, listen: false)
                  .addInput(InputData(input: input));
            },
            decoration: InputDecoration(labelText: 'Enter Data'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NextPage()),
              );
            },
            child: Text('Next Page'),
          ),
        ],
      ),
    );
  }
}

class FloorFindingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PLEASE INDICATE WHICH BUILDING THE THREAT OCCURED.'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            onChanged: (input) {
              // Assuming you only have one input field
              Provider.of<AppState>(context, listen: false)
                  .addInput(InputData(input: input));
            },
            decoration: InputDecoration(labelText: 'Enter Data'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NextPage()),
              );
            },
            child: Text('Next Page'),
          ),
        ],
      ),
    );
  }
}

class RoomFindingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PLEASE INDICATE WHICH BUILDING THE THREAT OCCURED.'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            onChanged: (input) {
              // Assuming you only have one input field
              Provider.of<AppState>(context, listen: false)
                  .addInput(InputData(input: input));
            },
            decoration: InputDecoration(labelText: 'Enter Data'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NextPage()),
              );
            },
            child: Text('Next Page'),
          ),
        ],
      ),
    );
  }
}

class RoomRouterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PLEASE INDICATE WHICH BUILDING THE THREAT OCCURED.'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            onChanged: (input) {
              // Assuming you only have one input field
              Provider.of<AppState>(context, listen: false)
                  .addInput(InputData(input: input));
            },
            decoration: InputDecoration(labelText: 'Enter Data'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NextPage()),
              );
            },
            child: Text('Next Page'),
          ),
        ],
      ),
    );
  }
}
