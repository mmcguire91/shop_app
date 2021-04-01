import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//Holds authentication API calls

class Auth with ChangeNotifier {
  String _token;
  DateTime _tokenExpirationDate;
  String _userID;

  final String apiKey = 'AIzaSyBjYmlIK3501f_ztt0KC9IHzZRj4FMfO4o';

  //AUTHENTICATION method - extracted to reduce reuse of code
  Future<void> _authenticate(
      {String email, String password, String urlSegment}) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$apiKey');
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
      print(response.statusCode);
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  //AUTHENTICATION CREATE API call - Register user
  Future<void> signup(String email, String password) async {
    _authenticate(
      email: email,
      password: password,
      urlSegment: 'signUp',
    );
  }

//AUTHENTICATION READ API call - user sign in
  Future<void> signin(String email, String password) async {
    _authenticate(
      email: email,
      password: password,
      urlSegment: 'signInWithPassword',
    );
  }
}
