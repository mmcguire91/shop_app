import 'package:flutter/material.dart';

import '../models/product_model.dart';

class EditProductsScreen extends StatefulWidget {
  static const routeName = '/edit_products';
  @override
  _EditProductsScreenState createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageURLController = TextEditingController();
  final _imageURLFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  //allow us to interact with the State of the Form widget
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageURL: '',
  );

  // FocusNode _priceFocusNode;
  // FocusNode _descriptionFocusNode;

  @override
  void initState() {
    _imageURLFocusNode.addListener(_updateImageURL);
    super.initState();
  }
  //adding a customized listener when the page is initiatlized to execute the updateImageURL function

  @override
  void dispose() {
    _imageURLFocusNode.removeListener(_updateImageURL);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageURLController.dispose();
    _imageURLFocusNode.dispose();
    super.dispose();
  }
  //dispose of the focus node objects to avoid memory leaks

  void _updateImageURL() {
    if (!_imageURLFocusNode.hasFocus) {
      setState(() {});
    }
  }
//custom listener function
//if image URL does not have focus then update the UI and display the latest value held in the _imageURLController

  void _saveForm() {
    _form.currentState.save();
    print(_editedProduct.title);
    print(_editedProduct.description);
    print(_editedProduct.price);
    print(_editedProduct.imageURL);
  }
  //call on the current state of the form (all values currently entered in the form) and save those values

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Products'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _form,
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
                onSaved: (value) {
                  _editedProduct = Product(
                    id: null,
                    title: value,
                    price: _editedProduct.price,
                    description: _editedProduct.description,
                    imageURL: _editedProduct.imageURL,
                  );
                },
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
                onSaved: (value) {
                  _editedProduct = Product(
                    id: null,
                    title: _editedProduct.title,
                    price: double.parse(value),
                    description: _editedProduct.description,
                    imageURL: _editedProduct.imageURL,
                  );
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
                onSaved: (value) {
                  _editedProduct = Product(
                    id: null,
                    title: _editedProduct.title,
                    price: _editedProduct.price,
                    description: value,
                    imageURL: _editedProduct.imageURL,
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(
                      top: 10,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imageURLController.text.isEmpty
                        ? Text('Enter a URL')
                        : FittedBox(
                            child: Image.network(
                              _imageURLController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                    //if the _imageURLController is empty then display text to prompt user to enter a url
                    //if the _imageURLController is not empty display the value assigned to _imageURLController
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Image URL',
                      ),
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.url,
                      controller: _imageURLController,
                      //establishing a text editing controller to retrieve the value entered into the field prior to when the form is submitted
                      focusNode: _imageURLFocusNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      //calling a function with an (_) instead if calling _saveForm directly because onFieldSubmitted expects a String argument
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: null,
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          description: _editedProduct.description,
                          imageURL: value,
                        );
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).accentColor,
        onPressed: _saveForm,
      ),
    );
  }
}
