import 'package:flutter/material.dart';

import 'product_model.dart';
import 'http_exception.dart';

import 'package:http/http.dart' as http;
//package for API calls
//'as http' requires user to specify package.DataType
import 'dart:convert';
//json encode and decoder

//products_prodvider.dart holds all data and provides it to the listeners

class ProductsProvider with ChangeNotifier {
  ProductsProvider({this.authToken, List<Product> itemsPrivate})
      : _items = itemsPrivate;
  //in order to use the named parameters on a private class, we can't use the this.variable syntax
  //--> this._items throws error "Named option parameters can't start with an underscore.""
  //--> instead we have to name and initialize a new variable of the same type and then outside the brackets assign the private class to the initialized, named class
  final String authToken;

  List<Product> _items = [];
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

//READ API call
  Future<void> getProducts() async {
    final url = Uri.https('shop-app-flutter-49ad1-default-rtdb.firebaseio.com',
        '/products.json?auth=$authToken');
    //note that for the post URL when using this https package we had to remove the special characters (https://) in order to properly post via the API
    //establish the URL where the API call will be made
    //?auth=$authToken is a query to determine which user logging into the app (vid the authentication token associated with their last login) in order to determine what to display to the user based on their own interaction with the app
    try {
      final response = await http.get(url);
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      //retrieve the json response data stored in firebase, translate to a Map, and store that map in the jsonResponse variable
      if (jsonResponse == null) {
        return;
      }
      //if there is no data returned in the jsonResponse (the db is empty) then we do nothing, avoiding an app crash on an empty API call
      final List<Product> loadedProducts = [];
      //establish an empty list in preparation to store the new Product values retrieved from the API call
      jsonResponse.forEach((prodID, prodData) {
        //forEach will exectue a function on every value that is housed within that Map
        loadedProducts.insert(
            0,
            Product(
              id: prodID,
              title: prodData['title'],
              description: prodData['description'],
              price: prodData['price'],
              imageURL: prodData['imageURL'],
              isFavorite: prodData['isFavorite'],
            ));
        //insert at index 0 inserts the newest added product at the beginning of the list
        //retrieve the values for each of the given properties and Map them according to the values stored on the server
      });
      _items = loadedProducts;
      notifyListeners();
      //set the value of the _items list - that is the primary data of the ProductsProvider to tell the different areas of the app the data to show - equal to the values retrieved from the API call
    } catch (error) {
      print(error);
      throw (error);
    }
  }

//CREATE API call
  Future<void> addProduct(Product product) async {
    //running a Future async API call meaning that we want this to run asynchronously from our code
    final url = Uri.https(
        'shop-app-flutter-49ad1-default-rtdb.firebaseio.com', '/products.json');
    //note that for the post URL when using this https package we had to remove the special characters (https://) in order to properly post via the API
    //establish the URL where the API call will be made
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageURL': product.imageURL,
          'price': product.price,
          'isFavorite': product.isFavorite,
        }), //establish the API call and code that as a JSON to post the data via API to the database
        //await = we want this code to run first before performing the other actions connected to this code. AKA we are dependent on this code to run prior to performing the other actions
      );
      //perform action after API call was made
      //we wait for the API CREATE call to be successfully made then execute this code to add the new product to the manage products page
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
      //this code block established outside of the CREATE (post) API response was previously wrapped in a .then statement but replaced by async await
    } catch (error) {
      print(error);
      throw error;
      //throw error is establishing a new instance of that error to allow us to call on it anywhere within the code where the provider method is called
    }
    //catch(error) works as a catch-all for the entire function so that any error that is thrown anywhere within the function, DART will immediately skip to the catch(error) method and run the code in that function
  }

//UPDATE API call
  Future<void> updateProduct({String id, Product updatedProduct}) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.https(
          'shop-app-flutter-49ad1-default-rtdb.firebaseio.com',
          '/products/$id.json');
      //note that for the URL when using this https package we had to remove the special characters (https://) in order to properly post via the API
      //establish the URL where the API call will be made
      //note that the URL is different from that of the READ and CREATE API calls- here we are targeting the ID of the existing product
      try {
        await http.patch(url,
            body: json.encode({
              'title': updatedProduct.title,
              'description': updatedProduct.description,
              'imageURL': updatedProduct.imageURL,
              'price': updatedProduct.price,
            }));
        //perform the UPDATE API call to update the given productID with the defined values that should match the fields already established in the firebase db
        //ensure the values in the map match those expected data fields in Firebase so that the UPDATE request will be successful
        _items[prodIndex] = updatedProduct;
        notifyListeners();
      } catch (error) {
        print(error);
        throw (error);
      }
    }
  }

  //DELETE API call
  Future<void> deleteProduct(String id) async {
    final url = Uri.https('shop-app-flutter-49ad1-default-rtdb.firebaseio.com',
        '/products/$id.json');
    //note that for the URL when using this https package we had to remove the special characters (https://) in order to properly post via the API
    //establish the URL where the API call will be made
    //note that the URL is different from that of the READ and CREATE API calls - here we are targeting the ID of the existing product
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    //identify the index that you are trying to target
    //remove the id of the element (prod) is equal to the id that is targeted from the list of items
    var existingProduct = _items[existingProductIndex];
    //variable existing product = the index we are trying to target (the product id which is the primary key of the record stored in the db) within the items list
    _items.removeAt(existingProductIndex);
    //target the index of the oriduct and remove it from the list
    notifyListeners();
    //OPTIMISTIC UPDATING
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      //in the case that we encounter an error we should take the record of the product that we are attempting to delete and insert that back into the list
      notifyListeners();
      throw HttpException(message: 'Could not delete product');
    }
    //custom error handling if the web response returns a 400 or higher
    //if the web response returns an unexecutable error code we throw the error handling exception
    //if there is an error that occurs the code will stop running at the throw exception
    existingProduct = null;
    //call the API to change the value of the existingProduct = null which removes the existingProductIndex (or the record of the product) from the list of products in the db
  }
}

/*WHAT's HAPPENING HERE?
_items.removeAt(existingProductIndex);
    //we are immedidately removing the targeted record of the product by targeting the ID
    
    notifyListeners();
    //notifying everyone that the record of the product was removed from the list
    
    //OPTIMISTIC UPDATING
    final response = await http.delete(url);
    //after we are communicating throughout the app that the product has been removed we are pinging the API to remove the product record from the db
       
       if (response.statusCode >= 400) {
        //if we receive a response from the server that we are unable to execute

        _items.insert(existingProductIndex, existingProduct);
        //in the case that we encounter an error we should take the record of the product that we are attempting to delete and insert that back into the list
        
        notifyListeners();
        //notify all listeners that we encountered an error in the server response (the item couldn't be deleted from the db) and therefore adding it back to the list 

        throw HttpException(message: 'Could not delete product');
        //because we were unable to delete the product we are throwing an exception
      }

    existingProduct = null;
    //if all the code above is successfully run we are deleting the cached instance of the product
 */
