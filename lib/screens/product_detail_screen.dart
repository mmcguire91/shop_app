import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productID = ModalRoute.of(context).settings.arguments as String;
    //retrive the product ID passed over from the product item
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
    );
  }
}
