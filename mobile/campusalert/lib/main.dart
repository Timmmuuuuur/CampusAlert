import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:rxdart/rxdart.dart';

import 'emergency_alert_page.dart';

Future<void> main() async {

  // Flutter setup
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  final messaging = FirebaseMessaging.instance;

  // Request permission for notifications
  final appContext = AppContext(
    messaging: messaging,
    setting: await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    ),
    fcmToken: await tokenFromMessaging(messaging),
    messageStreamController: BehaviorSubject<RemoteMessage>(),
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Handling a foreground message: ${message.messageId}');
    print('Message data: ${message.data}');
    print('Message notification: ${message.notification?.title}');
    print('Message notification: ${message.notification?.body}');

    appContext.messageStreamController.sink.add(message);
  });

  runApp(App(
    appContext: appContext,
  ));
}

Future<String?> tokenFromMessaging(FirebaseMessaging messaging) async {
  const vapidKey =
      "BO9ATZGx7lgRCyIx9LRImQkRVnjBXUV1bvDoq3nkrcqwFoQn8PUbKUcAOCqXE5369Ak9Qd8ZAxSCpnnWjKyPjUI";
  String? token;

  if (DefaultFirebaseOptions.currentPlatform == DefaultFirebaseOptions.web) {
    token = await messaging.getToken(
      vapidKey: vapidKey,
    );
  } else {
    token = await messaging.getToken();
  }

  return token;
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
  print('Message data: ${message.data}');
  print('Message notification: ${message.notification?.title}');
  print('Message notification: ${message.notification?.body}');

}


class AppContext {
  final FirebaseMessaging messaging;
  final NotificationSettings setting;
  final String? fcmToken;
  final BehaviorSubject messageStreamController;

  const AppContext({
    required this.messaging,
    required this.setting,
    required this.fcmToken,
    required this.messageStreamController,
  });
}

class App extends StatelessWidget {
  final AppContext appContext;

  App({super.key, required this.appContext}) {
    if (appContext.setting.authorizationStatus ==
        AuthorizationStatus.authorized) {
      print('User granted permission for notifications');
      print(appContext.fcmToken ?? '');
    } else {
      print('User declined or has not yet granted permission');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(appContext: appContext),
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
  final AppContext appContext;

  AppState({required this.appContext}) {
    appContext.messageStreamController
        .listen((message) => onNewMessage(message));
  }

  var count = 1;
  var selectedPageIndex = 0;

  String lastMessage = "";

  void increment() {
    count += 1;
    notifyListeners();
  }

  void selectPage(int index) {
    selectedPageIndex = index;
    notifyListeners();
  }

  void onNewMessage(message) {
    if (message.notification != null) {
      lastMessage = 'Received a notification message:'
          '\nTitle=${message.notification?.title},'
          '\nBody=${message.notification?.body},'
          '\nData=${message.data}';
    } else {
      lastMessage = 'Received a data message: ${message.data}';
    }
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
