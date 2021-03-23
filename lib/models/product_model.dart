import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
//package for API calls
//'as http' requires user to specify package.DataType
import 'dart:convert';
//json encode and decoder

class Product with ChangeNotifier {
  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageURL,
    this.isFavorite = false,
  });
  //({}) curly bracket inside parentheses configures this as named arguments
  //() parentheses only would be positional arguments

  final String id;
  final String title;
  final String description;
  final double price;
  final String imageURL;
  bool isFavorite;

//establishing void method to eliminate code duplication
  void _setFavoriteStatus({bool favoriteValue}) {
    isFavorite = favoriteValue;
    notifyListeners();
  }

//Store the FAVORITE status in an API call to the db
  Future<void> toggleFavoriteStatus() async {
    final oldStatus = isFavorite;
    //storing the value of the old status in the case that the API call fails we may persist the old status to reflect to the user that the value has not been stored on the server
    isFavorite = !isFavorite;
    notifyListeners();
    //toggle the status of favorite button
    final url = Uri.https('shop-app-flutter-49ad1-default-rtdb.firebaseio.com',
        '/products/$id.json');
    //URL of the API call
    //try to make the API call
    try {
      final response = await http.patch(
        url,
        body: json.encode({
          'isFavorite': isFavorite,
        }),
        //encode the value of isFavorite variable to update the isFavorite field in the db
      );
      //store the response of the API call in the variable, response
      //OPTIMISTIC UPDATING
      if (response.statusCode >= 400) {
        //if the API response returns an error
        _setFavoriteStatus(
          favoriteValue: oldStatus,
        );
        //reset the value of isFavorite to the isFavorite value that we're caching
      }
    } catch (error) {
      _setFavoriteStatus(
        favoriteValue: oldStatus,
      );
      //reset the value of isFavorite to the isFavorite value that we're caching
    }
  }
}
