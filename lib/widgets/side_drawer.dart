import 'package:flutter/material.dart';

import '../screens/cart_screen.dart';
import '../screens/order_screen.dart';

class SideDrawer extends StatelessWidget {
  Widget hamburgerListTile({String title, IconData icon, Function onTap}) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        // style: TextStyle(
        //   fontFamily: 'RobotoCondensed',
        //   fontSize: 24,
        //   fontWeight: FontWeight.bold,
        // ),
      ),
      onTap: onTap,
    );
  }
  //listTile extracted to reduce reused code

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: <Widget>[
        AppBar(
          title: Text('Menu'),
          automaticallyImplyLeading: false,
        ),
        // Container(
        //   height: 100,
        //   width: double.infinity,
        //   padding: EdgeInsets.all(20),
        //   alignment: Alignment.centerLeft,
        //   color: Theme.of(context).accentColor,
        //   child: Text(
        //     'Menu',
        //     style: TextStyle(
        //       fontWeight: FontWeight.w900,
        //       fontSize: 30,
        //       color: Theme.of(context).canvasColor,
        //     ),
        //   ),
        // ),
        hamburgerListTile(
          title: 'Home',
          icon: Icons.home,
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        hamburgerListTile(
          title: 'Cart',
          icon: Icons.shopping_cart,
          onTap: () {
            Navigator.of(context).pushReplacementNamed(CartScreen.routeName);
          },
        ),
        hamburgerListTile(
          title: 'Order',
          icon: Icons.credit_card,
          onTap: () {
            Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
          },
        ),
      ],
    ));
  }
}
