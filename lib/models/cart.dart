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
  //establishing so that we can't make any modifications to the private class

  int get itemCount {
    return _items.length;
  }
//retrieve a count of items in cart

  double get totalAmount {
    double total = 0.00;
    _items.forEach((key, cartItem) {
      total += cartItem.quantity * cartItem.price;
    });
    return total;
  }
  /*
  calculate cart total
  - go through all entries in the _items map, retrieve the key and value for each entry
  - multiply the quantity of each item in cart by that specific item's price, and add that back to the total
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

  void removeItem(String productID) {
    _items.remove(productID);
    notifyListeners();
  }
  //remove an item from the map of _items to remove the item with the given productID from the cart

  void removeSingleItem(String productID) {
    if (!_items.containsKey(productID)) {
      return;
    }
    //if there is not an item that contains the productID then do nothing
    if (_items[productID].quantity > 1) {
      _items.update(
        productID,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity - 1,
        ),
      );
    }
    //if there is an item with a productID in the cart that contains a quantity greater than 1 then update the item with that productID to subtract the quantity in the cart by 1
    else {
      _items.remove(productID);
    }
    //if there is an item with a productID in the cart that contains a quantity of 1 then remove that item
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
  //remove all items from the map of _items to empty the cart
}
