import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/orders.dart';

import '../widgets/order_card.dart';
import '../widgets/side_drawer.dart';

//OrderScreen displays the user's order

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Order'),
      ),
      body: Consumer<Orders>(builder: (context, orderData, child) {
        return orderData.isLoading == true
            ? Center(
                child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor),
              )
            : ListView.builder(
                itemCount: orderData.orders.length,
                itemBuilder: (ctx, index) => OrderCard(
                  order: orderData.orders[index],
                ),
                //populate the order card UI element with data provided by the orders method within orders.dart
                //this data is retrieved by calling the provider of type orders
              );
      }),
      drawer: SideDrawer(),
    );
  }
}
