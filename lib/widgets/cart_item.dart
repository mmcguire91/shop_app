import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../models/product_model.dart';
// import 'product_item.dart';

//this is the widget of the individual cart items

class CartItem extends StatelessWidget {
  CartItem({this.id, this.price, this.quantity, this.title});
  final String id;
  final double price;
  final int quantity;
  final String title;

  @override
  Widget build(BuildContext context) {
    // final product = Provider.of<Product>(context, listen: false);
    return Card(
      margin: EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 15,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: FittedBox(
              child: Text(
                '\$$price',
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          //Image.network(product.imageURL),
          title: Text(title),
          subtitle: Text('x $quantity'),
          trailing: Text('Total: \$${(quantity * price)}'),
        ),
      ),
    );
  }
}
