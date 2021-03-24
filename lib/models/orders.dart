import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
//package for API calls
//'as http' requires user to specify package.DataType
import 'dart:convert';
//json encode and decoder

import './cart.dart';

//Orders.dart contains the order model and the provider for the orders

class OrderItem {
  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
  final String id;
  final double amount;
  final List<CartItem> products; //CartItem from cart.dart
  final DateTime dateTime;
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }
  //make a copy of private class _orders
  //establishing so that we cannot modify the private class

//CREATE API call
  Future<void> addOrders({List<CartItem> cartProducts, double total}) async {
    //CartItem from cart.dart

    final timeStamp = DateTime.now();
    /*
    we established this timestamp variable because this is called in 2 places below:
    1) within the API call
    2) when adding the properties of the order and assigning that to the order model, OrderItem
    we did not want to call DateTime.now() in each because they are occurring in 2 separate instances that are not processed simultaneously.
    Though that is called one directly after another, only milliseconds apart, it could lead to some data integrity issues 
    */

    final url = Uri.https(
        'shop-app-flutter-49ad1-default-rtdb.firebaseio.com', '/orders.json');
    //note that for the post URL when using this https package we had to remove the special characters (https://) in order to properly post via the API
    //establish the URL where the API call will be made
    //NOTE: posting to the orders table
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList(),
        }), //establish the API call and code that as a JSON to post the data via API to the database
        //await = we want this code to run first before performing the other actions connected to this code. AKA we are dependent on this code to run prior to performing the other actions
      );
      //perform action after API call was made
      //we wait for the API CREATE call to be successfully made then execute this code to add the new product to the manage products page
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          dateTime: timeStamp,
          products: cartProducts,
        ),
      );
      //add new item to the order
      //using insert with an index at 0 to add the latest added item to the beginning of the order list
      notifyListeners();
      //patch through the new values wherever the provider is established
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
