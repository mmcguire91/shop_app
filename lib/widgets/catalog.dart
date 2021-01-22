import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import 'product_item.dart';

class Catalog extends StatelessWidget {
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
    final products = productsData.items;
    //retrieve the data from the items within the ProductsProvider class
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
        return ProductItem(
          id: products[index].id,
          title: products[index].title,
          imageURL: products[index].imageURL,
        );
        //populate the ProductItem widget with data retrieved from the provider
      },
      //populate the GridView with the itemBuilder method that returns ProductItems
    );
  }
}
