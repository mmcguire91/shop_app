import 'package:flutter/material.dart';

import './screens/catalog_display_screen.dart';
import 'screens/product_detail_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
