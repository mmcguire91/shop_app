import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart';
import '../models/products_provider.dart';

//this is the widget of the individual cart items

class CartItem extends StatelessWidget {
  CartItem({this.id, this.price, this.quantity, this.title, this.productID});
  final String id;
  final String productID;
  final double price;
  final int quantity;
  final String title;

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductsProvider>(context, listen: false)
        .findByID(productID);
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        //background of the dismissible continer
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(
          right: 20,
        ),
        margin: EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 15,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productID);
      },
      //on dismiss remove item from the items map on the cart page
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to remove this item from the cart?'),
            actions: [
              FlatButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text('No'),
              ),
              //on user press no, dismiss modal and take no action (false) on argument established in onDismissed (direction)
              FlatButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text('Yes'),
              ),
              //on user press yes, dismiss modal and confirm action (true) on argument established in onDismissed (direction)
            ],
          ),
          //show alert dialog to user on attempting to remove an item from the cart
        );
      },
      //ConfirmDismiss: Confirm that they want to dismiss the item by performing behavior established within widget
      child: Card(
        margin: EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 15,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(product.imageURL),
            ),
            title: Text(title),
            subtitle: Text('\$$price x $quantity'),
            trailing: Text('Total: \$${(quantity * price)}'),
          ),
        ),
      ),
    );
  }
}
