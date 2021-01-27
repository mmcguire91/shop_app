import 'package:flutter/material.dart';

import '../widgets/catalog.dart';

//this is the screen which displays all products for selection

class CatalogDisplayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catalog'),
        backgroundColor: Colors.blue,
      ),
      body: Catalog(),
    );
  }
}
