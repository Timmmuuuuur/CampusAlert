import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:campusalert/auth.dart';
import 'package:campusalert/local_store.dart';

class APIService {
  // TODO: Development URL. Change this to production later.
  static final String baseURL = "10.0.2.2:8080";

  static Future<http.Response> post(
      String path, Map<String, String> headers, String body) {
    var url = Uri.http(baseURL, path);
    return http.post(url, headers: headers, body: body);
  }

  static Future<http.Response> get(String path, Map<String, String> headers) {
    var url = Uri.http(baseURL, path);
    return http.get(url, headers: headers);
  }

  static Future<http.Response> getByUri(Uri uri, Map<String, String> headers) {
    return http.get(uri, headers: headers);
  }

  static Future<Map<String, dynamic>> postLogin(
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
  static Future<Map<String, dynamic>> postCommon(
      String path, Map<String, dynamic> body) async {
    return json.decode(
        (await post(path, await getCommonHeaders(), jsonEncode(body))).body);
  }

  // get format in JSON and with authentication token
  static Future<Map<String, dynamic>> getCommon(String path) async {
    return json.decode((await get(path, await getCommonHeaders())).body);
  }

    static Future<Map<String, dynamic>> getCommonWithUri(Uri uri) async {
    return json.decode((await getByUri(uri, await getCommonHeaders())).body);
  }

  // like getCommon, but automatically collapses pagination with the following format:
  /* {
    "count": <how many items there are>,
    "next": <URL to the next page>,
    "previous": <URL to the previous page>,
    "results": [ <list of data on this page> ]
  } */
  static Future<List<dynamic>> getCommonWithPagination(String path) async {
    Uri next = Uri.http(baseURL, path);
    List<dynamic> collapsed = <dynamic>[];

    while (true) {
      Map<String, dynamic> page = await getCommonWithUri(next);
      collapsed.addAll(page["results"]);
      var nextAsString = page["next"];
      if (nextAsString == null) {
        break;
      }
      next = Uri.parse(nextAsString);
    }

    return collapsed;
  }

  static Future<Map<String, String>> getCommonHeaders() async {
    final accessToken = await getAccessTokenSafe();
    return {
      'Authorization': 'JWT $accessToken',
      'Content-Type': 'application/json',
    };
  }

  // not enabled server-side for now
  /* Future<String?> refreshToken(String refreshToken) async {
    // Implement the token refresh API request here
  } */

  static Future<User> whoami() async {
    // check what the server thinks we are
    Map<String, dynamic> response = await getCommon("auth/whoami/");
    return User(
      username: response["username"],
      email: response["email"],
    );
  }

  static final SPStringPair accessTokenStore = SPStringPair('access_token');

  // acquire the access token, and update it if it's missing or expired
  // Throws LastCredentialMissingException if the user is not logged in
  // TODO: this still does not deal with the situation where the user's credential changed as the user is using the app
  static Future<String> getAccessTokenSafe() async {
    String? nullableToken = await accessTokenStore.get();
    String token;

    // if the token is missing
    if (nullableToken == null) {
      print('Token is missing. Fetching a new one...');
      // TODO: try is needed here
      token = await ((await Credential.getLastCredential()).login());
    } else {
      token = nullableToken;
    }

    // if the token is expired
    if (JwtDecoder.isExpired(token)) {
      print('Token is expired. Fetching a new one...');
      // TODO: try is needed here
      token = await ((await Credential.getLastCredential()).login());
    }

    return token;
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
