import 'package:flutter/material.dart';

class EditProductsScreen extends StatefulWidget {
  static const routeName = '/edit_products';
  @override
  _EditProductsScreenState createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Products'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                textInputAction:
                    TextInputAction.next, //go to the next active user input
              ),
            ],
          ),
        ),
      ),
    );
  }
}
