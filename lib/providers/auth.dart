import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userID;

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userID!;
  }

  String? get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

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
      _token = responseData['idToken'];
      _userID = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  Future signUp(String email, String password) async =>
      _authenticate(email, password, "accounts:signUp");

  Future login(String email, String password) async =>
      _authenticate(email, password, "accounts:signInWithPassword");

  void logout() {
    _token = null;
    _userID = null;
    _expiryDate = null;
    notifyListeners();
  }
}
