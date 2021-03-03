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
      if ((!_imageURLController.text.startsWith('http') &&
              !_imageURLController.text.startsWith('https')) ||
          //ensure the user enters a valid url
          (!_imageURLController.text.endsWith('.png') &&
              !_imageURLController.text.endsWith('.jpg') &&
              !_imageURLController.text.endsWith('.jpeg'))) {
        //ensure the user enters a valid url
        return;
      }
      //validation for the updateImage function
      setState(() {});
    }
  }
//custom listener function
//if image URL does not have focus then update the UI and display the latest value held in the _imageURLController

  void _saveForm() {
    final isValid = _form.currentState.validate();
    //save validation function to isValid varible
    if (!isValid) {
      return;
    }
    //if the form does not pass validation do not perform other functions within _saveForm()
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
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter a title';
                  }
                  return null;
                },
                //validation for title text field
                //if there is no characters in the title text field return error text, else do nothing
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
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Enter a number';
                  }
                  //ensure the user enters a number value
                  if (double.tryParse(value) <= 0) {
                    return 'Enter a number greater than 0';
                  }
                  //ensure the user cannot create a free product
                  return null;
                  //if passes all conditions do nothing
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
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter a description';
                  }
                  if (value.length < 5) {
                    return 'Enter at least 5 characters';
                  }
                  return null;
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
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter an image URL';
                        }
                        if (value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'Enter a valid URL';
                        }
                        //ensure the user enters a valid url
                        if (!value.endsWith('.png') &&
                            !value.endsWith('.jpg') &&
                            !value.endsWith('.jpeg')) {
                          return 'Enter a valid image URL';
                        }
                        //ensure the user enters a valid image URL and not a malicious URL link or other file
                        return null;
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
