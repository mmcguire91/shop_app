import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';
import '../models/http_exception.dart';

//holds authentication UI and logic

enum AuthMode { Signup, Login }

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  //VOID function to display a dialog modal. We will use this to display a dialog modal and populate the message with whatever error message the API call returns
  void _errorDialog({String message}) {
    showDialog(
      //in the case that an error occurs, by us putting the return in front of showDialog, showDialog will fulfill that Future in case of the error. If there is no error the .then will fulfill the expected Future value
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An error occurred'),
        content: Text(message),
        //we will change the value of message to display according to what the API call returns
        actions: [
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  //SUBMIT button logic
  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    //Invalid response from user
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    //ATTEMPT TO MAKE API CALLS BASED ON ENUM STATE OF DISPLAY
    try {
      if (_authMode == AuthMode.Login) {
        //USER LOGIN
        //call the sign in (read) API
        await Provider.of<Auth>(context, listen: false).signin(
          _authData['email'],
          _authData['password'],
        );
      } else {
        //REGISTER USER
        //call the register (create) API
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['email'],
          _authData['password'],
        );
      }
    }
    /*
    on HttpException catch (error) {
      //TODO: This is not properly receiving the error response from the Auth file
      //we are conducting a filter on the type of errors we want to handle within this block.
      //here we are calling on the HttpException that was thrown in the _authenticate method in Auth
      var httpErrorMessage = 'Could not login or sign up.';
      //all of the following error messages were retrieved from the Firebase Auth API documentation
      if (error.toString().contains('EMAIL_EXISTS')) {
        //if the API call retrieves a value of 'EMAIL_EXISTS' in the error message
        httpErrorMessage = 'This email is alreary in use';
        //display the above error message
      } else if (error.toString().contains('INVALID_EMAIL')) {
        //if the API call retrieves a value of 'INVALID_EMAIL' in the error message
        httpErrorMessage = 'This is not a valid email.';
        //display the above error message
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        //if the API call retrieves a value of 'EMAIL_NOT_FOUND' in the error message
        httpErrorMessage = 'Could not find a user with that email.';
        //display the above error message
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        //if the API call retrieves a value of 'INVALID_PASSWORD' in the error message
        httpErrorMessage = 'Invalid password.';
        //display the above error message
      }
      _errorDialog(message: httpErrorMessage);
      //call the error dialog method
      //display in the message whatever defined message to display according to the API error response
    }
    */
    catch (error) {
      //calling on the error that was established in the Auth class catch(error) {throw error} method in the addProduct function
      const errorMessage =
          'Experiencing network difficulties. Please try again';
      _errorDialog(message: errorMessage);
      //call the error dialog method
      //display in the message whatever defined message to display according to the API error response
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.Signup ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                //E-MAIL
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                //PASSWORD
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                    //if the password field is empty or has less than 6 characters
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                //IF the user is on Signup screen display password confirmation textfield, otherwise do not
                if (_authMode == AuthMode.Signup)
                  //VERIFY PASSWORD
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                            //if the validation field passwords do not match
                          }
                        : null,
                  ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  ElevatedButton(
                    child: Text(
                      _authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP',
                      //if the user is seeking the login page, display login button. Else display sign up button
                    ),
                    onPressed: _submit,
                    //call the submit method
                    style: ElevatedButton.styleFrom(
                      //styleFrom is a way to implement the expected simple values opposed to establishing MaterialStateProperty states
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      primary: Theme.of(context).primaryColor,
                      textStyle: TextStyle(
                        color: Theme.of(context).primaryTextTheme.button.color,
                      ),
                    ),
                  ),
                //LOGIN or SIGN UP button
                TextButton(
                  child: Text(
                    '${_authMode == AuthMode.Login ? 'SIGN UP' : 'LOGIN'}',
                  ),
                  //if the user is on the login page then display a button to sign up. If they are on the sign up page display an option to login
                  onPressed: _switchAuthMode,
                  //call the switchAuthMode method
                  style: TextButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
