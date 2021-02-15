import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './cart_screen.dart';

import '../widgets/catalog.dart';
import '../widgets/badge.dart';
import '../models/cart.dart';
import '../widgets/side_drawer.dart';

//catalog_disply_screen.dart is the screen which displays all products for selection

enum FilterOptions {
  Favorites,
  AllItems,
}

class CatalogDisplayScreen extends StatefulWidget {
  @override
  _CatalogDisplayScreenState createState() => _CatalogDisplayScreenState();
}

class _CatalogDisplayScreenState extends State<CatalogDisplayScreen> {
  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catalog'),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
              //update the UI according to the user selection of favorites
            },
            icon: Icon(
              Icons.filter_alt,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show all items'),
                value: FilterOptions.AllItems,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            //setting up the listener of the consumer as the badge becuase this is the data we want to update => cart item count is updating
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed('/cart');
              },
            ),
            //the IconButton itself will not update and stay consistent as only the badge with the cart item count is updating
          ),
        ],
      ),
      drawer: SideDrawer(),
      body: Catalog(_showOnlyFavorites),
    );
  }
}
