import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'http_exception.dart';

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
      final responseData = json.decode(response.body);
      //TODO: This is not properly passing over the HttpException error response to AuthCard
      if (responseData['error'] != null) {
        //if the API call retrieves an error
        throw HttpException(
          //throw custom error handling method
          message: responseData['error']['message'],
          //display the error message returned in the API call (the value assigned to the message within the error array)
        );
        //in the case that the API response returns an error, we are handling this as an HttpException
        //when we are throwing that HttpException, we are populating it with the values from the message within the error API response
        //we are going to try to call on this in the Auth Card
      }
    } catch (error) {
      // print(error);
      throw error;
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
