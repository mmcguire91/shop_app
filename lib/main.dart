import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/catalog_display_screen.dart';
import './screens/product_detail_screen.dart';
import 'models/products_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      //establish the ChangeNotifierProvider in as high as the app hierarchy as possible in order to transmit the data / Notify the listeners further down in the app hierarchy whenever they call the listener method
      //only the widgets that are listening will be rebuilt
      create: (ctx) => ProductsProvider(),
      /*
      - here the proper method is to use the defualt builder / create method because we are initializing the class 
      - .value is more useful when we're actually calling on an already established object
      - using .value here could lead to unnecessary re-renders or bugs
      - when you want to create a new instance of the object use the default builder / create method
      */
      child: MaterialApp(
        title: 'Flutter Shop',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.blue,
          // Color.fromRGBO(134, 232, 118, 1), similar to mint green
          accentColor: Color.fromRGBO(192, 199, 210, 1),
          fontFamily: 'Lato',
        ),
        home: CatalogDisplayScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
        },
      ),
    );
  }
}
