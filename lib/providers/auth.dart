import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthProvider with ChangeNotifier {

  Future signUp(String email, String password) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDa0wMGJ_NIUkIwKezZpnUdDz7-2APNN0o';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: json.encode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );
    print(response.statusCode);
    print(response.body);
  }

  Future login(String email, String password) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDa0wMGJ_NIUkIwKezZpnUdDz7-2APNN0o';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: json.encode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );
    print(response.statusCode);
    print(response.body);
  }
}
