import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';

//Trying to establish error dialog to call anywhere in app.

//TODO: Make this work

class ErrorDialog {
  Future<void> _showDialog(BuildContext context) async {
    return showDialog<Null>(
      //adding await because we don't want the finally code block to run prior to error handling to occur if necessary
      //when an error occurrs also prompt the user with a dialog box
      //in the case that an error occurs, by us putting the return in front of showDialog, showDialog will fulfill that Future in case of the error. If there is no error the .then will fulfill the expected Future value
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An error occurred'),
        content: Text('Something went wrong. Please try again.'),
        // Text(error.toString()),
        //we are calling error.toString here but normally we wouldn't want to do this due to security concerns
        //normally we would want to say something like 'Something went wrong'
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
}
