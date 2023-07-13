import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'emergency_alert_page.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'CampusAlert',
        theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
            fontFamily: 'Overpass'),
        home: NavigationRoot(),
      ),
    );
  }
}

class AppState extends ChangeNotifier {
  var count = 1;
  var selectedPageIndex = 0;

  void increment() {
    count += 1;
    notifyListeners();
  }

  void selectPage(int index) {
    selectedPageIndex = index;
    notifyListeners();
  }
}

class NavigationRoot extends StatelessWidget {
  static const List<Widget> _pages = <Widget>[
    EmergencyAlertPage(),
    Icon(
      Icons.camera,
      size: 150,
    ),
    Icon(
      Icons.chat,
      size: 150,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var count = appState.count;

    return Scaffold(
      body: _pages[appState.selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: appState.selectedPageIndex,
        onTap: (int index) => appState.selectPage(index),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.sos_outlined),
            label: 'EMERGENCY ALERT',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notification_important),
            label: 'NOTICES',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: 'ACCOUNT',
          ),
        ],
      ),
    );
  }
}
