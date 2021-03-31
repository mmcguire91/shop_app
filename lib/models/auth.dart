import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Auth with ChangeNotifier {
  String _token;
  DateTime _tokenExpirationDate;
  String _userID;

  Future<void> signup(String email, String password) async {
    final String apiKey = 'AIzaSyBjYmlIK3501f_ztt0KC9IHzZRj4FMfO4o';

    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey');
    //.parse method allows the use of the full url
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      print(json.decode(response.body));
    } catch (error) {
      print(error);
      throw (error);
    }
  }
}
