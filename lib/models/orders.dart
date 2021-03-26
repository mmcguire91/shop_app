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

  bool isLoading = false;

//READ API call
  Future<void> getOrders() async {
    final url = Uri.https(
        'shop-app-flutter-49ad1-default-rtdb.firebaseio.com', '/products.json');
    //note that for the post URL when using this https package we had to remove the special characters (https://) in order to properly post via the API
    //establish the URL where the API call will be made
    try {
      isLoading = true;
      // by setting isLoading to true we are establishing a value to reference for a loading spinner when this READ API call is referenced in the orders screen
      final response = await http.get(url);
      // print(json.decode(response.body));
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      //retrieve the json response data stored in firebase, translate to a Map, and store that map in the jsonResponse variable
      if (jsonResponse == null) {
        return;
      }
      //if there is no data returned in the jsonResponse (the db is empty) then we do nothing, avoiding an app crash on an empty API call
      final List<OrderItem> orderProducts = [];
      //establish an empty list in preparation to store the new Order values retrieved from the API call
      jsonResponse.forEach((orderID, orderData) {
        //forEach will exectue a function on every value that is housed within that Map
        orderProducts.insert(
            0, //insert at index 0 inserts the newest added product at the beginning of the list
            OrderItem(
              id: orderID,
              amount: orderData['amount'],
              dateTime: DateTime.parse(orderData['dateTime']),
              products: (orderData['products'] as List<dynamic>)
                  .map(
                    (item) => CartItem(
                      id: item['id'],
                      title: item['title'],
                      quantity: item['quantity'],
                      price: item['price'],
                    ),
                  )
                  .toList(),
              //since products is stored on the db as a map, we have to retrieve those values and define how the properties of the items stored in the db should be mapped --> recreating our CartItem as it's stored in the db
            ));
        //retrieve the values for each of the given properties and Map them according to the values stored on the server
      });
      _orders = orderProducts;
      notifyListeners();
      //set the value of the _items list - that is the primary data of the ProductsProvider to tell the different areas of the app the data to show - equal to the values retrieved from the API call
      isLoading = false;
      //setting isLoading to false we are noting that the API call has been made. Will be referenced in the orders screen signaling for the loading spinner to stop
    } catch (error) {
      print(error);
      throw (error);
    }
  }

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
