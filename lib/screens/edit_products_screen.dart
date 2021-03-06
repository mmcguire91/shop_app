import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../models/products_provider.dart';

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

  var _isInit = true;
//is the screen loading / being initialized for the first time

  var _isLoading = false;
  //establish variable to determine if the page is loading for purposes of loading progress indicator

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageURL': '',
  };
  //setting the intialized values to empty and priming for populating them with data should the user choose to edit a product

  // FocusNode _priceFocusNode;
  // FocusNode _descriptionFocusNode;
  //could not establish like this because it would not work with the .dispose method

  @override
  void initState() {
    _imageURLFocusNode.addListener(_updateImageURL);
    super.initState();
  }
  //adding a customized listener when the page is initiatlized to execute the updateImageURL function

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productID = ModalRoute.of(context).settings.arguments as String;
      //retrieve the product id from the route where the arguments are established (from manageProductsItem)
      if (productID != null) {
        _editedProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findByID(productID);
        //set the value of the edited product to the value of the ProductsProvider where the argument is retrieved from the modal route
        //you passed the ID of the product you want to edit via the ManageProductsItem widget in the ManageProductsScreen. This function pulls the ID of the product you just decided to edit and now populates the _editedProduct variable with the values of that product
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageURL': '',
        };
        //setting the initialized values of the fields according to the product that the user is choosing to edit
        _imageURLController.text = _editedProduct.imageURL;
        //because we set the behavior to update the value of the imageURL container (preview image) whenever the focus is taken away from the imageURL text field we need to establish a different behavior than all others in the map.
      }
      //if there is a productID that is passed over then populate the fields with the values of the productID
    }
    _isInit = false;
    super.didChangeDependencies();
  }
  //if the screen is being initialized, populate it with the values of the productID passed over from the given product the user pressed the edit button on from ManageProductsScreen then set the value of _isInit to false

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

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    //save validation function to isValid varible
    //.validate = Validates every [FormField] that is a descendant of this [Form], and returns true if there are no errors.
    if (!isValid) {
      return;
    }
    //if the form does not pass validation do not perform other functions within _saveForm()
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    //setting the state of isLoading to true while we execute the method and before we navigate back to the previous page
    if (_editedProduct.id != null) {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .updateProduct(
          id: _editedProduct.id,
          updatedProduct: _editedProduct,
        );
      } catch (error) {
        //calling on the error that was established in the productsProvider class catch(error) {throw error} method in the addProduct function
        await showDialog<Null>(
          //adding await because we don't want the finally code block to run prior to error handling to occur if necessary
          //when an error occurrs also prompt the user with a dialog box
          //in the case that an error occurs, by us putting the return in front of showDialog, showDialog will fulfill that Future in case of the error. If there is no error the .then will fulfill the expected Future value
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred'),
            content: Text(error.toString()),
            //we are calling error.toString here but normally we wouldn't want to do this due to security concerns
            //normally we would want to say something like 'Something went wrong'
            actions: [
              TextButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      }
    }
    //if we are editing a product that currently has an id we know that the product already exists becuase it has an ID value
    //providing the product that currently has an id and passing that back to the updateProduct method in the Provider that will globally update the app where ever the product provider is called

    else {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(_editedProduct);
      } //in the case that the id of a product that we are editing == null then we want to try to add the edited product using the addProduct function in the ProductsProvider
      //we are using try because we are attempting to make an API call, we would not use this for locally handled data
      //using await becuase we want to wait on the API call to be attempted prior to executing any other code meaning that the result that could occur (item being added to the manage products screen) is dependent on this API call being made
      //--> we don't want API call to be made asynchronously on the manage products page where we want the manage products page to load without the new product present and then have the new product populate once the user is already on the page (preventing a user from thinking the app is glitching)
      catch (error) {
        //calling on the error that was established in the productsProvider class catch(error) {throw error} method in the addProduct function
        await showDialog<Null>(
          //adding await because we don't want the finally code block to run prior to error handling to occur if necessary
          //when an error occurrs also prompt the user with a dialog box
          //in the case that an error occurs, by us putting the return in front of showDialog, showDialog will fulfill that Future in case of the error. If there is no error the .then will fulfill the expected Future value
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred'),
            content: Text(error.toString()),
            //we are calling error.toString here but normally we wouldn't want to do this due to security concerns
            //normally we would want to say something like 'Something went wrong'
            actions: [
              TextButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      }
      //We commented out finally {} because we moved the setState((){}) function down in our code logic to execute after the 3 different await methods are attempted so finally was no longer required
      // finally {
      //   //finally only works with try and catch. Code wrapped in finally will run regardless if the code is run in the try or catch block
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   //setting the state as _isLoading to false after the function has been executed but before navigating back to the previous page
      //   Navigator.of(context).pop();
      //   //user will stay on the previous page while the function is executed. While the function is executed, the loading progress indicator will persist. Once function is complete, the user will be navigated back to the previous page
      // }
    }
    //this setState will run only after the 3 await methods above are attempted
    setState(() {
      _isLoading = false;
    });
    //setting the state as is loading to false after the function has been executed but before navigating back to the previous page
    Navigator.of(context).pop();
    //user will stay on the previous page while the function is executed. While the function is executed, the loading progress indicator will persist. Once function is complete, the user will be navigated back to the previous page
  }
  //call on the current state of the form (all values currently entered in the form) and save those values

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Products'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ) //if the page isLoading (the function is executing) display the loading progress indicator
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    //TITLE
                    TextFormField(
                      initialValue: _initValues['title'],
                      //populate the field with the initialized value whether passing over a productID or creating a new product
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
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
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
                    //PRICE
                    TextFormField(
                      initialValue: _initValues['price'],
                      //populate the field with the initialized value whether passing over a productID or creating a new product
                      decoration: InputDecoration(
                        labelText: 'Price',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      //numpad keyboard type
                      focusNode: _priceFocusNode,
                      //finishing the logic of go to the next available user input by defining this TextFormField as the node you want to target
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
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
                    //DESCRIPTION
                    TextFormField(
                      initialValue: _initValues['description'],
                      //populate the field with the initialized value whether passing over a productID or creating a new product
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
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
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
                    //IMAGE URL
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
                            //The text form field cannot take both an initial value and a text editing controller so we assigned the text editing controller (_imageURLController) with the initialized value (whether there was a productID passed over or not) and pass it back to the TextFormField. This was done in the didChangeDependencies function.
                            focusNode: _imageURLFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            //calling a function with an (_) instead if calling _saveForm directly because onFieldSubmitted expects a String argument
                            onSaved: (value) {
                              _editedProduct = Product(
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
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
