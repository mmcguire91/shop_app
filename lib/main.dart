import 'package:flutter/material.dart';

import './screens/catalog_display_screen.dart';

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
        primaryColor: Color.fromRGBO(134, 232, 118, 1),
        accentColor: Color.fromRGBO(192, 199, 210, 1),
        fontFamily: 'Lato',
      ),
      home: CatalogDisplayScreen(),
    );
  }
}
