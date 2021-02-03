import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

//cart.dart establishes the logic associated with the cart

class CartItem {
  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });

  final String id;
  final String title;
  final int quantity;
  final double price;
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }
  //return a copy of private class _items

  int get itemCount {
    return _items.length;
  }
//retrieve a count of items in cart

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.quantity * cartItem.price;
    });
    return total;
  }
  /*
  calculate cart total
  - go through all entries in the _items map, retrieve the key and value for each entry
  */

  void addItem(String productID, double price, String title) {
    if (_items.containsKey(productID)) {
      _items.update(
        productID,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
      //if the existingCartItem (item present in cart) matches the productID of the item that the user is adding to the cart, update the quantity of that item by adding 1
    } else {
      _items.putIfAbsent(
        productID,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
      //if the item (determined by the productID) is absent from the cart, add the item and its properties to the cart
    }
    notifyListeners();
  }
}
