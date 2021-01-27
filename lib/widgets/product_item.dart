import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../models/product_model.dart';

//product_item.dart is the widget that holds the content of each product item within the gridview on the catalog_display_screen

class ProductItem extends StatelessWidget {
  // ProductItem({
  //   this.id,
  //   this.title,
  //   this.imageURL,
  // });

  // final String id;
  // final String title;
  // final String imageURL;

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    //retrieve the product data from the Provider of type <Product>

    return ClipRRect(
      //ClipRRect forces the child to adhere to speceific defined styling properties
      //ClipRRect stands for clip rounded rectangles
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
              //forward the ID of the given item the user taps on in order to display the relevant next page
            );
          },
          child: Image.network(
            product.imageURL,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: IconButton(
            icon: Icon(
              product.isFavorite ? Icons.favorite : Icons.favorite_border,
              //change the status of the UI for the favorite icon according to the isFavorite method
              color: Colors.red,
            ),
            onPressed: () {
              product.toggleFavoriteStatus();
              //onPressed toggle the status of the void method toggleFavoriteStatus established in product_model.dart
            },
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {},
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
