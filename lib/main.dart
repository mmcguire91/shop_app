import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/catalog_display_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './screens/order_screen.dart';
import './screens/manage_products_screen.dart';
import './screens/edit_products_screen.dart';
import './screens/auth_screen.dart';

import 'models/products_provider.dart';
import 'models/cart.dart';
import 'models/orders.dart';
import 'models/auth.dart';

void main() {
  runApp(ShopApp());
}

class ShopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          create: null,
          update: (ctx, auth, previousProductsProvider) => ProductsProvider(
            authToken: auth.tokenValid,
            itemsPrivate: previousProductsProvider == null
                ? []
                : previousProductsProvider.items,
          ),
        ),
        //track token authentication to ensure user may login and view app according to previous actions
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        )
      ],
      //establish the ChangeNotifierProvider in as high as the app hierarchy as possible in order to transmit the data / Notify the listeners further down in the app hierarchy whenever they call the listener method
      //only the widgets that are listening will be rebuilt
      //we've established an additional ChangeNotifierProvider as we'll need to notify multiple changes further down the hierarchy
      //to establish multiple ChangeNotifierProvider we've refactored our code to a MultiProvider
      /*
      - here the proper method is to use the defualt builder / create method because we are initializing the class 
      - .value is more useful when we're actually calling on an already established object
      - using .value here could lead to unnecessary re-renders or bugs
      - when you want to create a new instance of the object use the default builder / create method
      */
      child: Consumer<Auth>(
        builder: (ctx, authData, _) => MaterialApp(
          //setting up the MaterialApp within a Consumer to update everytime the Auth class has an update
          //authData is how we will be referring to the Auth class
          title: 'Flutter Shop',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Colors.blue,
            // Color.fromRGBO(134, 232, 118, 1), similar to mint green
            accentColor: Colors.white,
            // Color.fromRGBO(192, 199, 210, 1), //grey
            fontFamily: 'Lato',
          ),
          home: authData.isAuthValid ? CatalogDisplayScreen() : AuthScreen(),
          //call on the method isAuthValid in the Auth file to determine if it meets the criteria established within the method.
          //If it meets the criteria of the isAuthValid method, disaplay CatalogDisplayScreen()
          //If it does not meet the criteria of the isAuthValid method, disaplay AuthScreen()
          routes: {
            CatalogDisplayScreen.routeName: (ctx) => CatalogDisplayScreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            ManageProductsScreen.routeName: (ctx) => ManageProductsScreen(),
            EditProductsScreen.routeName: (ctx) => EditProductsScreen(),
          },
        ),
      ),
    );
  }
}
