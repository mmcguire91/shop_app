import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'edit_products_screen.dart';

import '../widgets/side_drawer.dart';
import '../widgets/manage_products_item.dart';

import '../models/products_provider.dart';

//this is the screen to manage the products that will display

Future<void> _refreshData(BuildContext context) async {
  await Provider.of<ProductsProvider>(context, listen: false).getProducts();
}
//refresh the data by waiting on the response of the products provider to make the API call to ensure the data is consistent with the display

class ManageProductsScreen extends StatelessWidget {
  static const routeName = '/manage_products';
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        title: const Text('Manage Products'),
        //const so it doesn't have to rebuild when new data is pulled in from ProductsProvider
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            //const so it doesn't have to rebuild when new data is pulled in from ProductsProvider
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductsScreen.routeName);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshData(context),
        //onRefresh property of RefreshIndicator requires a function that takes a Future so the property knows what it needs to wait on (and the duration of time)
        color: Theme.of(context).primaryColor,
        child: ListView.builder(
          itemCount: productData.items.length,
          itemBuilder: (_, index) => Column(
            children: [
              ManageProductsItem(
                id: productData.items[index].id,
                title: productData.items[index].title,
                imageURL: productData.items[index].imageURL,
              ),
              //this is built using the custom ManageProductsItem widget.
              //The named arguments are pulling data from the products provider
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
