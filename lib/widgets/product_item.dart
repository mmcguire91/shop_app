import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../models/cart.dart';
import '../models/product_model.dart';

//product_item.dart is the widget that holds the content of each product item within the gridview on the catalog_display_screen

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    //retrieve the product data from the Provider of type <Product>
    //establishing this as listen:false because at this point the only thing that will need rebuilding / updating within this widget is the favorite icon. --> All other information will be retrieved once and is not expected to update

    final cart = Provider.of<Cart>(context, listen: false);
    //retrieve the cart data from the Provider of type <Cart>

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
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
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
          ),
          /*
          - Consumer performs the same function of Provider.of where it listens for updates
          - Consumer is valuable to use in scenarios where you don't want your entire widget tree rebuilding, solely the items wrapped within the Consumer widget
          - Within this widget we are only expecting our favorite icon to update, thus we are limiting the rebuild of the widget tree to solely the favorite icon by wrapping it in Consumer.
          */
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
            },
            //on pressed, add the properties of the product to the cart
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
