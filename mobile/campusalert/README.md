# CampusAlert

## Development
It is highly recommended that you use Visual Studio Code to do developments. See this for setting up the environment: https://codelabs.developers.google.com/codelabs/flutter-codelab-first#1

0. Before anything else, make sure you have Flutter SDK: https://docs.flutter.dev/get-started/install
1. Run `flutter pub upgrade`
- NOTE: If this command fails, you may need to run `flutter channel beta` then `flutter upgrade` in order to have the valid version of Dart SDK
2. Run `flutter devices` to see what devices are available to you
2. To run the app in debug mode, run `flutter run -d <the device you want to run>`. It should be in debug mode by default.

Visual Studio Code plug-in can make the above process a lot easier. It includes feature such as starting the app with a single button press, and hot reload and inspector page on the fly.