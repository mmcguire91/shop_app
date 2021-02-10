import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productID = ModalRoute.of(context).settings.arguments as String;
    //retrive the product ID passed over from the product item

    final loadedProduct = Provider.of<ProductsProvider>(
      context,
      listen: false,
    ).findByID(productID);
    /*
    listen: false changes the default value of the provider package from listen: true
    listen: true as the deafault value rebuilds the widget any time the provider package is updated with new data
    listen: false retrieves the information gloabally from the provider package once and does not rebuild every time the data is updated
    */
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                loadedProduct.imageURL,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '\$${loadedProduct.price}',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '${loadedProduct.description}',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
