import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart' show Cart;
//identifying that we only want to retrieve the Cart class from cart.dart
//we are doing this because there is also another CartItem class established in cart.dart

import '../widgets/cart_item.dart';

//this is the screen for the Cart page

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: cart.items.length,
              itemBuilder: (ctx, index) => CartItem(
                id: cart.items.values.toList()[index].id,
                price: cart.items.values.toList()[index].price,
                quantity: cart.items.values.toList()[index].quantity,
                title: cart.items.values.toList()[index].title,
                productID: cart.items.keys.toList()[index],
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.all(15.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Total',
                      style: TextStyle(
                        fontSize: 20,
                      )),
                  Spacer(),
                  Chip(
                    label: Text('\$${cart.totalAmount}'),
                  ),
                  FlatButton(
                    child: Text('order now'.toUpperCase()),
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
