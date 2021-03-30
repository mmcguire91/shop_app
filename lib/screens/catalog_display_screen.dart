import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/catalog.dart';
import '../widgets/badge.dart';
import '../models/cart.dart';
import '../widgets/side_drawer.dart';

import '../models/products_provider.dart';

//catalog_disply_screen.dart is the screen which displays all products for selection

enum FilterOptions {
  Favorites,
  AllItems,
}

class CatalogDisplayScreen extends StatefulWidget {
  static const routeName = '/catalog';
  @override
  _CatalogDisplayScreenState createState() => _CatalogDisplayScreenState();
}

class _CatalogDisplayScreenState extends State<CatalogDisplayScreen> {
  var _showOnlyFavorites = false;
  bool _isLoading = false;
  //variable used to establish if a page is loading

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    //when the state of the screen is initialized set the value of _isLoading to true
    //by setting _isLoading to true we are establishing another state while the API call is being made
    Provider.of<ProductsProvider>(context, listen: false)
        .getProducts()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    //we are making the API call and then setting the state of _isLoading back to false indicating the change of the _isLoading variable means a completed API call
    //--> by changing the value of _isLoading prior to and after the API call it allows us to put additional functionality while the API call is made --> we established a CircularProgressIndicator which may be found in the body
    super.initState();
  }
  //the provider must have listen:false (fetch products once) on initState or else the provider will continually listen for updates in the initState method which would prevent the page from loading
  /*
  Another method using didChangeDependencies: 
  var _isInit = true;
  //variable to determine if the page is initialized / loaded

@override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<ProductsProvider>(context, listen: false).getProducts();
    }
    _isInit = false;
    super.didChangeDependencies();
  }
  */

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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            )
          : Catalog(_showOnlyFavorites),
      //if the page is loading show the circular progress indicator (during the API call). Once the API call is complete show the intended body
    );
  }
}
