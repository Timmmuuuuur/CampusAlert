import 'package:campusalert/main.dart';
import 'package:campusalert/local_store.dart';
import 'package:campusalert/api_service.dart';

class Credential {
  final User user;
  final String password;
  bool? valid;

  Credential({required this.user, required this.password});

  static final SPStringPair _usernameStore = SPStringPair('username');
  static final SPStringPair _passwordStore = SPStringPair('password');

  static Future<Credential> getLastCredential() async {
    // Get the last user's credential that was logged in if it did
    // Throws LastCredentialMissingException if the credential is missing
    // TODO: make it so that the top level can catch the exception and kick user back to login page if that happens

    String? username = await _usernameStore.get();
    String? password = await _passwordStore.get();

    if (username != null && password != null) {
      return Credential(user: User(username: username), password: password);
    }

    throw LastCredentialMissingException(
        "There isn't a last credential stored! The user is either logged out or the application is in an invalid state.");
  }

  Future<void> store() async {
    if (!(valid ?? false)) {
      // if the crendential isn't confirmed to be valid or is invalid
      throw InvalidCredentialException(
          "Invalid credential attempted to be stored!");
    } else {
      _usernameStore.set(user.username);
      _passwordStore.set(password);
    }
  }

  Future<String> login() async {
    // attempt login using the credential
    // if the credential is successful, it is stored automatically in SharedPreferences
    // otherwise, the credential is invalidated and LoginFailedException is thrown
    Map<String, dynamic> response =
        await APIService.postLogin("auth/login/", <String, String>{
      "username": user.username,
      "password": password,
    });

    String? token = response["token"];

    // associate the user with the current device
    if (AppContext.staticFcmToken != null) {
      APIService.postCommon("auth/add-fcm/", {
        'token': AppContext.staticFcmToken,
      });
    }

    if (token == null) {
      valid = false;
      throw LoginFailedException("Login failed");
    } else {
      valid = true;
      store();
      APIService.accessTokenStore.set(token);
    }

    return token;
  }

  static Future<void> logout() async {
    // attempt logout
    // if the credential is successful, it is stored automatically in SharedPreferences
    // otherwise, the credential is invalidated and LoginFailedException is thrown

    APIService.accessTokenStore.remove();
    _usernameStore.remove();
    _passwordStore.remove();
  }
}

class InvalidCredentialException implements Exception {
  final String message;

  InvalidCredentialException(this.message);

  @override
  String toString() {
    return 'InvalidCredentialException: $message';
  }
}

class LastCredentialMissingException implements Exception {
  final String message;

  LastCredentialMissingException(this.message);

  @override
  String toString() {
    return 'LastCredentialMissingException: $message';
  }
}

class LoginFailedException implements Exception {
  final String message;

  LoginFailedException(this.message);

  @override
  String toString() {
    return 'LoginFailedException: $message';
  }
}

class User {
  final String username;
  String? email;

  User({
    required this.username,
    this.email,
  });
}
