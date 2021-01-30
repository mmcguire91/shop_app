import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/products_provider.dart';
import 'product_item.dart';

//this is the content of the catalog display screen

class Catalog extends StatelessWidget {
  Catalog(this.showFavorites);
  final bool showFavorites;
  //initializing and accepting the _showOnlyFavorites variable from CatalogDisplayScreen

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    /*
    establish a direct communication channel to the provided instance of the ProductsProvider class
    listen for a change in <ProductsProvider>
    because this is listening for a change in type <ProductsProvider> it goes up the widget tree to its parent widgets 
    (catalog.dart --> catalog_display_screen.dart --> main.dart) [Provider for ProductsProvider is established within the ChangeNotifierProvider at the top of the widget tree in main.dart]
    whenever a change occurs the children widget affected will be rebuilt
    */
    final products =
        showFavorites ? productsData.favoriteItems : productsData.items;
    //retrieve the data from the items within the ProductsProvider class
    //return showfavorites according to if the favorite items
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: products.length,
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
          value: products[index],
          /*
          - ChangeNotifierProvider.value is appropriate to use when a Provider is used on a list or a grid so the entire widget is not rebuilt
          - In .value the Provider is specifically tied to its data and detached from the widget
          - Should be used when you have the Provider package and you're providing data on single List or Grid items
          - If we used builder it would cause bugs as soon as we have items that go beyond the screen boundries because of the way widgets are recycled and data changes, Provider would be unable to keep up with all changes--> .value will keep up
          - .value here is useful because we are actually reusing the object that has been established in main.dart
          - if we use a screen that replaces another screen it's important that we clean up our provided data because if we don't the data will be stored within the app itself and lead to memory overflow --> ChangeNotifierProvider does this regardless of if you use the builder / create method or .value
          */
          child: ProductItem(
              // id: products[index].id,
              // title: products[index].title,
              // imageURL: products[index].imageURL,
              ),
        );
        //populate the ProductItem widget with data retrieved from the provider
      },
      //populate the GridView with the itemBuilder method that returns ProductItems
    );
  }
}
