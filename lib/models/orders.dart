import 'package:flutter/foundation.dart';
import 'package:shop_app/models/cart.dart';

import './cart.dart';

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

  void addOrders(List<CartItem> cartProducts, double total) {
    //CartItem from cart.dart
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        dateTime: DateTime.now(),
        products: cartProducts,
      ),
    );
    //add new item to the order
    //using insert with an index at 0 to add the latest added item to the beginning of the order list
    notifyListeners();
  }
}
