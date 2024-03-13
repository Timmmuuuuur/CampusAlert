import 'package:campusalert/account_page.dart';
import 'package:campusalert/alert/alert.dart';
import 'package:campusalert/alert/alert_route.dart';
import 'package:campusalert/schemas/database.dart';
import 'package:campusalert/style/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campusalert/api_config.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:campusalert/CrimeHeatMap.dart';

import 'login_page.dart';

import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:campusalert/CrimeHeatMap.dart';

import 'login_page.dart';
import 'emergency_alert_page.dart';
import 'package:campusalert/auth.dart';
import 'package:campusalert/schemas/schema.dart';

import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:campusalert/AdminPost.dart';

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

  AppContext.staticFcmToken = await tokenFromMessaging(messaging);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Handling a foreground message: ${message.messageId}');
    print('Message data: ${message.data}');
    print('Message notification: ${message.notification?.title}');
    print('Message notification: ${message.notification?.body}');

    appContext.messageStreamController.sink.add(message);
  });

  initializeDatabase();

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

Future<bool> _autoLogin(BuildContext context) async {
  // Attempt to automatically log in using past stored user session. If the user is logged out, nothing happens and false is returned
  // This is called when the app first land on the login screen
  try {
    (await Credential.getLastCredential()).login();
    return true;
  } on LastCredentialMissingException {
    return false;
  }
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

  static String? staticFcmToken;

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
    return FutureBuilder<bool>(
      future: _autoLogin(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While the future is still running, return a loading indicator
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Handle errors here, e.g., display an error message
          return BodyText('Error: ${snapshot.error}');
        } else {
          // Data has been successfully fetched, display it
          bool autoLoginSuccess = snapshot.data!;

          return MultiProvider(
            providers: [
              ChangeNotifierProvider<AppState>(
                create: (_) => AppState(appContext: appContext),
              ),
              ChangeNotifierProvider<SchemaFetcher>(
                create: (_) => SchemaFetcher(appContext: appContext),
              )
            ],
            child: MaterialApp(
              title: 'CampusAlert',
              initialRoute: autoLoginSuccess ? '/main_app' : '/',
              routes: {
                '/': (context) => LoginPage(),
                '/main_app': (context) =>
                    PopScope(canPop: false, child: NavigationRoot()),
              },
              theme: ThemeData(
                  useMaterial3: true,
                  colorScheme:
                      ColorScheme.fromSeed(seedColor: Colors.deepOrange),
                  iconTheme: IconThemeData(
                    color: Colors
                        .black, // or any color that contrasts with your background
                  ),
                  fontFamily: 'Overpass'),
            ),
          );
        }
      },
    );
  }
}






class AppState extends ChangeNotifier {
  final AppContext appContext;

  AppState({required this.appContext}) {
    appContext.messageStreamController
        .listen((message) => onNewMessage(message));
    
    // Call the asynchronous method in an initializer list
    _initializeAsync();
  }


  Future<void> _initializeAsync() async {
    await updateAlertPresent();
    notifyListeners();
  }

  // AppState({required this.appContext}) async {
  //   appContext.messageStreamController
  //       .listen((message) => onNewMessage(message));
    
  //   await updateAlertPresent();
  // }

  // emergency information

  // This is a list of emergency route pages we still need to go through. Pages can be dynamically pushed to it.
  AlertRoute alertRoute = AlertRoute();

  // For each new field to keep track of, we need to add more stuff to clearEmergency()
  SyncAlert? activeAlert;

  // for the non-reporters
  bool alertPresent = false;

  var selectedPageIndex = 0;

  String lastMessage = "";

  void selectPage(int index) {
    selectedPageIndex = index;
    notifyListeners();
  }

  Future<void> onNewMessage(message) async {
    String toastMessage;
    if (message.notification != null) {
      toastMessage = 'UPDATE: ${message.notification?.body}';
    } else {
      toastMessage = 'Received a data message: ${message.data}';
    }

    // Show the toast message
    Fluttertoast.showToast(
      msg: toastMessage,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    await updateAlertPresent();
    notifyListeners();
  }

  Future<void> updateAlertPresent() async {
    var alert = await SyncAlert.getActive();
    alertPresent = (alert != null) ? true : false;
    if (alert != null) {
      lastMessage =
          "${alert.threat?.name ?? 'unknown threat'} in ${alert.building?.name ?? 'unknown building'}, ${alert.floor?.name ?? 'unknown floor'}, ${alert.roomNode?.name ?? 'unknown room'}.";
    }

    notifyListeners();
  }

  void newEmergency() {
    activeAlert = SyncAlert(id: -1);
    SyncAlert.createActive();
  }

  void updateAlert(SyncAlert newVal) {
    activeAlert = newVal;
    notifyListeners();
  }
}

class NavigationRoot extends StatelessWidget {
  static List<Widget> _pages = <Widget>[
    EmergencyAlertPage(),
    DriftDbViewer(localDatabase!),
    Column(children: [BodyText("Empty tab")]),
    AccountPage(),
    AdminPost(),
  ];


  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Scaffold(
      body: SafeArea(child: _pages[appState.selectedPageIndex]),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: appState.selectedPageIndex,
        onTap: (int index) => appState.selectPage(index),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.sos_outlined),
            label: 'EMERGENCY',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'BUILDINGS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notification_important),
            label: 'NOTICES',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: 'ACCOUNT',
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.library_books_outlined),
            label: 'BLOG',
          ),
        ],
      ),

    );
  }
}

