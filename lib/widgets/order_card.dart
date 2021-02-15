import 'package:flutter/material.dart';

import '../models/orders.dart';

import 'package:intl/intl.dart';

//order card widget holds the detail of the user's order

class OrderCard extends StatelessWidget {
  OrderCard({this.order});

  final OrderItem order;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${order.amount}'),
            subtitle: Text(
              DateFormat('MM/dd/yyyy hh:mm').format(order.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(Icons.expand_more),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
