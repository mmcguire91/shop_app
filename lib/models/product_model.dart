import 'package:flutter/foundation.dart';

class Product {
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
}
