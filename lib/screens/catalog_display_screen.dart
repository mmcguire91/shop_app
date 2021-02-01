import 'package:flutter/material.dart';

import '../widgets/catalog.dart';

//this is the screen which displays all products for selection

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
        ],
      ),
      body: Catalog(_showOnlyFavorites),
    );
  }
}
