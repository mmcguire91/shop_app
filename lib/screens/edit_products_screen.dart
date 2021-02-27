import 'package:flutter/material.dart';

class EditProductsScreen extends StatefulWidget {
  static const routeName = '/edit_products';
  @override
  _EditProductsScreenState createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  // FocusNode _priceFocusNode;
  // FocusNode _descriptionFocusNode;

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }
  //dispose of the focus node objects to avoid memory leaks

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
                textInputAction: TextInputAction.next,
                //provide UI element to prompt user that pressing will go to the next active user input
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                //establish the logic to go to the next user input
                //onFieldSubitted (we don't care about the value entered into the text field)
                //--> Focus the Scope on the node that has the vaule of the _priceFocusNode identified
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                //numpad keyboard type
                focusNode: _priceFocusNode,
                //finishing the logic of go to the next available user input by defining this TextFormField as the node you want to target
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 3,
                // textInputAction: TextInputAction.next,
                keyboardType: TextInputType.multiline,
                //numpad keyboard type
                focusNode: _descriptionFocusNode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
