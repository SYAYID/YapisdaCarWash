import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class Auth with ChangeNotifier{

  signup(String email, String password) async {
    Uri url = Uri.parse("https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=[AIzaSyAnOO9_uUR0drx06xn5nWOh4b6d0Y7x9bA]");

    var response = await http.post(
        url,
        body: json.encode({
      "email": email,
      "password": password,
      "returnSecureToken": true,
    }));
  }
}