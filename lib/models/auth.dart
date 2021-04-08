import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'http_exception.dart';

//Holds authentication API calls

class Auth with ChangeNotifier {
  String _token;
  DateTime _tokenExpirationDate;
  String _userID;

  String get tokenValid {
    if (_token != null &&
        _tokenExpirationDate != null &&
        _tokenExpirationDate.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }
  //established to determine if there is a token stored locally on the user device and if that token meets the criteria to still be determined as valid

  bool get isAuthValid {
    return tokenValid != null;
    //call on the previous method to determine if it meets the criteria
  }
  //established to call on in main.dart to determine if there is an auth token stored locally on the device

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
      /*
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
      // */
      _token = responseData['idToken'];
      //A Firebase Auth ID token for the authenticated user. (from Firebase REST API documentation)
      _userID = responseData['localId'];
      //The uid of the authenticated user.
      _tokenExpirationDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      // print(responseData);
      /*for _tokenExpirationDate we don't receive an exact value to translate that easily within the API response
      to compensate for no value returned in the API response we call on the value that is provided to us in the API response ['expiresIn']
      once we retrieve that value ['expiresIn'] we have to translate that into a method by setting that to the current DateTime and adding the time until the token expires
      this ensures the variable _tokenExpirationDate is still valid
      */
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
