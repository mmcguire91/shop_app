import 'package:flutter/material.dart';

import 'product_model.dart';

//products_prodvider.dart holds all data and provides it to the listeners

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageURL:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageURL:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageURL:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'Cast Iron Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageURL:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];
  //made private class because we do not want these items to be editable

  List<Product> get items {
    return [..._items];
    //... is a speread operator. It copies the array that proceeds it
  }

  List<Product> get favoriteItems {
    return _items.where((prodItems) => prodItems.isFavorite).toList();
  }
//retrieve the items that have been marked as favorite
//.isFavorite method is defind in product_model.dart

  Product findByID(String id) {
    return _items.firstWhere((product) => product.id == id);
  }
  //by the user clicking on a specific product it will identify the productID and all information associated with that product

  void addProduct() {
    // _items.add(value);
    notifyListeners();
  }
}
