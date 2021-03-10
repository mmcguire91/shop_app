import 'package:flutter/material.dart';

import 'product_model.dart';

import 'package:http/http.dart' as http;
//package for API calls
//'as http' requires user to specify package.DataType
import 'dart:convert';
//json encode and decoder

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
      title: 'Not Levi\'s jeans',
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
      title: 'Cast Iron Skillet',
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

  Future<void> addProduct(Product product) {
    final url = Uri.https(
        'shop-app-flutter-49ad1-default-rtdb.firebaseio.com', '/products.json');
    //note that for the post URL when using this https package we had to remove the special characters (https://) in order to properly post via the API
    //establish the URL where the API call will be made
    return http
        .post(
      url,
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'imageURL': product.imageURL,
        'price': product.price,
        'isFavorite': product.isFavorite,
      }), //establish the API call and code that as a JSON to post the data via API to the database
    )
        .then((response) {
      final newProduct = Product(
        title: product.title,
        description: product.description,
        imageURL: product.imageURL,
        price: product.price,
        id: json.decode(response.body)['name'],
        //establish as the ID assigned in Firebase
      );
      _items.add(newProduct);
      // _items.insert(0, product); //if we want to add the newly added product to the top of the list
      notifyListeners();
    });
    //.then = perform action after API call was made
    //we wait for the API CREATE call to be successfully made THEN add the new product to the manage products page
  }
  //expecting to return the value of a future. We may establish the return higher in the hierarchy but the actual future value is returned through the .then function

  void updateProduct({String id, Product updatedProduct}) {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = updatedProduct;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
