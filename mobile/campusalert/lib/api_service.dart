import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:jwt_decoder/jwt_decoder.dart';

class User {
  final String username;
  String? email;

  User({
    required this.username,
    this.email,
  });
}

class APIService {
  // TODO: Development URL. Change this to production later.
  final String baseURL = "10.0.2.2:8080";
  final String username;
  User? user;

  APIService(this.username)
      : user = User(
          username: username,
        );

  Future<http.Response> post(
      String path, Map<String, String> headers, String body) {
    var url = Uri.http(baseURL, path);
    return http.post(url, headers: headers, body: body);
  }

  Future<http.Response> get(String path, Map<String, String> headers) {
    var url = Uri.http(baseURL, path);
    return http.get(url, headers: headers);
  }

  Future<Map<String, dynamic>> postLogin(
      String path, Map<String, dynamic> body) async {
    return json.decode((await post(
            path,
            {
              'Content-Type': 'application/json',
            },
            jsonEncode(body)))
        .body);
  }

  // post and get format in JSON and with authentication token
  Future<Map<String, dynamic>> postCommon(
      String path, Map<String, dynamic> body) async {
    return json.decode(
        (await post(path, await getCommonHeaders(), jsonEncode(body))).body);
  }

  // get format in JSON and with authentication token
  Future<Map<String, dynamic>> getCommon(String path) async {
    return json.decode((await get(path, await getCommonHeaders())).body);
  }

  Future<Map<String, String>> getCommonHeaders() async {
    final accessToken = await getAccessTokenSafe();
    return {
      'Authorization': 'JWT $accessToken',
      'Content-Type': 'application/json',
    };
  }

  Future<String> login(String password) async {
    Map<String, dynamic> response =
        await postLogin("auth/login/", <String, String>{
      "username": username,
      "password": password,
    });

    String? token = response["token"];

    if (token == null) {
      throw HttpException("Login failed");
    } else {
      storePassword(password);
      storeAccessToken(token);
    }

    return token;
  }

  // not enabled server-side for now
  /* Future<String?> refreshToken(String refreshToken) async {
    // Implement the token refresh API request here
  } */

  Future<User> whoami() async {
    Map<String, dynamic> response = await getCommon("auth/whoami/");
    return User(
      username: response["username"],
      email: response["email"],
    );
  }

  Future<void> storeAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  Future<String?> getAccessTokenRaw() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // acquire the access token, and update it if it's missing or expired
  Future<String> getAccessTokenSafe() async {
    String? nullableToken = await getAccessTokenRaw();
    String token;

    // if the token is missing
    if (nullableToken == null) {
      token = await login((await getPassword())!);
    } else {
      token = nullableToken;
    }

    // if the token is expired
    if (JwtDecoder.isExpired(JwtDecoder.decode(token)['exp'])) {
      token = await login((await getPassword())!);
    }

    return token;
  }

  Future<void> storePassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('password', password);
  }

  Future<String?> getPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('password');
  }

  /* Future<void> storeRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('refresh_token', token);
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh_token');
  } */
}
