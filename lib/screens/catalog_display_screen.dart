import 'package:flutter/material.dart';

import '../widgets/catalog.dart';

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
