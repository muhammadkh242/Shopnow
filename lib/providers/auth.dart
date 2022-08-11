import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  Future _authenticate(String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/$urlSegment?key=AIzaSyDa0wMGJ_NIUkIwKezZpnUdDz7-2APNN0o';
    final uri = Uri.parse(url);
    await http
        .post(
      uri,
      body: json.encode(
        {'email': email, 'password': password, 'returnSecureToken': true},
      ),
    )
        .then((response) {
      Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
    }).catchError((error) {
      throw error;
    });
  }

  Future signUp(String email, String password) async =>
      _authenticate(email, password, "accounts:signUp");

  Future login(String email, String password) async =>
      _authenticate(email, password, "accounts:signInWithPassword");
}
