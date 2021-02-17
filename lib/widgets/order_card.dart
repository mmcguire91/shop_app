import 'package:flutter/material.dart';
import 'dart:math';

import '../models/orders.dart';

import 'package:intl/intl.dart';

//order card widget holds the detail of the user's order

class OrderCard extends StatefulWidget {
  OrderCard({this.order});

  final OrderItem order;
  //initialize an OrderItem variable named order from orders.dart
  //OrderItem contains the properties (id, amount, title, dateTime) associated with an item

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(
              DateFormat('MM/dd/yyyy hh:mm').format(widget.order.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                  //set expanded to the opposite of whatever its current value is
                });
              },
            ),
          ),
          if (_expanded) //if _expanded built the following
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(widget.order.products.length * 20 + 30.0, 100.0),
              //multiply 20 and add base height of 10, (or) 100 --> the smaller amount total will display
              child: ListView(
                children: widget.order
                    .products //establish the children as the products contained within the order
                    .map(
                      //build
                      (prod) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3.0),
                            child: Text(
                              prod.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            '${prod.quantity} x \$${prod.price}',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ), //electing to use ListView instead of ListView.builder because we won't have a large number of unknown items being built
            ),
        ],
      ),
    );
  }
}
