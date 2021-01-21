import 'package:flutter/material.dart';

import '../models/product_model.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [
      ..._items
    ]; //... is a speread operator. It copies the array that proceeds it
  }

  void addProduct() {
    // _items.add(value);
    notifyListeners();
  }
}
